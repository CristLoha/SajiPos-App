import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:saji_pos_app/features/promo/presentation/bloc/discount/discount_bloc.dart';
import '../../../../core/constants/app_colors.dart';

class DiskonDialog extends StatelessWidget {
  const DiskonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 316,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 32),
                const Expanded(
                  child: Text(
                    'DISKON',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            BlocBuilder<DiscountBloc, DiscountState>(
              builder: (context, discountState) {
                if (discountState is DiscountLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (discountState is DiscountError) {
                  return Center(
                    child: Text(
                      discountState.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (discountState is DiscountEmpty) {
                  return const Center(child: Text('Tidak ada diskon tersedia'));
                } else if (discountState is DiscountLoaded) {
                  final discounts = discountState.discounts;

                  return BlocBuilder<CartCubit, CartState>(
                    builder: (context, cartState) {
                      final selectedIds = cartState.selectedDiscountIds;
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: discounts.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 24),
                        itemBuilder: (context, index) {
                          final discount = discounts[index];

                          final isSelected = selectedIds.contains(discount.id);

                          return _buildDiscountOption(
                            title: discount.name ?? 'Diskon',
                            subtitle: discount.type == 'percentage'
                                ? 'Diskon: ${discount.value}%'
                                : 'Potongan: Rp ${discount.value}',
                            isSelected: isSelected,
                            onChanged: (val) {
                              final newSelectedIds = Set<int>.from(selectedIds);
                              if (val == true) {
                                newSelectedIds.add(discount.id);
                              } else {
                                newSelectedIds.remove(discount.id);
                              }

                              double subTotal = cartState.subTotal;
                              double totalDiskonRp = 0;

                              for (var d in discounts) {
                                if (newSelectedIds.contains(d.id)) {
                                  double angkaDiskon = d.value ?? 0.0;
                                  if (d.type == 'percentage') {
                                    totalDiskonRp +=
                                        (subTotal * angkaDiskon / 100);
                                  } else {
                                    totalDiskonRp += angkaDiskon;
                                  }
                                }
                              }
                              context.read<CartCubit>().setDiskon(
                                totalDiskonRp,
                                selectedIds: newSelectedIds,
                              );
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

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => onChanged(!isSelected),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent : AppColors.white,
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.border,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: AppColors.white, size: 20)
                : null,
          ),
        ),
      ],
    );
  }
}
