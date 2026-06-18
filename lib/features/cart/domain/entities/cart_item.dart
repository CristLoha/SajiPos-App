import 'package:saji_pos_app/features/product/domain/entities/product.dart';

class CartItem {
  final Product product;
  int quantity;
  String note;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.note = '',
  });

  int get totalPrice => product.price * quantity;
}
