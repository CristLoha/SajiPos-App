import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/product/domain/entities/product.dart';
import 'package:saji_pos_app/features/category/data/models/category_model.dart';

class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  final int id;
  final int categoryId;
  final String name;
  final String description;
  final int price;
  final int stock;
  final String image;
  final int status;
  final String createdAt;
  final String updatedAt;
  final CategoryModel? category;


  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      categoryId: json['category_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      stock: json['stock'] as int,
      image: json['image'] as String,
      status: json['status'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Mengubah [ProductModel] menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image': image,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category': category != null
          ? (category as CategoryModel).toJson()
          : null,
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      categoryId: categoryId,
      name: name,
      description: description,
      price: price,
      stock: stock,
      image: image,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    categoryId,
    name,
    description,
    price,
    stock,
    image,
    status,
    createdAt,
    updatedAt,
    category,
  ];
}
