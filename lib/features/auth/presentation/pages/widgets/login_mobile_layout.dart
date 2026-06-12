import 'package:flutter/material.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import 'package:saji_pos_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'login_form_widget.dart';

class LoginMobileLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onLoginPressed;
  final AuthState state;
  final VoidCallback onToggleObscure;

  const LoginMobileLayout({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLoginPressed,
    required this.state,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.white,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: _buildLogoIcon()),
                const SizedBox(height: 24),
                Center(child: _buildTitle()),
                const SizedBox(height: 48),
                _buildLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.storefront_rounded, size: 36, color: AppColors.white),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'SajiPos',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildLoginForm() {
    return LoginFormWidget(
      formKey: formKey,
      emailController: emailController,
      passwordController: passwordController,
      obscurePassword: obscurePassword,
      rememberMe: rememberMe,
      onRememberMeChanged: onRememberMeChanged,
      onLoginPressed: onLoginPressed,
      onToggleObscure: onToggleObscure,
      state: state,
    );
  }
}
