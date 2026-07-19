import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/promo/domain/entities/discount.dart';

class DiscountModel extends Equatable {
  const DiscountModel({
    required this.id,
    this.name,
    this.code,
    this.description,
    this.type,
    this.value,
    this.status,
    this.startDate,
    this.maxDiscount,
    this.minTransaction,
    this.quota,
    this.expiredDate,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String? name;
  final String? code;
  final String? description;
  final String? type;
  final double? value;
  final String? status;
  final String? startDate;
  final double? maxDiscount;
  final double? minTransaction;
  final int? quota;
  final String? expiredDate;
  final String? createdAt;
  final String? updatedAt;

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString(),
      code: json['code']?.toString(),
      description: json['description']?.toString(),
      type: json['type']?.toString(),
      value: json['value'] != null
          ? double.tryParse(json['value'].toString())
          : null,
      status: json['status']?.toString(),
      startDate: json['start_date']?.toString(),
      maxDiscount: json['max_discount'] != null
          ? double.tryParse(json['max_discount'].toString())
          : null,
      minTransaction: json['min_transaction'] != null
          ? double.tryParse(json['min_transaction'].toString())
          : null,
      quota: json['quota'] is int
          ? json['quota'] as int
          : (int.tryParse(json['quota'].toString())),
      expiredDate: json['expired_date']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'type': type,
      'value': value,
      'status': status,
      'expired_date': expiredDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Discount toEntity() {
    return Discount(
      id: id,
      name: name,
      code: code,
      description: description,
      type: type,
      value: value,
      status: status,
      startDate: startDate,
      maxDiscount: maxDiscount,
      minTransaction: minTransaction,
      quota: quota,
      expiredDate: expiredDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    description,
    type,
    value,
    status,
    expiredDate,
    createdAt,
    updatedAt,
  ];
}
