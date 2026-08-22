import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/report_summary.dart';

import '../widgets/report_widgets.dart';

class ReportMobilePage extends StatelessWidget {
  final ReportSummary summary;

  const ReportMobilePage({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final double totalOmzet = summary.totalOmzet;
    final int totalTransaksi = summary.totalTransactions;
    final double diskonTerpakai = summary.discountAmount;
    final double pajakTerkumpul = summary.taxAmount;

    final double cashAmount = summary.cash.amount;
    final int cashTrx = summary.cash.count;
    final double qrisAmount = summary.qris.amount;
    final int qrisTrx = summary.qris.count;
    final double transferAmount = summary.transfer.amount;
    final int transferTrx = summary.transfer.count;

    final String todayDate = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(DateTime.now());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Hari Ini',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              todayDate,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 2. Kartu Omzet & Transaksi
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total Omzet Bersih',
                    value: currencyFormat.format(totalOmzet),
                    icon: Icons.account_balance_wallet,
                    valueColor: AppColors.primary,
                    iconColor: AppColors.info,
                    iconBgColor: AppColors.infoLight,
                    padding: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: 'Total Transaksi',
                    value: '$totalTransaksi',
                    icon: Icons.shopping_bag,
                    valueColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimary,
                    iconColor: AppColors.success,
                    iconBgColor: AppColors.successLight,
                    padding: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. Kartu Metode Pembayaran
            PaymentCard(
              totalOmzet: totalOmzet,
              cashAmount: cashAmount,
              cashTrx: cashTrx,
              qrisAmount: qrisAmount,
              qrisTrx: qrisTrx,
              transferAmount: transferAmount,
              transferTrx: transferTrx,
              currencyFormat: currencyFormat,
              padding: 16,
            ),
            const SizedBox(height: 16),

            // 4. Kartu Diskon Terpakai
            DiscountCard(
              diskonTerpakai: diskonTerpakai,
              currencyFormat: currencyFormat,
              padding: 16,
            ),
            const SizedBox(height: 16),

            // 5. Bagian "Info Tambahan" (Collapsible)
            CollapsibleAdditionalInfo(
              summary: summary,
              pajakTerkumpul: pajakTerkumpul,
              currencyFormat: currencyFormat,
              fontSize: 14,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
