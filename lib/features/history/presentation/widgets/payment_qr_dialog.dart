import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import 'package:saji_pos_app/features/history/presentation/bloc/history_bloc.dart';
import 'package:saji_pos_app/features/order/domain/entities/order.dart';

class PaymentQrDialog extends StatelessWidget {
  final Order order;

  const PaymentQrDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'QRIS Pembayaran',
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: QrImageView(
              data: order.qrString!,
              version: QrVersions.auto,
              size: 250.0,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Silakan scan QR Code di atas menggunakan aplikasi e-Wallet atau m-Banking Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                context.read<HistoryBloc>().add(
                      SyncMidtransEvent(order.id),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.sync, size: 18),
              label: const Text('Cek Status Pembayaran'),
            ),
          ),
        ],
      ),
    );
  }
}
