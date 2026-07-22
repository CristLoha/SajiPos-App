import 'package:equatable/equatable.dart';

class Discount extends Equatable {
  final int id;
  final String name;
  final String code;
  final String? description;
  final String type;
  final double? value;
  final double? minTransaction;
  final double? maxDiscount;
  final String status;
  final DateTime startDate;
  final DateTime expiredDate;

  const Discount({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.type,
    this.value,
    this.minTransaction,
    this.maxDiscount,
    required this.status,
    required this.startDate,
    required this.expiredDate,
  });

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
