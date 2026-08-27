import 'package:equatable/equatable.dart';

class OrderItemRequest extends Equatable {
  final int productId;
  final int quantity;
  final double price;
  final String note;

  const OrderItemRequest({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.note,
  });

  @override
  List<Object?> get props => [productId, quantity, price, note];
}
