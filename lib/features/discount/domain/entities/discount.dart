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

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      value: json['value'] != null ? (json['value'] as num).toDouble() : null,
      minTransaction: json['minTransaction'] != null
          ? (json['minTransaction'] as num).toDouble()
          : null,
      maxDiscount: json['maxDiscount'] != null
          ? (json['maxDiscount'] as num).toDouble()
          : null,
      status: json['status'] as String,
      startDate:
          DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.now(),
      expiredDate:
          DateTime.tryParse(json['expiredDate']?.toString() ?? '') ??
          DateTime.now(),
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
      'minTransaction': minTransaction,
      'maxDiscount': maxDiscount,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'expiredDate': expiredDate.toIso8601String(),
    };
  }
}
