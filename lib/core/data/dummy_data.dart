import 'package:flutter/material.dart';
import '../../features/product/domain/entities/product.dart';

// Class penampung item keranjang belanja belanjaan
class CartItem {
  final Product product;
  int quantity;
  String note;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.note = '',
  });

  // Getter total harga per baris item
  int get totalPrice => product.price * quantity;
}

// Global state keranjang belanja sederhana (sementara sebelum diganti BLoC)
class GlobalCartState extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Mendukung getter camelCase yang dipanggil di UI
  double get subTotal {
    return _items.fold(0, (sum, item) {
      return sum + item.totalPrice;
    });
  }

  double get subtotal => subTotal;

  double get pajak => subTotal * 0.1; // 10%
  double get layanan => subTotal * 0.05; // 5%
  double get diskon => 0.0;
  double get ongkir => 0.0;
  
  double get total => subTotal + pajak + layanan + ongkir - diskon;

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void updateQuantity(Product product, int newQty) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (newQty <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQty;
      }
      notifyListeners();
    }
  }

  void updateNote(Product product, String note) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].note = note;
      notifyListeners();
    }
  }

  void addProduct(Product product) {
    addToCart(product);
  }

  void removeProduct(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

// Global instance untuk dipanggil di layout widget
final globalCartState = GlobalCartState();

// Dummy Products untuk menghindari compile error pada UI Grid produk
final List<Product> dummyProducts = [
  const Product(
    id: 1,
    name: 'Espresso Single',
    description: 'Espresso murni 1 shot',
    price: 18000,
    stock: 99,
    image: 'https://images.unsplash.com/photo-151097252790b-a638d6487a2c',
    categoryId: 1,
    status: 1,
    createdAt: '',
    updatedAt: '',
  ),
  const Product(
    id: 2,
    name: 'Cappuccino Hot',
    description: 'Kopi cappuccino panas nikmat',
    price: 28000,
    stock: 50,
    image: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d',
    categoryId: 1,
    status: 1,
    createdAt: '',
    updatedAt: '',
  ),
  const Product(
    id: 3,
    name: 'Croissant Butter',
    description: 'Roti croissant mentega renyah',
    price: 22000,
    stock: 20,
    image: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a',
    categoryId: 2,
    status: 1,
    createdAt: '',
    updatedAt: '',
  ),
];
