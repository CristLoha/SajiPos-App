import 'package:flutter/material.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import 'package:saji_pos_app/features/auth/presentation/bloc/auth_bloc.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onLoginPressed;
  final VoidCallback onToggleObscure;
  final AuthState state;

  const LoginFormWidget({
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
    // Membungkus seluruh text field di dalam Form widget dengan kunci validasi
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 36),
          _buildEmailLabel(),
          const SizedBox(height: 8),
          _buildEmailTextField(),
          const SizedBox(height: 22),
          _buildPasswordLabel(),
          const SizedBox(height: 8),
          _buildPasswordTextField(),
          const SizedBox(height: 12),
          _buildRememberMe(),
          const SizedBox(height: 24),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildRememberMe() {
    return GestureDetector(
      onTap: () => onRememberMeChanged(!rememberMe),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: rememberMe,
              onChanged: onRememberMeChanged,
              activeColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Ingat Saya',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selamat Datang',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Masuk untuk melanjutkan ke kasir',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildEmailLabel() {
    return const Text(
      'Email atau Username',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        fontSize: 13,
      ),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      controller: emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // Validasi input email kosong
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email atau username wajib diisi';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'admin@sajipos.com',
        hintStyle: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.6),
        ),
        prefixIcon: Icon(
          Icons.alternate_email_rounded,
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordLabel() {
    return const Text(
      'Kata Sandi',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        fontSize: 13,
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: passwordController,
      obscureText: obscurePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // Validasi input password kosong
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Kata sandi wajib diisi';
        }
        return null;
      },

      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.6),
        ),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: AppColors.textSecondary,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            color: AppColors.textSecondary,
          ),
          onPressed: onToggleObscure,
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: state is AuthLoading ? null : onLoginPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Masuk ke Sistem',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
