import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:saji_pos_app/features/cost_setting/domain/entities/cost_setting.dart';
import 'package:saji_pos_app/features/auth/presentation/bloc/auth_bloc.dart';
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
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Keluar dari Akun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Keluar Aplikasi'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun kasir ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AuthBloc>().add(AuthLogoutProcess());
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}
