import 'package:flutter/material.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import '../../widgets/payment_view.dart';
import 'mobile_payment_success_page.dart';

class MobilePaymentPage extends StatelessWidget {
  const MobilePaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
        title: const Text(
          'Selesaikan Pembayaran',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: PaymentView(
          onCancel: () {
            Navigator.pop(context);
          },
          onConfirm: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MobilePaymentSuccessPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
