import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import 'package:saji_pos_app/features/history/presentation/bloc/history_bloc.dart';

class HistoryErrorView extends StatelessWidget {
  const HistoryErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.danger,
          ),
          const SizedBox(height: 16),
          const Text(
            'Gagal memuat data riwayat.\nSilakan coba beberapa saat lagi.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<HistoryBloc>().add(GetHistoryEvent()),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
