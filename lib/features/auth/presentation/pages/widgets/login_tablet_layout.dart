import 'package:flutter/material.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import 'package:saji_pos_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'login_form_widget.dart';

class LoginTabletLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onLoginPressed;
  final VoidCallback onToggleObscure;
  final AuthState state;

  const LoginTabletLayout({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLoginPressed,
    required this.onToggleObscure,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 880,
      height: 600,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Row(
          children: [
            Expanded(flex: 5, child: _buildBrandingPanel()),
            Expanded(flex: 4, child: _buildFormPanel()),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingPanel() {
    return Container(
      padding: const EdgeInsets.all(48),
      color: AppColors.primary.withValues(alpha: 0.95),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBrandingLogo(),
          const SizedBox(height: 32),
          _buildBrandingTitle(),
          const SizedBox(height: 14),
          _buildBrandingDescription(),
        ],
      ),
    );
  }

  Widget _buildBrandingLogo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.storefront_rounded,
        size: 40,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildBrandingTitle() {
    return const Text(
      'SajiPos.',
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: AppColors.white,
        letterSpacing: -1,
      ),
    );
  }

  Widget _buildBrandingDescription() {
    return Text(
      'Sistem manajemen kasir modern.\nKelola pesanan, pantau penjualan,\ntingkatkan efisiensi restoran Anda.',
      style: TextStyle(
        fontSize: 15,
        color: AppColors.white.withValues(alpha: 0.6),
        height: 1.6,
      ),
    );
  }

  Widget _buildFormPanel() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 32),
      child: LoginFormWidget(
        formKey: formKey,
        emailController: emailController,
        passwordController: passwordController,
        obscurePassword: obscurePassword,
        rememberMe: rememberMe,
        onRememberMeChanged: onRememberMeChanged,
        onLoginPressed: onLoginPressed,
        onToggleObscure: onToggleObscure,
        state: state,
      ),
    );
  }
}
