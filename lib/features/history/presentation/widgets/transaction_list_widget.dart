import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import 'package:saji_pos_app/features/history/domain/entities/transaction.dart';
import 'package:saji_pos_app/features/history/presentation/bloc/history_bloc.dart';
import 'package:saji_pos_app/features/order/presentation/bloc/order_bloc.dart';

class TransactionListWidget extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final bool isPending;
  final int? syncingOrderId;

  const TransactionListWidget({
    super.key,
    required this.transactions,
    required this.isPending,
    this.syncingOrderId,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded, size: 80, color: AppColors.border),
            const SizedBox(height: 16),
            Text(
              isPending
                  ? 'Tidak ada pesanan pending'
                  : 'Belum ada riwayat selesai',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HistoryBloc>().add(GetHistoryEvent());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final trx = transactions[index];

          final statusStr = (trx.paymentStatus ?? '').toLowerCase();
          Color statusColor = Colors.grey;
          if (statusStr == 'pending') {
            statusColor = Colors.orange;
          } else if (statusStr == 'success' ||
              statusStr == 'settlement' ||
              statusStr == 'paid') {
            statusColor = Colors.green;
          } else if (statusStr == 'failed' ||
              statusStr == 'expire' ||
              statusStr == 'cancel' ||
              statusStr == 'deny') {
            statusColor = Colors.red;
          }

          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.border),
            ),
            child: InkWell(
              onTap: () {
                if (isPending) {
                  context.read<OrderBloc>().add(CheckOrderStatusEvent(trx.id));
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order #${trx.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            trx.paymentStatus?.toUpperCase() ?? '-',
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      trx.transactionTime,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.payment,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              trx.paymentMethod.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          currencyFormat.format(trx.total),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
