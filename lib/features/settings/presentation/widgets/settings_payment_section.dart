import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import 'settings_card.dart';
import 'edit_cost_dialog.dart';
import 'package:saji_pos_app/features/cost_setting/presentation/bloc/cost_setting_bloc.dart';
import 'package:saji_pos_app/features/cost_setting/domain/entities/cost_setting.dart';
import 'package:saji_pos_app/features/cost_setting/presentation/pages/cost_setting_page.dart';

class SettingsPaymentSection extends StatelessWidget {
  final bool isDark;
  final bool isMobile;
  final CostSetting costSetting;
  final int inactiveCount;
  final NumberFormat formatCurrency;

  const SettingsPaymentSection({
    super.key,
    required this.isDark,
    required this.isMobile,
    required this.costSetting,
    required this.inactiveCount,
    required this.formatCurrency,
  });

  Future<void> _showEditDialog(
    BuildContext context, {
    required String title,
    required String currentValue,
    required String hint,
    String? prefix,
    String? suffix,
    required Function(double) onSave,
  }) async {
    final result = await showDialog<double>(
      context: context,
      builder: (context) => EditCostDialog(
        title: title,
        currentValue: currentValue,
        hint: hint,
        prefix: prefix,
        suffix: suffix,
      ),
    );

    if (result != null) {
      onSave(result);
    }
  }

  void _updateCostField(
    BuildContext context, {
    required CostSetting current,
    double? taxPercentage,
    double? shippingFee,
    double? serviceFee,
  }) {
    final updated = CostSetting(
      taxPercentage: taxPercentage ?? current.taxPercentage,
      shippingFee: shippingFee ?? current.shippingFee,
      includeShippingInTax: current.includeShippingInTax,
      serviceFee: serviceFee ?? current.serviceFee,
      includeServiceFeeInTax: current.includeServiceFeeInTax,
    );
    context.read<CostSettingBloc>().add(UpdateCostSettingEvent(updated));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengaturan berhasil diperbarui'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildCostListRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required bool isActive,
    required bool isDark,
    required VoidCallback onEdit,
  }) {
    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.accent),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
            if (!isActive)
              Container(
                margin: const EdgeInsets.only(right: 8),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.warning,
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              isActive ? value : (title.contains('Pajak') ? '0%' : 'Rp 0'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive
                    ? (isDark ? Colors.white : AppColors.textPrimary)
                    : (isDark ? Colors.white54 : AppColors.textSecondary),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.edit_outlined,
              size: 18,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isMobile) {
      // In tablet mode, directly embed the CostSettingPage as the detail view!
      return const CostSettingPage(isEmbedded: true);
    }

    final children = [
      const Divider(height: 1),
      _buildCostListRow(
        context: context,
        icon: Icons.receipt_long_rounded,
        title: 'Pajak (PPN)',
        value:
            '${costSetting.taxPercentage.toStringAsFixed(costSetting.taxPercentage.truncateToDouble() == costSetting.taxPercentage ? 0 : 1)}%',
        isActive: costSetting.taxPercentage > 0,
        isDark: isDark,
        onEdit: () => _showEditDialog(
          context,
          title: 'Pajak (PPN)',
          currentValue: costSetting.taxPercentage > 0
              ? costSetting.taxPercentage.toString()
              : '',
          hint: '11',
          suffix: '%',
          onSave: (val) => _updateCostField(
            context,
            current: costSetting,
            taxPercentage: val,
          ),
        ),
      ),
      const Divider(height: 1),
      _buildCostListRow(
        context: context,
        icon: Icons.local_shipping_rounded,
        title: 'Ongkos Kirim',
        value: formatCurrency.format(costSetting.shippingFee),
        isActive: costSetting.shippingFee > 0,
        isDark: isDark,
        onEdit: () => _showEditDialog(
          context,
          title: 'Ongkos Kirim',
          currentValue: costSetting.shippingFee > 0
              ? costSetting.shippingFee.toString()
              : '',
          hint: '10000',
          prefix: 'Rp',
          onSave: (val) =>
              _updateCostField(context, current: costSetting, shippingFee: val),
        ),
      ),
      const Divider(height: 1),
      _buildCostListRow(
        context: context,
        icon: Icons.room_service_rounded,
        title: 'Biaya Layanan',
        value: formatCurrency.format(costSetting.serviceFee),
        isActive: costSetting.serviceFee > 0,
        isDark: isDark,
        onEdit: () => _showEditDialog(
          context,
          title: 'Biaya Layanan',
          currentValue: costSetting.serviceFee > 0
              ? costSetting.serviceFee.toString()
              : '',
          hint: '5000',
          prefix: 'Rp',
          onSave: (val) =>
              _updateCostField(context, current: costSetting, serviceFee: val),
        ),
      ),
    ];

    return SettingsCard(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: inactiveCount > 0,
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.payment_rounded,
                color: AppColors.accent,
                size: 20,
              ),
            ),
            title: Text(
              'Kelola Pembayaran',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            subtitle: inactiveCount > 0
                ? Text(
                    '$inactiveCount belum diatur',
                    style: const TextStyle(
                      color: AppColors.warning,
                      fontSize: 13,
                    ),
                  )
                : null,
            children: children,
          ),
        ),
      ],
    );
  }
}
