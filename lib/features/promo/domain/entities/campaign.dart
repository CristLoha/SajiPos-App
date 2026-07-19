import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/product/domain/entities/product.dart';

class Campaign extends Equatable {
  final int id;
  final String name;
  final String startDate;
  final String endDate;
  final String discountType;
  final double discountValue;
  final bool isActive;
  final List<Product> productIds;

  const Campaign({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.discountType,
    required this.discountValue,
    required this.isActive,
    required this.productIds,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    startDate,
    endDate,
    discountType,
    discountValue,
    isActive,
    productIds,
  ];
}
