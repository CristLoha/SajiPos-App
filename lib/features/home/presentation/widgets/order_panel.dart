import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'order_confirmation_view.dart';
import 'payment_view.dart';
import 'payment_success_view.dart';

enum OrderFlowState { confirmation, payment, success }

class OrderPanel extends StatefulWidget {
  const OrderPanel({Key? key}) : super(key: key);

  @override
  State<OrderPanel> createState() => _OrderPanelState();
}

class _OrderPanelState extends State<OrderPanel> {
  OrderFlowState _currentState = OrderFlowState.confirmation;

  void _goToPayment() {
    setState(() {
      _currentState = OrderFlowState.payment;
    });
  }

  void _goToConfirmation() {
    setState(() {
      _currentState = OrderFlowState.confirmation;
    });
  }

  void _finishOrder() {
    setState(() {
      _currentState = OrderFlowState.success;
    });
  }
  
  void _resetOrder() {
    context.read<CartCubit>().clearCart();
    setState(() {
      _currentState = OrderFlowState.confirmation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: _buildCurrentView(),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentState) {
      case OrderFlowState.confirmation:
        return OrderConfirmationView(onProceedToPayment: _goToPayment);
      case OrderFlowState.payment:
        return PaymentView(onCancel: _goToConfirmation, onConfirm: _finishOrder);
      case OrderFlowState.success:
        return PaymentSuccessView(onBackToHome: _resetOrder);
    }
  }
}
