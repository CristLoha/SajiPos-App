import 'package:dartz/dartz.dart' hide Order;
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saji_pos_app/features/order/data/datasource/order_remote_data_source.dart';
import 'package:saji_pos_app/features/order/data/models/order_request_model.dart';
import 'package:saji_pos_app/features/order/domain/entities/order.dart';
import 'package:saji_pos_app/features/order/domain/entities/order_request.dart';
import 'package:saji_pos_app/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Order>> submitOrder(OrderRequest request) async {
    try {
      final token = await localDataSource.getToken();

      if (token == null) {
        return const Left(
          ServerFailure('Sesi telah berakhir. Silahkan login kembali.'),
        );
      }

      final model = OrderRequestModel.fromEntity(request);
      final result = await remoteDataSource.submitOrder(token, model);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Gagal menyimpan transaksi ke server'),
      );
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan yang tidaak terdugaa: $e'));
    }
  }
  @override
  Future<Either<Failure, Order>> getOrderStatus(int orderId) async {
    try {
      final token = await localDataSource.getToken();

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
}
