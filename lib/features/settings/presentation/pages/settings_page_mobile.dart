import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:saji_pos_app/features/cost_setting/domain/entities/cost_setting.dart';
import '../widgets/settings_sync_section.dart';
import '../widgets/settings_payment_section.dart';
import '../widgets/settings_appearance_section.dart';

class SettingsPageMobile extends StatelessWidget {
  final bool isDark;
  final NumberFormat formatCurrency;
  final CostSetting costSetting;
  final int inactiveCount;

  const SettingsPageMobile({
    super.key,
    required this.isDark,
    required this.formatCurrency,
    required this.costSetting,
    required this.inactiveCount,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSyncSection(isDark: isDark, isMobile: true),
          const SizedBox(height: 24),
          SettingsPaymentSection(
            isDark: isDark,
            isMobile: true,
            costSetting: costSetting,
            inactiveCount: inactiveCount,
            formatCurrency: formatCurrency,
          ),
          const SizedBox(height: 24),
          SettingsAppearanceSection(isDark: isDark, isMobile: true),
        ],
      ),
    );
  }
}
