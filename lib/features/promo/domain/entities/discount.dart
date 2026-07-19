import 'package:equatable/equatable.dart';

class Discount extends Equatable {
  final int id;
  final String? name;
  final String? code;
  final String? description;
  final String? type;
  final double? value;
  final String? status;
  final String? startDate;
  final double?  maxDiscount;
  final double? minTransaction;
  final int? quota;
  final String? expiredDate;
  final String? createdAt;
  final String? updatedAt;

  const Discount({
    required this.id,
    this.name,
    this.code,
    this.description,
    this.type,
    this.value,
    this.status,
    this.startDate,
    this. maxDiscount,
    this.minTransaction,
    this.quota,
    this.expiredDate,
    this.createdAt,
    this.updatedAt,
  });

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
