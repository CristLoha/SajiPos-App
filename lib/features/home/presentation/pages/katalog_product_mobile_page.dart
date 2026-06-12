import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import 'package:saji_pos_app/features/product/presentation/bloc/product_bloc.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../core/components/product_card.dart';
import '../../../../core/constants/api_constants.dart';
import '../widgets/category_tabs.dart';
import '../widgets/header_section.dart';

class KatalogProductMobilePage extends StatefulWidget {
  const KatalogProductMobilePage({super.key});

  @override
  State<KatalogProductMobilePage> createState() => _KatalogProductPageState();
}

class _KatalogProductPageState extends State<KatalogProductMobilePage> {
  int _selectedCategoryIndex = 0;
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                );
              }

              if (state is ProductError) {
                return Center(
                  child: Text(
                    'Terjadi kesalahan: ${state.message}',
                    style: TextStyle(color: AppColors.danger),
                  ),
                );
              }

              if (state is ProductLoaded) {
                final products = state.products;

                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada produk yang tersedia.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                return AnimatedBuilder(
                  animation: globalCartState,
                  builder: (context, _) {
                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final cartItem = globalCartState.items
                            .where((item) => item.product.id == product.id)
                            .toList();
                        final qty = cartItem.isNotEmpty
                            ? cartItem.first.quantity
                            : 0;
                            
                        final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
                        final imageUrl = product.image.isNotEmpty ? '$baseUrl/storage/${product.image}' : null;

                        return ProductCard(
                          title: product.name,
                          category: product.category,
                          price: formatCurrency.format(product.price),
                          quantity: qty,
                          imageUrl: imageUrl,
                          onTap: () {
                            globalCartState.addToCart(product);
                          },
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
