import '../../features/product/domain/entities/product.dart';

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
