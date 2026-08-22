import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';
import 'discount_mobile_page.dart';
import 'discount_tablet_page.dart';

class DiscountPage extends StatelessWidget {
  const DiscountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: DiscountMobilePage(),
      tablet: DiscountTabletPage(),
    );
  }
}
