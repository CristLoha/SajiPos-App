import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/core/constants/api_constants.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    this.isCampaignActive = false,
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
  final int? discountPrice;
  final bool isCampaignActive;
  final int stock;
  final String image;
  final int status;
  final String createdAt;
  final String updatedAt;

  String get category => categoryId == 1 ? 'Minuman' : 'Makanan';
  int get actualPrice => discountPrice ?? price;

  String? get fullImageUrl {
    if (image.isEmpty) return null;
    final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
    return '$baseUrl/storage/$image';
  }

  @override
  List<Object?> get props => [
    id,
    categoryId,
    name,
    description,
    price,
    discountPrice,
    stock,
    image,
    createdAt,
    updatedAt,
  ];

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      categoryId: json['categoryId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      discountPrice: json['discountPrice'] as int?,
      isCampaignActive: json['isCampaignActive'] as bool? ?? false,
      stock: json['stock'] as int,
      image: json['image'] as String,
      status: json['status'] as int,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'isCampaignActive': isCampaignActive,
      'stock': stock,
      'image': image,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
