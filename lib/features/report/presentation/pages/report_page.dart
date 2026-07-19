import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';
import 'report_mobile_page.dart';
import 'report_tablet_page.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: ReportMobilePage(),
      tablet: ReportTabletPage(),
    );
  }
}
