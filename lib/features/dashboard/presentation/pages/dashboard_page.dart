import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:saji_pos_app/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../widgets/dashboard_mobile_layout.dart';
import '../widgets/dashboard_tablet_layout.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  void _onItemSelected(int index) {
    if (index == 4) {
      _showLogoutDialog();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('login');
        }
      },
      child: ResponsiveLayout(
        mobile: DashboardMobileLayout(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemSelected,
        ),
        tablet: DashboardTabletLayout(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemSelected,
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Keluar Aplikasi'),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun kasir ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<AuthBloc>().add(AuthLogoutProcess());
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}
