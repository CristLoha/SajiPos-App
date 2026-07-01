import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_cubit.dart';
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
            context.read<CartCubit>().clearCart();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
    );
  }
}
