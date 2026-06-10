import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/category_tabs.dart';
import '../../../../core/components/custom_bottom_nav.dart';
import '../widgets/header_section.dart';
import '../../../../core/components/product_card.dart';
import '../pages/checkout/mobile_order_confirmation_page.dart';


import 'package:intl/intl.dart';

class MobileLayout extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const MobileLayout({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int _selectedCategoryIndex = 0;
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  void _showOrderPanel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MobileOrderConfirmationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const HeaderSection(),
              const SizedBox(height: 24),
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
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
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
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: widget.selectedIndex,
        onItemSelected: widget.onItemSelected,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        elevation: 4,
        onPressed: _showOrderPanel,
        child: const Icon(Icons.shopping_cart_rounded, color: AppColors.white),
      ),
    );
  }
}

