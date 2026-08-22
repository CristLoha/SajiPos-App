import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../cubit/sync_cubit.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_layout.dart';

import 'package:saji_pos_app/features/cost_setting/presentation/bloc/cost_setting_bloc.dart';
import 'package:saji_pos_app/features/cost_setting/domain/entities/cost_setting.dart';

import 'settings_page_mobile.dart';
import 'settings_page_tablet.dart';

enum SettingsTab { sync, payment, appearance }

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsTab _selectedTab = SettingsTab.payment;
  bool _initialized = false;
  CostSetting? _lastKnownCostSetting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Pengaturan Kasir')),
      body: SafeArea(
        child: BlocListener<CostSettingBloc, CostSettingState>(
          listener: (context, state) {
            if (state is CostSettingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gagal menyimpan: ${state.message}'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: BlocListener<SyncCubit, SyncState>(
            listener: (context, syncState) {
              if (syncState.isSuccess && !syncState.isLoading) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sinkronisasi data berhasil!'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: BlocBuilder<CostSettingBloc, CostSettingState>(
              builder: (context, costState) {
                if (costState is CostSettingLoaded) {
                  _lastKnownCostSetting = costState.costSetting;
                }

                final costSetting =
                    _lastKnownCostSetting ??
                    const CostSetting(
                      taxPercentage: 0,
                      shippingFee: 0,
                      includeShippingInTax: false,
                      serviceFee: 0,
                      includeServiceFeeInTax: false,
                    );

                int inactiveCount = 0;
                if (costSetting.taxPercentage <= 0) inactiveCount++;
                if (costSetting.shippingFee <= 0) inactiveCount++;
                if (costSetting.serviceFee <= 0) inactiveCount++;

                if (!_initialized) {
                  _initialized = true;
                  if (inactiveCount > 0) {
                    _selectedTab = SettingsTab.payment;
                  } else {
                    _selectedTab = SettingsTab.sync;
                  }
                }

                return ResponsiveLayout(
                  mobile: SettingsPageMobile(
                    isDark: isDark,
                    formatCurrency: formatCurrency,
                    costSetting: costSetting,
                    inactiveCount: inactiveCount,
                  ),
                  tablet: SettingsPageTablet(
                    isDark: isDark,
                    formatCurrency: formatCurrency,
                    costSetting: costSetting,
                    inactiveCount: inactiveCount,
                    selectedTab: _selectedTab,
                    onTabChanged: (tab) {
                      setState(() {
                        _selectedTab = tab;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
