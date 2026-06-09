import 'package:flutter/material.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import '../../widgets/payment_success_view.dart';

class MobilePaymentSuccessPage extends StatelessWidget {
  const MobilePaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: PaymentSuccessView(
          onBackToHome: () {
            // Kembali ke layar paling awal (Home)
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
    );
  }
}
