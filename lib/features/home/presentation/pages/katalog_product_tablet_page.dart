import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/features/settings/presentation/cubit/sync_cubit.dart';
import 'package:intl/intl.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import 'package:saji_pos_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:saji_pos_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../widgets/product_card.dart';
import '../../../../core/components/custom_error_widget.dart';
import '../widgets/category_tabs.dart';
import '../widgets/header_section.dart';

class KatalogProductTabletPage extends StatefulWidget {
  const KatalogProductTabletPage({super.key});

  @override
  State<KatalogProductTabletPage> createState() =>
      _KatalogProductTabletPageState();
}

class _KatalogProductTabletPageState extends State<KatalogProductTabletPage> {
  int _selectedCategoryIndex = 0;
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderSection(),
        const SizedBox(height: 32),
        CategoryTabs(
          selectedIndex: _selectedCategoryIndex,
          onCategorySelected: (index, categoryId) {
            setState(() {
              _selectedCategoryIndex = index;
            });
            final filterId = categoryId == 0 ? null : categoryId;
            context.read<ProductBloc>().add(
              GetProductsEvent(categoryId: filterId, isCategoryUpdate: true),
            );
          },
        ),
        const SizedBox(height: 24),
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return Skeletonizer(
                  enabled: true,
                  child: GridView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 100,
                      left: 24,
                      right: 24,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        title: 'Nama Produk Yang Sangat Panjang',
                        category: 'Kategori Makanan',
                        price: 'Rp 150.000',
                        quantity: 0,
                        imageUrl: null,
                        onTap: () {},
                      );
                    },
                  ),
                );
              }

              if (state is ProductError) {
                final isNetworkError =
                    state.message.toLowerCase().contains('socket') ||
                    state.message.toLowerCase().contains('network') ||
                    state.message.toLowerCase().contains('connection');

                return CustomErrorWidget(
                  title: isNetworkError
                      ? 'Koneksi Terputus'
                      : 'Oops! Server Bermasalah',
                  message: isNetworkError
                      ? 'Pastikan kamu terhubung ke WiFi atau data seluler ya.'
                      : 'Tenang, data kamu aman. Tim kami sedang memperbaiki masalah ini.',
                  icon: isNetworkError
                      ? Icons.wifi_off_rounded
                      : Icons.dns_rounded,
                  onRetry: () {
                    context.read<ProductBloc>().add(GetProductsEvent());
                    context.read<CategoryBloc>().add(GetCategoriesEvent());
                  },
                );
              }

              if (state is ProductLoaded) {
                final products = state.products;
                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada di kategori ini.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return BlocBuilder<CartCubit, CartState>(
                  builder: (context, cartState) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<SyncCubit>().syncData();
                        await Future.delayed(const Duration(seconds: 1));
                      },
                      color: AppColors.accent,
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          bottom: 100,
                          left: 24,
                          right: 24,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                            ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final cartItem = cartState.items
                              .where((item) => item.product.id == product.id)
                              .toList();
                          final qty = cartItem.isNotEmpty
                              ? cartItem.first.quantity
                              : 0;

                          return ProductCard(
                            title: product.name,
                            category: product.category,
                            price: formatCurrency.format(product.price),
                            quantity: qty,
                            stock: product.stock,
                            imageUrl: product.fullImageUrl,
                            discountPrice: product.discountPrice != null
                                ? formatCurrency.format(product.discountPrice)
                                : null,
                            onTap: () {
                              context.read<CartCubit>().addToCart(product);
                            },
                            onAdd: () {
                              context.read<CartCubit>().addToCart(product);
                            },
                            onRemove: () {
                              context.read<CartCubit>().decreaseQuantity(product);
                            },
                          );
                        },
                      ),
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
