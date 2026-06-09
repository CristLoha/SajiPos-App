import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PajakDialog extends StatefulWidget {
  const PajakDialog({Key? key}) : super(key: key);

  @override
  State<PajakDialog> createState() => _PajakDialogState();
}

class _PajakDialogState extends State<PajakDialog> {
  bool _isTax10Selected = true;
  bool _isTax11Selected = true;

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
                    child: const Icon(Icons.close, color: AppColors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildTaxOption(
              title: 'Pajak Pertambahan Nilai',
              subtitle: 'tarif pajak (10%)',
              isSelected: _isTax10Selected,
              onChanged: (val) {
                setState(() {
                  _isTax10Selected = val ?? false;
                });
              },
            ),
            const SizedBox(height: 24),
            _buildTaxOption(
              title: 'Pajak Pertambahan Nilai',
              subtitle: 'tarif pajak (11%)',
              isSelected: _isTax11Selected,
              onChanged: (val) {
                setState(() {
                  _isTax11Selected = val ?? false;
                });
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
