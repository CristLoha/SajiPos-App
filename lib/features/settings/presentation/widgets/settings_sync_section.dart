import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/sync_cubit.dart';
import '../../../../core/constants/app_colors.dart';
import 'settings_card.dart';
import 'settings_list_tile.dart';
import 'package:saji_pos_app/core/data/database_helper.dart';

class SettingsSyncSection extends StatelessWidget {
  final bool isDark;
  final bool isMobile;

  const SettingsSyncSection({
    super.key,
    required this.isDark,
    required this.isMobile,
  });

  Future<void> _clearDatabase(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bersihkan Database?'),
        content: const Text(
          'Semua data Produk, Kategori, dan Diskon akan dihapus dari penyimpanan lokal. '
          'Transaksi offline yang belum terkirim TIDAK akan dihapus.\n\n'
          'Anda harus melakukan Sinkronisasi ulang setelah ini.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Bersihkan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (!context.mounted) return;
      final db = await DatabaseHelper.instance.database;

      // Hapus data master
      await db.delete('products');
      await db.delete('categories');
      await db.delete('discounts');
      // Hapus transaksi yang SUDAH sinkron
      await db.delete('orders', where: 'isSynced = ?', whereArgs: [1]);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Database berhasil dibersihkan. Silakan sinkronisasi ulang.',
          ),
        ),
      );

      // Otomatis minta sync
      context.read<SyncCubit>().syncData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncCubit, SyncState>(
      builder: (context, state) {
        final children = [
          const Divider(height: 1),
          SettingsListTile(
            icon: Icons.cloud_sync_rounded,
            iconColor: state.isSuccess
                ? AppColors.success
                : AppColors.textSecondary,
            title: 'Sinkronisasi Manual',
            subtitle: state.isLoading
                ? 'Menyinkronkan data...'
                : (state.message ?? 'Tekan tombol untuk sinkronisasi produk'),
            trailing: ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      context.read<SyncCubit>().syncData();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: state.isSuccess
                    ? AppColors.textSecondary.withValues(alpha: 0.5)
                    : AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: const Size(0, 36),
                elevation: 0,
              ),
              child: state.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      state.isSuccess ? 'Tersinkron' : 'Sync Now',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
            ),
          ),
          const Divider(height: 1),
          SettingsListTile(
            icon: Icons.storage_rounded,
            iconColor: AppColors.primary,
            title: 'Database Lokal (Offline)',
            subtitle: 'Penyimpanan SQLite aktif',
            trailing: TextButton(
              onPressed: () => _clearDatabase(context),
              child: const Text('Bersihkan'),
            ),
          ),
        ];

        final headerWidget = Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: state.isSuccess
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.cloud_sync_rounded,
            color: state.isSuccess ? AppColors.success : AppColors.primary,
            size: 20,
          ),
        );

        if (isMobile) {
          return SettingsCard(
            children: [
              Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: headerWidget,
                  title: Text(
                    'Status Sinkronisasi',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    state.isSuccess
                        ? 'Tersinkron'
                        : (state.isLoading
                              ? 'Menyinkronkan...'
                              : 'Belum tersinkron'),
                    style: TextStyle(
                      color: state.isSuccess
                          ? AppColors.success
                          : AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  children: children,
                ),
              ),
            ],
          );
        } else {
          return SettingsCard(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    headerWidget,
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status Sinkronisasi',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            state.isSuccess
                                ? 'Tersinkron'
                                : (state.isLoading
                                      ? 'Menyinkronkan...'
                                      : 'Belum tersinkron'),
                            style: TextStyle(
                              color: state.isSuccess
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ...children,
            ],
          );
        }
      },
    );
  }
}
