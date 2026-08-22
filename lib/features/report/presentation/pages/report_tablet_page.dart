import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/report_summary.dart';

import '../widgets/report_widgets.dart';

class ReportTabletPage extends StatelessWidget {
  final ReportSummary summary;

  const ReportTabletPage({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return _ReportTabletPortrait(summary: summary);
        }
        return _ReportTabletLandscape(summary: summary);
      },
    );
  }
}

class _ReportTabletPortrait extends StatelessWidget {
  final ReportSummary summary;
  
  const _ReportTabletPortrait({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ringkasan Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text(DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now()), style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: _TabletSharedContent(summary: summary, isLandscape: false),
        ),
      ),
    );
  }
}

class _ReportTabletLandscape extends StatelessWidget {
  final ReportSummary summary;
  
  const _ReportTabletLandscape({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ringkasan Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Text(DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now()), style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _TabletSharedContent(summary: summary, isLandscape: true),
      ),
    );
  }
}

class _TabletSharedContent extends StatelessWidget {
  final ReportSummary summary;
  final bool isLandscape;
  
  const _TabletSharedContent({required this.summary, required this.isLandscape});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
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

    if (!isLandscape) {
       return ListView(
         padding: const EdgeInsets.all(24.0),
         shrinkWrap: true,
         children: [
            Row(
              children: [
                Expanded(child: SummaryCard(title: 'Total Omzet Bersih', value: currencyFormat.format(totalOmzet), icon: Icons.account_balance_wallet, valueColor: AppColors.primary, iconColor: AppColors.info, iconBgColor: AppColors.infoLight, padding: 24, iconSize: 32, titleFontSize: 16, valueFontSize: 28)),
                const SizedBox(width: 16),
                Expanded(child: SummaryCard(title: 'Total Transaksi', value: '$totalTransaksi', icon: Icons.shopping_bag, valueColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimary, iconColor: AppColors.success, iconBgColor: AppColors.successLight, padding: 24, iconSize: 32, titleFontSize: 16, valueFontSize: 28)),
              ],
            ),
            const SizedBox(height: 16),
            PaymentCard(
              totalOmzet: totalOmzet, cashAmount: cashAmount, cashTrx: cashTrx, qrisAmount: qrisAmount, qrisTrx: qrisTrx, transferAmount: transferAmount, transferTrx: transferTrx, currencyFormat: currencyFormat, isHorizontal: false, padding: 24,
            ),
            const SizedBox(height: 16),
            DiscountCard(diskonTerpakai: diskonTerpakai, currencyFormat: currencyFormat, padding: 24),
            const SizedBox(height: 16),
            CollapsibleAdditionalInfo(summary: summary, pajakTerkumpul: pajakTerkumpul, currencyFormat: currencyFormat, fontSize: 16),
         ],
       );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: SummaryCard(title: 'Total Omzet Bersih', value: currencyFormat.format(totalOmzet), icon: Icons.account_balance_wallet, valueColor: AppColors.primary, iconColor: AppColors.info, iconBgColor: AppColors.infoLight, padding: 24, iconSize: 32, titleFontSize: 16, valueFontSize: 28)),
            const SizedBox(width: 24),
            Expanded(child: SummaryCard(title: 'Total Transaksi', value: '$totalTransaksi', icon: Icons.shopping_bag, valueColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimary, iconColor: AppColors.success, iconBgColor: AppColors.successLight, padding: 24, iconSize: 32, titleFontSize: 16, valueFontSize: 28)),
            const SizedBox(width: 24),
            Expanded(child: DiscountCard(diskonTerpakai: diskonTerpakai, currencyFormat: currencyFormat, padding: 24)),
          ],
        ),
        const SizedBox(height: 24),
        
        PaymentCard(
          totalOmzet: totalOmzet, cashAmount: cashAmount, cashTrx: cashTrx, qrisAmount: qrisAmount, qrisTrx: qrisTrx, transferAmount: transferAmount, transferTrx: transferTrx, currencyFormat: currencyFormat, isHorizontal: true, padding: 24,
        ),
        const SizedBox(height: 24),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Menu Terlaris', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    if (summary.topMenus.isEmpty)
                      const Text('Belum ada pesanan hari ini', style: TextStyle(color: AppColors.textSecondary)),
                    ...summary.topMenus.asMap().entries.map((entry) {
                      return TopMenuItem(rank: entry.key + 1, name: entry.value.name, qty: entry.value.qty, fontSize: 16);
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pajak (PPN) Terkumpul', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(currencyFormat.format(pajakTerkumpul), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 200,
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Grafik Performa Penjualan (Mini)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(12)),
                            child: const Center(child: Icon(Icons.bar_chart, size: 64, color: AppColors.border)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
