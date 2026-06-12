import 'package:flutter/material.dart';
import 'package:saji_pos_app/features/home/presentation/pages/katalog_product_mobile_page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/components/custom_bottom_nav.dart';
import '../pages/checkout/mobile_order_confirmation_page.dart';
import '../pages/promo_page.dart';
import '../pages/report_page.dart';
import '../pages/settings_page.dart';

class MobileLayout extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const MobileLayout({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  void _showOrderPanel(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MobileOrderConfirmationPage(),
      ),
    );
  }

  Widget _buildBody() {
    switch (selectedIndex) {
      case 0:
        return const KatalogProductMobilePage();
      case 1:
        return const PromoPage();
      case 2:
        return const ReportPage();
      case 3:
        return const SettingsPage();
      default:
        return const KatalogProductMobilePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildBody(),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: selectedIndex,
        onItemSelected: onItemSelected,
      ),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: AppColors.accent,
              elevation: 4,
              onPressed: () => _showOrderPanel(context),
              child: const Icon(
                Icons.shopping_cart_rounded,
                color: AppColors.white,
              ),
            )
          : null,
    );
  }
}
