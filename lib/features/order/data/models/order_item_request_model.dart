import 'package:equatable/equatable.dart';
import '../../domain/entities/order_item_request.dart';

class OrderItemRequestModel extends Equatable {
  const OrderItemRequestModel({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.note,
  });

  final int productId;
  final int quantity;
  final double price;
  final String note;

  factory OrderItemRequestModel.fromEntity(OrderItemRequest entity) {
    return OrderItemRequestModel(
      productId: entity.productId,
      quantity: entity.quantity,
      price: entity.price,
      note: entity.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'price': price.toInt(),
      'note': note,
    };
  }

  @override
  List<Object?> get props => [productId, quantity, price, note];
}
