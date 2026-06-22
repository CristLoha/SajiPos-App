import 'package:equatable/equatable.dart';
import '../../domain/entities/order_item.dart';

class OrderItemModel extends Equatable {
  const OrderItemModel({
    this.id,
    this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.note,
  });

  final int? id;
  final int? orderId;
  final int productId;
  final int quantity;
  final int price;
  final String note;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()),
      orderId: json['order_id'] is int ? json['order_id'] as int : int.tryParse(json['order_id'].toString()),
      productId: json['product_id'] is int ? json['product_id'] as int : int.tryParse(json['product_id'].toString()) ?? 0,
      quantity: json['quantity'] is int ? json['quantity'] as int : int.tryParse(json['quantity'].toString()) ?? 0,
      price: json['price'] is int ? json['price'] as int : int.tryParse(json['price'].toString()) ?? 0,
      note: json['note']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'note': note,
    };
  }

  OrderItem toEntity() {
    return OrderItem(
      id: id ?? 0,
      orderId: orderId ?? 0,
      productId: productId,
      quantity: quantity,
      price: price,
      note: note,
    );
  }

  @override
  List<Object?> get props => [id, orderId, productId, quantity, price, note];
}
