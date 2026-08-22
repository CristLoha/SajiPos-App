import 'package:flutter/material.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import '../../widgets/order_confirmation_view.dart';
import 'mobile_payment_page.dart';

class MobileOrderConfirmationPage extends StatelessWidget {
  const MobileOrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: OrderConfirmationView(
          onProceedToPayment: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MobilePaymentPage()),
            );
          },
        ),
      ),
    );
  }
}
