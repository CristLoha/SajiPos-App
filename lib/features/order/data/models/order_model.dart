import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/order/data/models/order_item_model.dart';
import 'package:saji_pos_app/features/order/domain/entities/order.dart';

class OrderModel extends Equatable {
  const OrderModel({
    this.id,
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

  final int? id;
  final int cashierId;
  final String transactionTime;
  final int subTotal;
  final int discountAmount;
  final int shippingCost;
  final int serviceCharge;
  final int tax;
  final int total;
  final String paymentMethod;
  final List<OrderItemModel> orderItems;
  final String? transactionId;
  final String? qrString;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final paymentDetails = json['payment_details'] as Map<String, dynamic>?;
    return OrderModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()),
      cashierId: json['cashier_id'] is int
          ? json['cashier_id'] as int
          : int.tryParse(json['cashier_id'].toString()) ?? 0,
      transactionTime: json['transaction_time']?.toString() ?? '',
      subTotal: json['sub_total'] is int
          ? json['sub_total'] as int
          : int.tryParse(json['sub_total'].toString()) ?? 0,
      discountAmount: json['discount_amount'] is int
          ? json['discount_amount'] as int
          : int.tryParse(json['discount_amount'].toString()) ?? 0,
      shippingCost: json['shipping_cost'] is int
          ? json['shipping_cost'] as int
          : int.tryParse(json['shipping_cost'].toString()) ?? 0,
      serviceCharge: json['service_charge'] is int
          ? json['service_charge'] as int
          : int.tryParse(json['service_charge'].toString()) ?? 0,
      tax: json['tax'] is int
          ? json['tax'] as int
          : int.tryParse(json['tax'].toString()) ?? 0,
      total: json['total'] is int
          ? json['total'] as int
          : int.tryParse(json['total'].toString()) ?? 0,
      paymentMethod: json['payment_method']?.toString() ?? '',
      orderItems: json['items'] != null
          ? List<OrderItemModel>.from(
              (json['items'] as List).map((x) => OrderItemModel.fromJson(x)),
            )
          : [],
      transactionId: paymentDetails?['transaction_id']?.toString(),
      qrString: paymentDetails?['qr_string']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cashier_id': cashierId,
      'transaction_time': transactionTime,
      'sub_total': subTotal,
      'discount_amount': discountAmount,
      'shipping_cost': shippingCost,
      'service_charge': serviceCharge,
      'tax': tax,
      'total': total,
      'payment_method': paymentMethod,
      'order_items': orderItems.map((e) => e.toJson()).toList(),
      if (transactionId != null || qrString != null)
        'payment_details': {
          if (transactionId != null) 'transaction_id': transactionId,
          if (qrString != null) 'qr_string': qrString,
        }
    };
  }

  Order toEntity() {
    return Order(
      id: id ?? 0,
      cashierId: cashierId,
      transactionTime: transactionTime,
      subTotal: subTotal,
      discountAmount: discountAmount,
      shippingCost: shippingCost,
      serviceCharge: serviceCharge,
      tax: tax,
      total: total,
      paymentMethod: paymentMethod,
      orderItems: orderItems.map((e) => e.toEntity()).toList(),
      transactionId: transactionId,
      qrString: qrString,
    );
  }

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
