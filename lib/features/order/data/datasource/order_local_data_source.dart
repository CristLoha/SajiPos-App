import 'package:saji_pos_app/core/data/database_helper.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/features/order/domain/entities/order_request.dart';

abstract class OrderLocalDataSource {
  Future<int> saveOrderOffline(OrderRequest request);
  Future<void> updateOrderSyncedStatus(int localOrderId, int serverId);
  Future<List<Map<String, dynamic>>> getUnsyncedOrders();
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final DatabaseHelper dbHelper;

  OrderLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<int> saveOrderOffline(OrderRequest request) async {
    try {
      final db = await dbHelper.database;

      int orderId = 0;
      await db.transaction((txn) async {
        orderId = await txn.insert('orders', {
          'cashierId': request.cashierId,
          'transactionTime': request.transactionTime,
          'subTotal': request.subTotal,
          'discountId': request.discountId,
          'discountAmount': request.discountAmount,
          'shippingCost': request.shippingCost,
          'serviceCharge': request.serviceCharge,
          'tax': request.tax,
          'total': request.total,
          'paymentMethod': request.paymentMethod,
          'isSynced': 0,
        });

        for (var item in request.orderItems) {
          await txn.insert('order_items', {
            'orderId': orderId,
            'productId': item.productId,
            'productName': item.note, // Simpan note atau default
            'quantity': item.quantity,
            'price': item.price,
          });
        }
      });
      return orderId;
    } catch (e) {
      throw DatabaseException('Gagal menyimpan pesanan secara lokal: $e');
    }
  }

  @override
  Future<void> updateOrderSyncedStatus(int localOrderId, int serverId) async {
    try {
      final db = await dbHelper.database;
      await db.update(
        'orders',
        {'isSynced': 1, 'serverId': serverId},
        where: 'id = ?',
        whereArgs: [localOrderId],
      );
    } catch (e) {
      throw DatabaseException('Gagal update status pesanan: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUnsyncedOrders() async {
    try {
      final db = await dbHelper.database;
      final orders = await db.query(
        'orders',
        where: 'isSynced = ?',
        whereArgs: [0],
      );

      List<Map<String, dynamic>> fullOrders = [];
      for (var order in orders) {
        final items = await db.query(
          'order_items',
          where: 'orderId = ?',
          whereArgs: [order['id']],
        );

        final map = Map<String, dynamic>.from(order);
        map['items'] = items;
        fullOrders.add(map);
      }
      return fullOrders;
    } catch (e) {
      throw DatabaseException(
        'Gagal mengambil pesanan yang belum tersinkronisasi: $e',
      );
    }
  }
}
