import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  double get subTotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get pajak => subTotal * 0.1;
  double get layanan => subTotal * 0.05;
  double get diskon => 0.0;
  double get ongkir => 0.0;
  double get total => subTotal + pajak + layanan + ongkir - diskon;

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [
    items,
    // Add unique mapping of items to track state changes
    items.map((e) => '${e.product.id}-${e.quantity}-${e.note}').toList(),
  ];
}
