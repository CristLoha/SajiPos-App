import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final double diskon;
  final Set<int> selectedDiscountIds;

  const CartState({
    this.items = const [],
    this.diskon = 0.0,
    this.selectedDiscountIds = const {},
  });

  double get subTotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get subTotalAfterDiscount {
    double result = subTotal - diskon;
    return result < 0 ? 0 : result;
  }

  double get pajak => 0.0;
  double get layanan => 0.0;
  double get ongkir => 0.0;
  double get total => subTotalAfterDiscount + pajak + layanan + ongkir;

  CartState copyWith({
    List<CartItem>? items,
    double? diskon,
    Set<int>? selectedDiscountIds,
  }) {
    return CartState(
      items: items ?? this.items,
      diskon: diskon ?? this.diskon,
      selectedDiscountIds: selectedDiscountIds ?? this.selectedDiscountIds,
    );
  }

  @override
  List<Object?> get props => [
    items,
    diskon,
    selectedDiscountIds,
    items.map((e) => '${e.product.id}-${e.quantity}-${e.note}').toList(),
  ];
}
