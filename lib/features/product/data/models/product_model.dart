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
    this.discountPrice,
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
  final int? discountPrice;
  final int stock;
  final String image;
  final int status;
  final String createdAt;
  final String updatedAt;
  final CategoryModel? category;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      categoryId: json['category_id'] is int
          ? json['category_id'] as int
          : int.tryParse(json['category_id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price'] is int
          ? json['price'] as int
          : int.tryParse(json['price'].toString()) ?? 0,
      discountPrice: json['discount_price'] != null
          ? (json['discount_price'] is int
                ? json['discount_price'] as int
                : int.tryParse(json['discount_price'].toString()))
          : null,
      stock: json['stock'] is int
          ? json['stock'] as int
          : int.tryParse(json['stock'].toString()) ?? 0,
      image: json['image']?.toString() ?? '',
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse(json['status'].toString()) ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
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
      discountPrice: discountPrice,
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
