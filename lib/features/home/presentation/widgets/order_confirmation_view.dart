import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:saji_pos_app/features/cart/domain/entities/cart_item.dart';
import 'pajak_dialog.dart';
import 'layanan_dialog.dart';
import 'diskon_dialog.dart';
import 'ongkir_dialog.dart';

class OrderConfirmationView extends StatelessWidget {
  final VoidCallback onProceedToPayment;

  const OrderConfirmationView({super.key, required this.onProceedToPayment});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return Container(
      color: AppColors.white,
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Konfirmasi',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Orders #${cartState.items.length}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: AppColors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Item list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    if (cartState.items.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: Column(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.4,
                                ),
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Keranjang kosong',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...cartState.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _buildOrderItem(
                            context: context,
                            item: item,
                            formatCurrency: formatCurrency,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    _buildActionButtons(context),
                  ],
                ),
              ),
              // Summary
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryRow('Ongkir', 'Rp 0'),
                    const SizedBox(height: 10),
                    _buildSummaryRow('Pajak', '0%'),
                    const SizedBox(height: 10),
                    _buildSummaryRow(
                      'Diskon',
                      '- ${formatCurrency.format(cartState.diskon)} %',
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _buildSummaryRow(
                        'Total Bayar',
                        formatCurrency.format(cartState.total),
                        isBold: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: cartState.items.isEmpty
                            ? null
                            : onProceedToPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          disabledBackgroundColor: AppColors.accent.withValues(
                            alpha: 0.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Lanjutkan Pembayaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderItem({
    required BuildContext context,
    required CartItem item,
    required NumberFormat formatCurrency,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.fastfood_rounded,
                color: AppColors.accent.withValues(alpha: 0.6),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatCurrency.format(item.product.price),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency.format(item.totalPrice),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => context.read<CartCubit>().decreaseQuantity(
                          item.product,
                        ),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Icon(
                            Icons.remove,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 24),
                        alignment: Alignment.center,
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            context.read<CartCubit>().addToCart(item.product),
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Icon(
                            Icons.add,
                            size: 16,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.centerLeft,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Catatan pesanan...',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                  onChanged: (val) {
                    context.read<CartCubit>().updateNote(item.product, val);
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                context.read<CartCubit>().updateQuantity(item.product, 0);
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.danger,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(Icons.local_shipping_outlined, 'Ongkir', () {
          showDialog(
            context: context,
            builder: (context) => const OngkirDialog(),
          );
        }),
        _buildActionButton(Icons.discount_outlined, 'Diskon', () {
          showDialog(
            context: context,
            builder: (context) => const DiskonDialog(),
          );
        }),
        _buildActionButton(Icons.receipt_long_outlined, 'Pajak', () {
          showDialog(
            context: context,
            builder: (context) => const PajakDialog(),
          );
        }),
        _buildActionButton(Icons.storefront_outlined, 'Layanan', () {
          showDialog(
            context: context,
            builder: (context) => const LayananDialog(),
          );
        }),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.accent, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? AppColors.accent : AppColors.textPrimary,
            fontSize: isBold ? 18 : 14,
          ),
        ),
      ],
    );
  }
}
