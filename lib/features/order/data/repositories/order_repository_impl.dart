import 'package:dartz/dartz.dart' hide Order;
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saji_pos_app/features/order/data/datasource/order_remote_data_source.dart';
import 'package:saji_pos_app/features/order/data/models/order_request_model.dart';
import 'package:saji_pos_app/features/order/data/models/order_item_request_model.dart';
import 'package:saji_pos_app/features/order/domain/entities/order.dart';
import 'package:saji_pos_app/features/order/domain/entities/order_item.dart';
import 'package:saji_pos_app/features/order/domain/entities/order_request.dart';
import 'package:saji_pos_app/features/order/domain/repositories/order_repository.dart';

import 'package:saji_pos_app/features/order/data/datasource/order_local_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.authLocalDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Order>> submitOrder(OrderRequest request) async {
    try {
      // 1. Simpan ke SQLite lokal terlebih dahulu (Queue)
      final localOrderId = await localDataSource.saveOrderOffline(request);

      // Kita buat object Order sementara dari data lokal
      final offlineOrder = Order(
        id: localOrderId,
        cashierId: request.cashierId,
        transactionTime: request.transactionTime,
        subTotal: request.subTotal.toInt(),
        discountAmount: request.discountAmount.toInt(),
        shippingCost: request.shippingCost.toInt(),
        serviceCharge: request.serviceCharge.toInt(),
        tax: request.tax.toInt(),
        total: request.total.toInt(),
        paymentMethod: request.paymentMethod,
        orderItems: request.orderItems.map((item) => OrderItem(
          id: 0,
          orderId: localOrderId,
          productId: item.productId,
          quantity: item.quantity,
          price: item.price.toInt(),
          note: item.note,
        )).toList(),
      );

      // 2. Ambil token untuk mencoba kirim ke server
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        // Jika tidak ada token (belum login tapi bisa transaksi offline?), 
        // kita biarkan statusnya offline (0)
        return Right(offlineOrder);
      }

      // 3. Coba kirim ke server (PUSH)
      try {
        final model = OrderRequestModel.fromEntity(request);
        final result = await remoteDataSource.submitOrder(token, model);
        
        // Jika berhasil, update status di SQLite menjadi isSynced = 1
        await localDataSource.updateOrderSyncedStatus(localOrderId, result.id ?? 0);
        
        return Right(result.toEntity());
      } catch (e) {
        // Jika server mati atau tidak ada internet, JANGAN lempar error!
        // Karena pesanan sudah aman di SQLite lokal, kembalikan offlineOrder
        return Right(offlineOrder);
      }
    } catch (e) {
      return Left(ServerFailure('Gagal menyimpan transaksi ke database lokal: $e'));
    }
  }
  @override
  Future<Either<Failure, Order>> getOrderStatus(int orderId) async {
    try {
      final token = await authLocalDataSource.getToken();

      if (token == null) {
        return const Left(
          ServerFailure('Sesi telah berakhir. Silahkan login kembali.'),
        );
      }

      final result = await remoteDataSource.getOrderStatus(token, orderId);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Gagal mengecek status pesanan'),
      );
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan yang tidak terduga: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> syncPendingOrders() async {
    try {
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        return const Left(ServerFailure('Sesi telah berakhir. Silahkan login kembali.'));
      }

      final unsyncedOrders = await localDataSource.getUnsyncedOrders();
      if (unsyncedOrders.isEmpty) {
        return const Right(0);
      }

      int syncedCount = 0;
      for (var orderMap in unsyncedOrders) {
        try {
          // Convert Map dari database ke OrderRequestModel
          final List<dynamic> itemsList = orderMap['items'] ?? [];
          final items = itemsList.map((item) => OrderItemRequestModel(
            productId: item['productId'],
            quantity: item['quantity'],
            price: (item['price'] as num).toDouble(),
            note: item['productName'] ?? '',
          )).toList();

          final requestModel = OrderRequestModel(
            cashierId: orderMap['cashierId'],
            transactionTime: orderMap['transactionTime'],
            subTotal: (orderMap['subTotal'] as num).toDouble(),
            discountId: orderMap['discountId'],
            discountAmount: (orderMap['discountAmount'] as num).toDouble(),
            shippingCost: (orderMap['shippingCost'] as num).toDouble(),
            serviceCharge: (orderMap['serviceCharge'] as num).toDouble(),
            tax: (orderMap['tax'] as num).toDouble(),
            total: (orderMap['total'] as num).toDouble(),
            paymentMethod: orderMap['paymentMethod'],
            orderItems: items,
          );

          final result = await remoteDataSource.submitOrder(token, requestModel);
          await localDataSource.updateOrderSyncedStatus(orderMap['id'], result.id ?? 0);
          syncedCount++;
        } catch (e) {
          // Lanjut ke pesanan berikutnya jika satu gagal
          continue;
        }
      }

      return Right(syncedCount);
    } catch (e) {
      return Left(ServerFailure('Gagal melakukan sinkronisasi pesanan offline: $e'));
    }
  }
}
