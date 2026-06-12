import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../core/components/product_card.dart';
import '../widgets/category_tabs.dart';
import '../widgets/header_section.dart';

class KatalogProductTabletPage extends StatefulWidget {
  const KatalogProductTabletPage({super.key});

  @override
  State<KatalogProductTabletPage> createState() => _KatalogProductTabletPageState();
}

class _KatalogProductTabletPageState extends State<KatalogProductTabletPage> {
  int _selectedCategoryIndex = 0;
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderSection(),
        const SizedBox(height: 32),
        CategoryTabs(
          selectedIndex: _selectedCategoryIndex,
          onCategorySelected: (index) {
            setState(() {
              _selectedCategoryIndex = index;
            });
          },
        ),
        const SizedBox(height: 24),
        Expanded(
          child: AnimatedBuilder(
            animation: globalCartState,
            builder: (context, _) {
              return GridView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: dummyProducts.length,
                itemBuilder: (context, index) {
                  final product = dummyProducts[index];
                  final cartItem = globalCartState.items
                      .where((item) => item.product.id == product.id)
                      .toList();
                  final qty = cartItem.isNotEmpty ? cartItem.first.quantity : 0;
                  return ProductCard(
                    title: product.name,
                    category: product.category,
                    price: formatCurrency.format(product.price),
                    quantity: qty,
                    onTap: () {
                      globalCartState.addToCart(product);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
