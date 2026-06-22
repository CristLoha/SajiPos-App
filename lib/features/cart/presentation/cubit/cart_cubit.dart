import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/features/product/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(Product product) {
    final currentItems = List<CartItem>.from(state.items);
    final index = currentItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      currentItems[index] = currentItems[index].copyWith(
        quantity: currentItems[index].quantity + 1,
      );
    } else {
      currentItems.add(CartItem(product: product));
    }
    emit(state.copyWith(items: currentItems));
  }

  void updateQuantity(Product product, int newQty) {
    final currentItems = List<CartItem>.from(state.items);
    final index = currentItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      if (newQty <= 0) {
        currentItems.removeAt(index);
      } else {
        currentItems[index] = currentItems[index].copyWith(quantity: newQty);
      }
      emit(state.copyWith(items: currentItems));
    }
  }

  void updateNote(Product product, String note) {
    final currentItems = List<CartItem>.from(state.items);
    final index = currentItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      currentItems[index] = currentItems[index].copyWith(note: note);
      emit(state.copyWith(items: currentItems));
    }
  }

  void decreaseQuantity(Product product) {
    final currentItems = List<CartItem>.from(state.items);
    final index = currentItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      if (currentItems[index].quantity > 1) {
        currentItems[index] = currentItems[index].copyWith(
          quantity: currentItems[index].quantity - 1,
        );
      } else {
        currentItems.removeAt(index);
      }
      emit(state.copyWith(items: currentItems));
    }
  }

  void clearCart() {
    emit(const CartState(items: []));
  }
}
