import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
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

  // Temporary getter for UI product card compatibility
  String get category => categoryId == 1 ? 'Minuman' : 'Makanan';

  @override
  List<Object?> get props => [

    id,
    categoryId,
    name,
    description,
    image,
    createdAt,
    updatedAt,
  ];
}
