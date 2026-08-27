import 'dart:convert';
import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';

class TransactionModel extends Equatable {
  final int? id;
  final String transactionTime;
  final int total;
  final String paymentMethod;
  final String? paymentStatus;
  final String? snapRedirectUrl;

  const TransactionModel({
    this.id,
    required this.transactionTime,
    required this.total,
    required this.paymentMethod,
    this.paymentStatus,
    this.snapRedirectUrl,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? paymentDetails;
    if (json['payment_details'] is Map) {
      paymentDetails = json['payment_details'] as Map<String, dynamic>;
    } else if (json['payment_details'] is String) {
      try {
        paymentDetails = jsonDecode(json['payment_details']);
      } catch (_) {
        paymentDetails = null;
      }
    }

    return TransactionModel(
      id: (json['id'] ?? json['order_id']) is int
          ? (json['id'] ?? json['order_id']) as int
          : int.tryParse((json['id'] ?? json['order_id'])?.toString() ?? ''),
      transactionTime: json['transaction_time']?.toString() ?? '',
      total: (json['total'] ?? json['grand_total']) is int
          ? (json['total'] ?? json['grand_total']) as int
          : int.tryParse((json['total'] ?? json['grand_total'])?.toString() ?? '') ?? 0,
      paymentMethod: json['payment_method']?.toString() ?? '',
      paymentStatus: paymentDetails?['status']?.toString() ?? json['status']?.toString(),
      snapRedirectUrl: paymentDetails?['snap_redirect_url']?.toString(),
    );
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id ?? 0,
      transactionTime: transactionTime,
      total: total,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      snapRedirectUrl: snapRedirectUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        transactionTime,
        total,
        paymentMethod,
        paymentStatus,
        snapRedirectUrl,
      ];
}
