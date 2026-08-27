import 'dart:convert';
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
    this.snapToken,
    this.snapRedirectUrl,
    this.qrImageUrl,
    this.paymentStatus,
    this.expiryTime,
    this.receiptToken,
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
  final String? snapToken;
  final String? snapRedirectUrl;
  final String? qrImageUrl;
  final String? paymentStatus;
  final String? expiryTime;
  final String? receiptToken;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? paymentDetails;
    if (json['payment_details'] is Map) {
      paymentDetails = json['payment_details'] as Map<String, dynamic>;
    } else if (json['payment_details'] is String) {
      try {
        paymentDetails = jsonDecode(json['payment_details']);
      } catch (e) {
        paymentDetails = null;
      }
    }

    return OrderModel(
      id: (json['id'] ?? json['order_id']) is int
          ? (json['id'] ?? json['order_id']) as int
          : int.tryParse((json['id'] ?? json['order_id'])?.toString() ?? ''),
      cashierId: json['cashier_id'] is int
          ? json['cashier_id'] as int
          : int.tryParse(json['cashier_id']?.toString() ?? '') ?? 0,
      transactionTime: json['transaction_time']?.toString() ?? '',
      subTotal: (json['sub_total'] ?? json['subtotal']) is int
          ? (json['sub_total'] ?? json['subtotal']) as int
          : int.tryParse((json['sub_total'] ?? json['subtotal'])?.toString() ?? '') ?? 0,
      discountAmount: json['discount_amount'] is int
          ? json['discount_amount'] as int
          : int.tryParse(json['discount_amount']?.toString() ?? '') ?? 0,
      shippingCost: json['shipping_cost'] is int
          ? json['shipping_cost'] as int
          : int.tryParse(json['shipping_cost']?.toString() ?? '') ?? 0,
      serviceCharge: json['service_charge'] is int
          ? json['service_charge'] as int
          : int.tryParse(json['service_charge']?.toString() ?? '') ?? 0,
      tax: json['tax'] is int
          ? json['tax'] as int
          : int.tryParse(json['tax']?.toString() ?? '') ?? 0,
      total: (json['total'] ?? json['grand_total']) is int
          ? (json['total'] ?? json['grand_total']) as int
          : int.tryParse((json['total'] ?? json['grand_total'])?.toString() ?? '') ?? 0,
      paymentMethod: json['payment_method']?.toString() ?? '',
      orderItems: json['items'] != null
          ? List<OrderItemModel>.from(
              (json['items'] as List).map((x) => OrderItemModel.fromJson(x)),
            )
          : [],
      transactionId: paymentDetails?['transaction_id']?.toString(),
      qrString: paymentDetails?['qr_string']?.toString(),
      snapToken: paymentDetails?['snap_token']?.toString(),
      snapRedirectUrl: paymentDetails?['snap_redirect_url']?.toString(),
      qrImageUrl: paymentDetails?['qr_image_url']?.toString(),
      paymentStatus: paymentDetails?['status']?.toString(),
      expiryTime: paymentDetails?['expiry_time']?.toString(),
      receiptToken: json['receipt_token']?.toString(),
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
      'receipt_token': receiptToken,
      'order_items': orderItems.map((e) => e.toJson()).toList(),
      if (transactionId != null ||
          qrString != null ||
          snapToken != null ||
          snapRedirectUrl != null ||
          qrImageUrl != null)
        'payment_details': {
          if (transactionId != null) 'transaction_id': transactionId,
          if (qrString != null) 'qr_string': qrString,
          if (snapToken != null) 'snap_token': snapToken,
          if (snapRedirectUrl != null) 'snap_redirect_url': snapRedirectUrl,
          if (qrImageUrl != null) 'qr_image_url': qrImageUrl,
          if (paymentStatus != null) 'status': paymentStatus,
          if (expiryTime != null) 'expiry_time': expiryTime,
        },
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
      snapToken: snapToken,
      snapRedirectUrl: snapRedirectUrl,
      qrImageUrl: qrImageUrl,
      paymentStatus: paymentStatus,
      expiryTime: expiryTime,
      receiptToken: receiptToken,
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
    snapToken,
    snapRedirectUrl,
    qrImageUrl,
    paymentStatus,
    expiryTime,
    receiptToken,
  ];
}
