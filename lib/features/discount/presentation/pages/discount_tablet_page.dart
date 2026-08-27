import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../domain/entities/discount.dart';
import '../bloc/discount_bloc.dart';

class DiscountTabletPage extends StatefulWidget {
  const DiscountTabletPage({super.key});

  @override
  State<DiscountTabletPage> createState() => _DiscountTabletPageState();
}

class _DiscountTabletPageState extends State<DiscountTabletPage> {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchDiscounts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _fetchDiscounts() {
    String status = 'active';
    if (_selectedTabIndex == 1) {
      status = 'upcoming';
    } else if (_selectedTabIndex == 2) {
      status = 'expired';
    }

    context.read<DiscountBloc>().add(
      FetchActiveDiscounts(
        search: _searchController.text.isNotEmpty
            ? _searchController.text
            : null,
        status: status,
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchDiscounts();
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _fetchDiscounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unified White Header
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row (Title + Search + Filter)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Diskon',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 320,
                              height: 48,
                              child: TextField(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                decoration: InputDecoration(
                                  hintText: 'Cari nama atau kode diskon...',
                                  hintStyle: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    color: AppColors.textSecondary,
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.filter_list_rounded,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Segmented Control / Tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTab(0, 'Berlaku Sekarang'),
                            _buildTab(1, 'Akan Datang'),
                            _buildTab(2, 'Kedaluwarsa'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Promo List
            Expanded(
              child: BlocBuilder<DiscountBloc, DiscountState>(
                builder: (context, state) {
                  if (state is DiscountLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DiscountError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppColors.danger),
                      ),
                    );
                  } else if (state is DiscountEmpty) {
                    return _buildEmptyState();
                  } else if (state is DiscountLoaded) {
                    final discounts = state.discounts;
                    return GridView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 24,
                        left: 24,
                        right: 24,
                        top: 24,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: discounts.length,
                      itemBuilder: (context, index) {
                        return _buildDiscountCard(discounts[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => _onTabChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountCard(Discount discount) {
    Color statusColor;
    String statusText;
    switch (discount.status) {
      case 'active':
        statusColor = AppColors.success;
        statusText = 'Aktif';
        break;
      case 'upcoming':
        statusColor = AppColors.grey;
        statusText = 'Akan Datang';
        break;
      case 'expired':
      default:
        statusColor = AppColors.danger;
        statusText = 'Kedaluwarsa';
        break;
    }

    String discountType = discount.type.toLowerCase();
    String discountValue =
        (discountType == 'percent' ||
            discountType == 'percentage' ||
            discountType == 'persen' ||
            discountType == 'persentase')
        ? '${discount.value?.toInt() ?? 0}%'
        : NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(discount.value ?? 0);

    String terms =
        discount.description ??
        (discount.minTransaction != null
            ? 'Min. transaksi ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(discount.minTransaction)}'
            : 'Tanpa min. transaksi');

    String startDate = DateFormat(
      'dd MMM yyyy',
      'id_ID',
    ).format(discount.startDate);
    String endDate = DateFormat(
      'dd MMM yyyy',
      'id_ID',
    ).format(discount.expiredDate);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Tinggi dinamis sesuai konten
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  discount.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Code
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: discount.code));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kode diskon disalin!')),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  style: BorderStyle.solid,
                  color: AppColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    discount.code,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.copy,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Value
          Row(
            children: [
              const Icon(
                Icons.local_offer_outlined,
                color: AppColors.accent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Diskon $discountValue',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),

          // Terms & Dates
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  terms,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Berlaku: $startDate s.d $endDate',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Button
          if (_selectedTabIndex == 0)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  final cartCubit = context.read<CartCubit>();
                  cartCubit.applyVoucherDiscount(discount);

                  final cartSubTotal = cartCubit.state.subTotal;
                  if (cartSubTotal == 0 ||
                      (discount.minTransaction != null &&
                          cartSubTotal < discount.minTransaction!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Diskon diaktifkan. Silakan tambahkan pesanan minimal Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(discount.minTransaction ?? 0)}.',
                        ),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Diskon berhasil diterapkan ke pesanan!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
                child: const Text('Gunakan di Transaksi'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.discount_outlined, size: 64, color: AppColors.border),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada diskon di kategori ini',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          if (_selectedTabIndex == 0)
            const Text(
              'Tidak ada diskon aktif saat ini.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }
}
