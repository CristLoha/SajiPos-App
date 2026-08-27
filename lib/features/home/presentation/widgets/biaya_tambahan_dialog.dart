import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:saji_pos_app/features/cost_setting/presentation/bloc/cost_setting_bloc.dart';
import '../../../../core/constants/app_colors.dart';

class BiayaTambahanDialog extends StatelessWidget {
  const BiayaTambahanDialog({super.key});

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
        child: BlocBuilder<CostSettingBloc, CostSettingState>(
          builder: (context, costState) {
            final costSetting = costState is CostSettingLoaded
                ? costState.costSetting
                : null;
            final defaultTax = costSetting?.taxPercentage ?? 0.0;

            return BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                final currentTax = cartState.taxPercentage;
                final isSelected = currentTax > 0;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 32),
                        const Expanded(
                          child: Text(
                            'PAJAK',
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

                    if (defaultTax > 0)
                      _buildTaxOption(
                        title: 'Pajak (PPN)',
                        subtitle:
                            '${defaultTax.toStringAsFixed(defaultTax.truncateToDouble() == defaultTax ? 0 : 1)}%',
                        isSelected: isSelected,
                        onChanged: () {
                          context.read<CartCubit>().updateCosts(
                            taxPercentage: isSelected ? 0.0 : defaultTax,
                            includeShippingInTax:
                                costSetting?.includeShippingInTax ?? false,
                            includeServiceFeeInTax:
                                costSetting?.includeServiceFeeInTax ?? false,
                          );
                        },
                      )
                    else
                      const Center(
                        child: Text(
                          'Pajak belum diatur di Pengaturan',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),

                    const SizedBox(height: 16),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaxOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onChanged,
  }) {
    return GestureDetector(
      onTap: onChanged,
      behavior: HitTestBehavior.opaque,
      child: Row(
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
          Container(
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
        ],
      ),
    );
  }
}
