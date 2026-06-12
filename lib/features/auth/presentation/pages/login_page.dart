import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saji_pos_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:saji_pos_app/injection.dart' as di;
import '../../../../core/components/custom_snackbar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import 'widgets/login_mobile_layout.dart';
import 'widgets/login_tablet_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedCredentials();
    });
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = di.locator<SharedPreferences>();
      final savedEmail = prefs.getString('remember_email');
      final savedPassword = prefs.getString('remember_password');
      final rememberMe = prefs.getBool('remember_me') ?? false;

      debugPrint('=== LOAD CREDENTIALS ===');
      debugPrint('rememberMe: $rememberMe');
      debugPrint('savedEmail: $savedEmail');

      if (rememberMe && savedEmail != null && savedPassword != null) {
        setState(() {
          _emailController.text = savedEmail;
          _passwordController.text = savedPassword;
          _rememberMe = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading credentials: $e');
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = di.locator<SharedPreferences>();
    debugPrint('=== SAVE CREDENTIALS ===');
    debugPrint('_rememberMe state: $_rememberMe');
    if (_rememberMe) {
      debugPrint('Saving email: ${_emailController.text}');
      await prefs.setString('remember_email', _emailController.text.trim());
      await prefs.setString(
        'remember_password',
        _passwordController.text.trim(),
      );
      await prefs.setBool('remember_me', true);
    } else {
      debugPrint('Clearing remembered credentials');
      await prefs.remove('remember_email');
      await prefs.remove('remember_password');
      await prefs.setBool('remember_me', false);
    }
  }

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
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildTopBlurOrb(),
          _buildBottomBlurOrb(),
          _buildMainResponsiveLayout(),
        ],
      ),
    );
  }

  Widget _buildTopBlurOrb() {
    return Positioned(
      top: -150,
      right: -100,
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent.withValues(alpha: 0.05),
        ),
      ),
    );
  }

  Widget _buildBottomBlurOrb() {
    return Positioned(
      bottom: -150,
      left: -100,
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent.withValues(alpha: 0.05),
        ),
      ),
    );
  }

  Widget _buildMainResponsiveLayout() {
    return Center(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthAuthenticated) {
            await _saveCredentials();
            if (!context.mounted) return;
            CustomSnackBar.showSuccess(
              context,
              'Selamat datang, login berhasil!',
            );
            context.go('/');
          }

          if (state is AuthFailure) {
            if (!context.mounted) return;
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
      rememberMe: _rememberMe,
      onRememberMeChanged: (value) {
        setState(() {
          _rememberMe = value ?? false;
        });
      },
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
      rememberMe: _rememberMe,
      onRememberMeChanged: (value) {
        setState(() {
          _rememberMe = value ?? false;
        });
      },
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
