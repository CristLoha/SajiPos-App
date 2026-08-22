import 'package:saji_pos_app/core/data/database_helper.dart';
import 'package:saji_pos_app/features/category/data/models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<List<CategoryModel>> getCachedCategories();
  Future<void> clearCache();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseHelper dbHelper;

  CategoryLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final db = await dbHelper.database;
    final batch = db.batch();

    await db.delete('categories');

    for (var category in categories) {
      batch.insert('categories', {
        'id': category.id,
        'name': category.name,
        'description': category.description,
        'image': category.image,
        'createdAt': category.createdAt,
        'updatedAt': category.updatedAt,
      });
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<List<CategoryModel>> getCachedCategories() async {
    final db = await dbHelper.database;
    final maps = await db.query('categories');

    if (maps.isNotEmpty) {
      return maps.map((map) {
        return CategoryModel(
          id: map['id'] as int,
          name: map['name'] as String,
          description: map['description'] as String? ?? '',
          image: map['image'] as String? ?? '',
          createdAt: map['createdAt'] as String,
          updatedAt: map['updatedAt'] as String,
        );
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> clearCache() async {
    final db = await dbHelper.database;
    await db.delete('categories');
  }
}
