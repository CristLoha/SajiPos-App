import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saji_pos_app/features/product/domain/entities/product.dart';
import 'package:saji_pos_app/features/discount/domain/entities/discount.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final SharedPreferences sharedPreferences;
  static const String _cartKey = 'cart_state_v1';

  CartCubit({required this.sharedPreferences}) : super(const CartState()) {
    _loadCart();
  }

  void _loadCart() {
    final String? cartStr = sharedPreferences.getString(_cartKey);
    if (cartStr != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(cartStr);
        final loadedState = CartState.fromJson(json);
        emit(loadedState);
        _emitWithRecalculatedDiscount(loadedState.items);
      } catch (e) {
        debugPrint('Failed to load cart: $e');
      }
    }
  }

  void _saveCart(CartState stateToSave) {
    try {
      final String cartStr = jsonEncode(stateToSave.toJson());
      sharedPreferences.setString(_cartKey, cartStr);
    } catch (e) {
      debugPrint('Failed to save cart: $e');
    }
  }

  void _emitWithRecalculatedDiscount(List<CartItem> currentItems) {
    double subTotal = currentItems.fold(0, (sum, item) => sum + item.totalPrice);
    
    if (state.activeDiscount == null) {
      final newState = state.copyWith(items: currentItems);
      emit(newState);
      _saveCart(newState);
      return;
    }

    // EXPIRED CHECK: Jika waktu saat ini sudah melewati expiredDate
    if (DateTime.now().isAfter(state.activeDiscount!.expiredDate)) {
      debugPrint('Discount expired: ${state.activeDiscount!.name}');
      final newState = state.copyWith(
        items: currentItems, 
        diskon: 0.0, 
        clearDiscount: true, 
        selectedDiscountIds: {}
      );
      emit(newState);
      _saveCart(newState);
      return;
    }
    
    if (state.activeDiscount!.minTransaction != null &&
        subTotal < state.activeDiscount!.minTransaction!) {
      // Syarat diskon tidak terpenuhi, diskon dinolkan tapi status tetap standby
      final newState = state.copyWith(items: currentItems, diskon: 0.0);
      emit(newState);
      _saveCart(newState);
      return;
    }

    double discountAmount = 0.0;
    double discountValue = state.activeDiscount!.value ?? 0.0;
    String discountType = state.activeDiscount!.type.trim().toLowerCase();

    if (discountType == 'percent' || discountType == 'percentage' || discountType == 'persen' || discountType == 'persentase') {
      discountAmount = subTotal * (discountValue / 100);
      if (state.activeDiscount!.maxDiscount != null &&
          discountAmount > state.activeDiscount!.maxDiscount!) {
        discountAmount = state.activeDiscount!.maxDiscount!;
      }
    } else {
      discountAmount = discountValue;
    }

    final newState = state.copyWith(items: currentItems, diskon: discountAmount);
    emit(newState);
    _saveCart(newState);
  }

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
    _emitWithRecalculatedDiscount(currentItems);
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
      _emitWithRecalculatedDiscount(currentItems);
    }
  }

  void updateNote(Product product, String note) {
    final currentItems = List<CartItem>.from(state.items);
    final index = currentItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      currentItems[index] = currentItems[index].copyWith(note: note);
      _emitWithRecalculatedDiscount(currentItems);
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
      _emitWithRecalculatedDiscount(currentItems);
    }
  }

  void applyVoucherDiscount(Discount discount) {
    final newState = state.copyWith(
      activeDiscount: discount,
      selectedDiscountIds: {discount.id},
    );
    emit(newState);
    _emitWithRecalculatedDiscount(newState.items);
  }

  void removeVoucherDiscount() {
    final newState = state.copyWith(clearDiscount: true, diskon: 0.0, selectedDiscountIds: {});
    emit(newState);
    _saveCart(newState);
  }

  void clearCart() {
    final newState = const CartState(items: [], diskon: 0.0, selectedDiscountIds: {});
    emit(newState);
    _saveCart(newState);
  }

  void updateCosts({
    double? taxPercentage,
    double? shippingFeeAmount,
    double? serviceFeeAmount,
    bool? includeShippingInTax,
    bool? includeServiceFeeInTax,
  }) {
    final newState = state.copyWith(
      taxPercentage: taxPercentage,
      shippingFeeAmount: shippingFeeAmount,
      serviceFeeAmount: serviceFeeAmount,
      includeShippingInTax: includeShippingInTax,
      includeServiceFeeInTax: includeServiceFeeInTax,
    );
    emit(newState);
    _saveCart(newState);
  }
}
