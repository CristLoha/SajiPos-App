import 'package:saji_pos_app/core/data/database_helper.dart';
import 'package:saji_pos_app/features/product/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
  Future<void> clearCache();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final DatabaseHelper dbHelper;

  ProductLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final db = await dbHelper.database;
    final batch = db.batch();

    await db.delete('products');

    for (var product in products) {
      batch.insert('products', {
        'id': product.id,
        'categoryId': product.categoryId,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'discountPrice': product.discountPrice,
        'isCampaignActive': product.isCampaignActive ? 1 : 0,
        'stock': product.stock,
        'image': product.image,
        'status': product.status,
        'createdAt': product.createdAt,
        'updatedAt': product.updatedAt,
      });
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final db = await dbHelper.database;
    final maps = await db.query('products');

    if (maps.isNotEmpty) {
      return maps.map((map) {
        return ProductModel(
          id: map['id'] as int,
          categoryId: map['categoryId'] as int,
          name: map['name'] as String,
          description: map['description'] as String,
          price: map['price'] as int,
          discountPrice: map['discountPrice'] as int?,
          isCampaignActive: (map['isCampaignActive'] as int) == 1,
          stock: map['stock'] as int,
          image: map['image'] as String,
          status: map['status'] as int,
          createdAt: map['createdAt'] as String,
          updatedAt: map['updatedAt'] as String,
          category:
              null, // Since we don't store CategoryModel relation in products table yet
        );
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> clearCache() async {
    final db = await dbHelper.database;
    await db.delete('products');
  }
}
