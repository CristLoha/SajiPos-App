import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/components/custom_sidebar.dart';
import '../widgets/order_panel.dart';
import '../pages/katalog_product_tablet_page.dart';
import '../pages/promo_page.dart';
import '../pages/report_page.dart';
import '../pages/settings_page.dart';

class TabletLayout extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const TabletLayout({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  Widget _buildBody() {
    switch (selectedIndex) {
      case 0:
        return const KatalogProductTabletPage();
      case 1:
        return const PromoPage();
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
      backgroundColor: AppColors.backgroundLight,
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
            // Tampilkan panel keranjang pesanan hanya pada tab transaksi utama (Katalog Produk)
            if (selectedIndex == 0)
              Container(
                width: 360,
                margin: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
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
