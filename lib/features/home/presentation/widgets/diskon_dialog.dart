import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/features/discount/presentation/bloc/discount_bloc.dart';
import '../../../../core/constants/app_colors.dart';

class DiskonDialog extends StatefulWidget {
  const DiskonDialog({super.key});

  @override
  State<DiskonDialog> createState() => _DiskonDialogState();
}

class _DiskonDialogState extends State<DiskonDialog> {
  final Set<int> _selectedDiscountIds = {};

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
              builder: (context, state) {
                if (state is DiscountLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DiscountError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is DiscountEmpty) {
                  return const Center(child: Text('Tidak ada diskon tersedia'));
                } else if (state is DiscountLoaded) {
                  final discounts = state.discounts;

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: discounts.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final discount = discounts[index];

                      final isSelected = _selectedDiscountIds.contains(
                        discount.id,
                      );

                      return _buildDiscountOption(
                        title: discount.name ?? 'Diskon',
                        subtitle: 'Potongan: ${discount.value}',
                        isSelected: isSelected,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedDiscountIds.add(discount.id);
                            } else {
                              _selectedDiscountIds.remove(discount.id);
                            }
                          });
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
