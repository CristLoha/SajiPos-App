import 'package:equatable/equatable.dart';

class PaymentSummary extends Equatable {
  final double amount;
  final int count;

  const PaymentSummary({required this.amount, required this.count});

  @override
  List<Object?> get props => [amount, count];
}

class TopMenu extends Equatable {
  final String name;
  final int qty;

  const TopMenu({required this.name, required this.qty});

  @override
  List<Object?> get props => [name, qty];
}

class ReportSummary extends Equatable {
  final double totalOmzet;
  final int totalTransactions;
  final double discountAmount;
  final double taxAmount;
  final PaymentSummary cash;
  final PaymentSummary qris;
  final PaymentSummary transfer;
  final List<TopMenu> topMenus;

  const ReportSummary({
    required this.totalOmzet,
    required this.totalTransactions,
    required this.discountAmount,
    required this.taxAmount,
    required this.cash,
    required this.qris,
    required this.transfer,
    required this.topMenus,
  });

  @override
  List<Object?> get props => [
    totalOmzet,
    totalTransactions,
    discountAmount,
    taxAmount,
    cash,
    qris,
    transfer,
    topMenus,
  ];
}
