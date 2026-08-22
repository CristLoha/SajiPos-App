import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/discount/domain/entities/discount.dart';

class DiscountModel extends Equatable {
  final int id;
  final String name;
  final String code;
  final String? description;
  final String type;
  final String? value;
  final dynamic minTransaction;
  final dynamic maxDiscount;
  final String startDate;
  final String expiredDate;
  final String status;

  const DiscountModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.type,
    this.value,
    this.minTransaction,
    this.maxDiscount,
    required this.startDate,
    required this.expiredDate,
    required this.status,
  });
  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString(),
      type: json['type']?.toString() ?? '',
      value: json['value']?.toString(),
      minTransaction: json['min_transaction'],
      maxDiscount: json['max_discount'],
      startDate: json['start_date']?.toString() ?? DateTime.now().toString(),
      expiredDate: json['expired_date']?.toString() ?? DateTime.now().toString(),
      status: json['status']?.toString() ?? '',
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
      'min_transaction': minTransaction,
      'max_discount': maxDiscount,
      'start_date': startDate,
      'expired_date': expiredDate,
      'status': status,
    };
  }

  Discount toEntity() {
    return Discount(
      id: id,
      name: name,
      code: code,
      description: description,
      type: type,
      value: value != null ? double.tryParse(value!) : null,
      minTransaction: minTransaction != null ? double.tryParse(minTransaction.toString()) : null,
      maxDiscount: maxDiscount != null ? double.tryParse(maxDiscount.toString()) : null,
      startDate: DateTime.tryParse(startDate) ?? DateTime.now(),
      expiredDate: DateTime.tryParse(expiredDate) ?? DateTime.now(),
      status: status,
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
    minTransaction,
    maxDiscount,
    status,
    startDate,
    expiredDate,
  ];
}
