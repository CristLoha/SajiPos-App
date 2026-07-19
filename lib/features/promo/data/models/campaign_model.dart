import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/product/data/models/product_model.dart';
import 'package:saji_pos_app/features/promo/domain/entities/campaign.dart';

class CampaignModel extends Equatable {
  final int id;
  final String name;
  final String startDate;
  final String endDate;
  final String discountType;
  final double discountValue;
  final bool isActive;
  final List<ProductModel> products;

  const CampaignModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.discountType,
    required this.discountValue,
    required this.isActive,
    required this.products,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    List<ProductModel> parsedProducts = [];
    if (json['products'] != null) {
      parsedProducts = (json['products'] as List)
          .map(
            (p) => ProductModel.fromJson(p),
          ) // Panggil fromJson dari ProductModel kamu
          .toList();
    }

    return CampaignModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      discountType: json['discount_type'] ?? '',
      discountValue: (json['discount_value'] as num).toDouble(),
      isActive: json['is_active'] == 1,
      products: parsedProducts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate,
      'end_date': endDate,
      'discount_type': discountType,
      'discount_value': discountValue,
      'is_active': isActive ? 1 : 0,
      'products': products.map((p) => p.toJson()).toList(),
    };
  }

  Campaign toEntity() {
    return Campaign(
      id: id,
      name: name,
      startDate: startDate,
      endDate: endDate,
      discountType: discountType,
      discountValue: discountValue,
      isActive: isActive,
      productIds: products.map((p) => p.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    startDate,
    endDate,
    discountType,
    discountValue,
    isActive,
    products,
  ];
}
