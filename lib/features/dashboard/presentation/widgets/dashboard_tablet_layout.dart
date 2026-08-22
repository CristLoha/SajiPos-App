import 'package:flutter/material.dart';
import 'package:saji_pos_app/features/discount/presentation/pages/discount_page.dart';

import '../../../../core/components/custom_sidebar.dart';
import 'package:saji_pos_app/features/home/presentation/widgets/order_panel.dart';
import 'package:saji_pos_app/features/home/presentation/pages/katalog_product_tablet_page.dart';
import '../../../report/presentation/pages/report_page.dart';
import 'package:saji_pos_app/features/settings/presentation/pages/settings_page.dart';

class DashboardTabletLayout extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const DashboardTabletLayout({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  Widget _buildBody() {
    switch (selectedIndex) {
      case 0:
        return const KatalogProductTabletPage();
      case 1:
        return const DiscountPage();
      case 2:
        return const ReportPage();
      case 3:
        return const SettingsPage();
      default:
        return const KatalogProductTabletPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            CustomSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: onItemSelected,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0, left: 16, right: 16),
                child: _buildBody(),
              ),
            ),
            
            if (selectedIndex == 0)
              Container(
                width: 360,
                margin: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(-4, 0),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: const OrderPanel(),
              ),
          ],
        ),
      ),
    );
  }
}
