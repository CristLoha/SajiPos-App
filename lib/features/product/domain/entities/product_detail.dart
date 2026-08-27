import 'package:equatable/equatable.dart';
import '../../../category/domain/entities/category.dart';

class ProductDetail extends Equatable {
  const ProductDetail({
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
    this.category,
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
  final Category? category;

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
