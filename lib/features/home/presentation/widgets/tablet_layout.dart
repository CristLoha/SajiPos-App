import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/category_tabs.dart';
import '../../../../core/components/custom_sidebar.dart';
import '../widgets/header_section.dart';
import '../widgets/order_panel.dart';
import '../../../../core/components/product_card.dart';

import '../../../../core/data/dummy_data.dart';
import 'package:intl/intl.dart';

class TabletLayout extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const TabletLayout({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<TabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<TabletLayout> {
  int _selectedCategoryIndex = 0;
  
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Row(
          children: [
            CustomSidebar(
              selectedIndex: widget.selectedIndex,
              onItemSelected: widget.onItemSelected,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0, left: 16, right: 16),
                child: Column(
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
                ),
              ),
            ),
            Container(
              width: 360,
              margin: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(-4, 0),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: const OrderPanel(),
            ),
          ],
        ),
      ),
    );
  }
}
