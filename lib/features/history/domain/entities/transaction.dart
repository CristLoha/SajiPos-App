import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final int id;
  final String transactionTime;
  final int total;
  final String paymentMethod;
  final String? paymentStatus;
  final String? snapRedirectUrl;

  const TransactionEntity({
    required this.id,
    required this.transactionTime,
    required this.total,
    required this.paymentMethod,
    this.paymentStatus,
    this.snapRedirectUrl,
  });

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
