import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/order/domain/entities/order_item.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.cashierId,
    required this.transactionTime,
    required this.subTotal,
    required this.discountAmount,
    required this.shippingCost,
    required this.serviceCharge,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.orderItems,
    this.transactionId,
    this.qrString,
  });

  final int id;
  final int cashierId;
  final String transactionTime;
  final int subTotal;
  final int discountAmount;
  final int shippingCost;
  final int serviceCharge;
  final int tax;
  final int total;
  final String paymentMethod;
  final List<OrderItem> orderItems;
  final String? transactionId;
  final String? qrString;

  @override
  List<Object?> get props => [
    id,
    cashierId,
    transactionTime,
    subTotal,
    discountAmount,
    shippingCost,
    serviceCharge,
    tax,
    total,
    paymentMethod,
    orderItems,
    transactionId,
    qrString,
  ];
}
