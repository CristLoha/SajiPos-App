import 'package:saji_pos_app/features/product/domain/entities/product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final String note;

  CartItem({required this.product, this.quantity = 1, this.note = ''});

  CartItem copyWith({Product? product, int? quantity, String? note}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }

  int get totalPrice => product.actualPrice * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      note: json['note'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'note': note,
    };
  }
}
