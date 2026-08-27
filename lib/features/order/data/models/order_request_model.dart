import 'package:equatable/equatable.dart';
import '../../domain/entities/order_request.dart';
import 'order_item_request_model.dart';

class OrderRequestModel extends Equatable {
  const OrderRequestModel({
    required this.cashierId,
    required this.transactionTime,
    required this.subTotal,
    this.discountId,
    required this.discountAmount,
    required this.shippingCost,
    required this.serviceCharge,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.orderItems,
  });

  final int cashierId;
  final String transactionTime;
  final double subTotal;
  final int? discountId;
  final double discountAmount;
  final double shippingCost;
  final double serviceCharge;
  final double tax;
  final double total;
  final String paymentMethod;
  final List<OrderItemRequestModel> orderItems;

  factory OrderRequestModel.fromEntity(OrderRequest entity) {
    return OrderRequestModel(
      cashierId: entity.cashierId,
      transactionTime: entity.transactionTime,
      subTotal: entity.subTotal,
      discountId: entity.discountId,
      discountAmount: entity.discountAmount,
      shippingCost: entity.shippingCost,
      serviceCharge: entity.serviceCharge,
      tax: entity.tax,
      total: entity.total,
      paymentMethod: entity.paymentMethod,
      orderItems: entity.orderItems
          .map((item) => OrderItemRequestModel.fromEntity(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      'cashier_id': cashierId,
      'transaction_time': transactionTime,
      'sub_total': subTotal.toInt(),
      'discount_amount': discountAmount.toInt(),
      'shipping_cost': shippingCost.toInt(),
      'service_charge': serviceCharge.toInt(),
      'tax': tax.toInt(),
      'total': total.toInt(),
      'payment_method': paymentMethod,
      'order_items': orderItems.map((e) => e.toJson()).toList(),
    };
    if (discountId != null) {
      map['discount_id'] = discountId;
    }
    return map;
  }

  @override
  List<Object?> get props => [
    cashierId,
    transactionTime,
    subTotal,
    discountId,
    discountAmount,
    shippingCost,
    serviceCharge,
    tax,
    total,
    paymentMethod,
    orderItems,
  ];
}
