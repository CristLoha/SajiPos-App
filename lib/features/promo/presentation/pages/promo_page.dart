import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';
import 'promo_mobile_page.dart';
import 'promo_tablet_page.dart';

class PromoPage extends StatelessWidget {
  const PromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: PromoMobilePage(),
      tablet: PromoTabletPage(),
    );
  }
}
