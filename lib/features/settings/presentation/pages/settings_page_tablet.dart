import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:saji_pos_app/features/cost_setting/domain/entities/cost_setting.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/settings_sync_section.dart';
import '../widgets/settings_payment_section.dart';
import '../widgets/settings_appearance_section.dart';
import 'settings_page.dart'; // To get SettingsTab

class SettingsPageTablet extends StatelessWidget {
  final bool isDark;
  final NumberFormat formatCurrency;
  final CostSetting costSetting;
  final int inactiveCount;
  final SettingsTab selectedTab;
  final ValueChanged<SettingsTab> onTabChanged;

  const SettingsPageTablet({
    super.key,
    required this.isDark,
    required this.formatCurrency,
    required this.costSetting,
    required this.inactiveCount,
    required this.selectedTab,
    required this.onTabChanged,
  });

  Widget _buildTabletMasterItem({
    required String title,
    required IconData icon,
    required SettingsTab tab,
    required bool isDark,
    int badgeCount = 0,
  }) {
    final isSelected = selectedTab == tab;
    return InkWell(
      onTap: () => onTabChanged(tab),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.1))
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.white70 : AppColors.textSecondary),
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? Colors.white : AppColors.textPrimary),
                ),
              ),
            ),
            if (badgeCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Master
        Container(
          width: 300,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: isDark ? Colors.white12 : AppColors.border,
              ),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildTabletMasterItem(
                title: 'Database & Sinkronisasi',
                icon: Icons.cloud_sync_rounded,
                tab: SettingsTab.sync,
                isDark: isDark,
              ),
              _buildTabletMasterItem(
                title: 'Kelola Pembayaran',
                icon: Icons.payment_rounded,
                tab: SettingsTab.payment,
                isDark: isDark,
                badgeCount: inactiveCount,
              ),
              _buildTabletMasterItem(
                title: 'Preferensi Tampilan',
                icon: Icons.dark_mode_rounded,
                tab: SettingsTab.appearance,
                isDark: isDark,
              ),
            ],
          ),
        ),
        // Right Column: Detail
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedTab == SettingsTab.sync)
                    SettingsSyncSection(isDark: isDark, isMobile: false),
                  if (selectedTab == SettingsTab.payment)
                    SettingsPaymentSection(
                      isDark: isDark,
                      isMobile: false,
                      costSetting: costSetting,
                      inactiveCount: inactiveCount,
                      formatCurrency: formatCurrency,
                    ),
                  if (selectedTab == SettingsTab.appearance)
                    SettingsAppearanceSection(isDark: isDark, isMobile: false),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
