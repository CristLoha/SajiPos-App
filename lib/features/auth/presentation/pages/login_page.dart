import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/components/custom_snackbar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../home/presentation/home_page.dart';
import 'widgets/login_mobile_layout.dart';
import 'widgets/login_tablet_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // GlobalKey untuk validasi form kasir
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      context.read<AuthBloc>().add(
        AuthLoginProcess(email: email, password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          _buildTopBlurOrb(),
          _buildBottomBlurOrb(),
          _buildGlassEffectBlur(),
          _buildMainResponsiveLayout(),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F1629), Color(0xFF1A1D3B), Color(0xFF1E2A5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildTopBlurOrb() {
    return Positioned(
      top: -80,
      right: -60,
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  Widget _buildBottomBlurOrb() {
    return Positioned(
      bottom: -100,
      left: -100,
      child: Container(
        width: 350,
        height: 350,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  Widget _buildGlassEffectBlur() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(color: Colors.transparent),
    );
  }

  Widget _buildMainResponsiveLayout() {
    return Center(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            CustomSnackBar.showSuccess(
              context,
              'Selamat datang, login berhasil!',
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }

          if (state is AuthFailure) {
            CustomSnackBar.showErr(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          return ResponsiveLayout(
            mobile: _buildMobileLayout(state),
            tablet: _buildTabletLayout(state),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(AuthState state) {
    return LoginMobileLayout(
      formKey: _formKey,
      emailController: _emailController,
      passwordController: _passwordController,
      obscurePassword: _obscurePassword,
      onLoginPressed: _login,
      onToggleObscure: _toggleObscurePassword,
      state: state,
    );
  }

  Widget _buildTabletLayout(AuthState state) {
    return LoginTabletLayout(
      formKey: _formKey,
      emailController: _emailController,
      passwordController: _passwordController,
      obscurePassword: _obscurePassword,
      onLoginPressed: _login,
      onToggleObscure: _toggleObscurePassword,
      state: state,
    );
  }

  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }
}
