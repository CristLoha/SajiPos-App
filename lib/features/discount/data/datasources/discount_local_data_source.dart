import 'package:saji_pos_app/core/data/database_helper.dart';
import 'package:saji_pos_app/features/discount/domain/entities/discount.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DiscountLocalDataSource {
  Future<void> cacheDiscounts(List<Discount> discounts);
  Future<List<Discount>> getCachedDiscounts();
  Future<void> clearCache();
  Future<void> saveSeenDiscounts(List<int> ids);
  Future<List<int>> getSeenDiscounts();
}

class DiscountLocalDataSourceImpl implements DiscountLocalDataSource {
  final DatabaseHelper dbHelper;
  final SharedPreferences sharedPreferences;

  DiscountLocalDataSourceImpl({
    required this.dbHelper,
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheDiscounts(List<Discount> discounts) async {
    final db = await dbHelper.database;
    final batch = db.batch();

    await db.delete('discounts');

    for (var discount in discounts) {
      batch.insert('discounts', {
        'id': discount.id,
        'name': discount.name,
        'code': discount.code,
        'description': discount.description,
        'type': discount.type,
        'value': discount.value,
        'minTransaction': discount.minTransaction,
        'maxDiscount': discount.maxDiscount,
        'status': discount.status,
        'startDate': discount.startDate.toIso8601String(),
        'expiredDate': discount.expiredDate.toIso8601String(),
      });
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<List<Discount>> getCachedDiscounts() async {
    final db = await dbHelper.database;
    final maps = await db.query('discounts');

    if (maps.isNotEmpty) {
      return maps.map((map) {
        return Discount(
          id: map['id'] as int,
          name: map['name'] as String,
          code: map['code'] as String,
          description: map['description'] as String?,
          type: map['type'] as String,
          value: map['value'] as double?,
          minTransaction: map['minTransaction'] as double?,
          maxDiscount: map['maxDiscount'] as double?,
          status: map['status'] as String,
          startDate:
              DateTime.tryParse(map['startDate'] as String? ?? '') ??
              DateTime.now(),
          expiredDate:
              DateTime.tryParse(map['expiredDate'] as String? ?? '') ??
              DateTime.now(),
        );
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> clearCache() async {
    final db = await dbHelper.database;
    await db.delete('discounts');
  }

  @override
  Future<void> saveSeenDiscounts(List<int> ids) async {
    await sharedPreferences.setStringList(
      'seen_discount_ids',
      ids.map((e) => e.toString()).toList(),
    );
  }

  @override
  Future<List<int>> getSeenDiscounts() async {
    final list = sharedPreferences.getStringList('seen_discount_ids');
    if (list != null) {
      return list.map((e) => int.tryParse(e) ?? 0).toList();
    }
    return [];
  }
}
