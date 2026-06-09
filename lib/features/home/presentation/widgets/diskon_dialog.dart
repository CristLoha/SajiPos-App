import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DiskonDialog extends StatefulWidget {
  const DiskonDialog({Key? key}) : super(key: key);

  @override
  State<DiskonDialog> createState() => _DiskonDialogState();
}

class _DiskonDialogState extends State<DiskonDialog> {
  bool _isValentineSelected = true;
  bool _isGrandOpeningSelected = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
                const SizedBox(width: 32), // Placeholder to balance the close button for centering
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
                    child: const Icon(Icons.close, color: AppColors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildDiscountOption(
              title: 'Diskon Valentine (10%)',
              subtitle: 'Kode promo: V12',
              isSelected: _isValentineSelected,
              onChanged: (val) {
                setState(() {
                  _isValentineSelected = val ?? false;
                });
              },
            ),
            const SizedBox(height: 24),
            _buildDiscountOption(
              title: 'Diskon Grand Opening (40%)',
              subtitle: 'Kode promo: 10',
              isSelected: _isGrandOpeningSelected,
              onChanged: (val) {
                setState(() {
                  _isGrandOpeningSelected = val ?? false;
                });
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
              border: Border.all(color: isSelected ? AppColors.accent : AppColors.border, width: 2),
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
