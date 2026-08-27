import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/report_summary.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color valueColor;
  final Color iconColor;
  final Color iconBgColor;
  final double padding;
  final double iconSize;
  final double titleFontSize;
  final double valueFontSize;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.valueColor,
    required this.iconColor,
    required this.iconBgColor,
    this.padding = 16,
    this.iconSize = 24,
    this.titleFontSize = 13,
    this.valueFontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(padding / 2),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(padding > 16 ? 12 : 8),
            ),
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
          SizedBox(height: padding > 16 ? 16 : 12),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: titleFontSize,
            ),
          ),
          SizedBox(height: padding > 16 ? 8 : 4),
          Text(
            value,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class PaymentRow extends StatelessWidget {
  final String name;
  final int trx;
  final double amount;
  final double totalAmount;
  final NumberFormat currencyFormat;
  final Color barColor;
  final double titleFontSize;
  final double valueFontSize;

  const PaymentRow({
    super.key,
    required this.name,
    required this.trx,
    required this.amount,
    required this.totalAmount,
    required this.currencyFormat,
    required this.barColor,
    this.titleFontSize = 14,
    this.valueFontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = totalAmount > 0 ? (amount / totalAmount) : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$name ($trx x)',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: titleFontSize,
              ),
            ),
            Text(
              currencyFormat.format(amount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: valueFontSize,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: AppColors.border,
          color: barColor,
          minHeight: titleFontSize > 14 ? 8 : 6,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class TopMenuItem extends StatelessWidget {
  final int rank;
  final String name;
  final int qty;
  final double fontSize;

  const TopMenuItem({
    super.key,
    required this.rank,
    required this.name,
    required this.qty,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: fontSize > 14 ? 8.0 : 4.0),
      child: Row(
        children: [
          Container(
            width: fontSize > 14 ? 32 : 24,
            height: fontSize > 14 ? 32 : 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(fontSize > 14 ? 16 : 12),
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: fontSize > 14 ? 14 : 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name, style: TextStyle(fontSize: fontSize)),
          ),
          Text(
            '$qty porsi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}

class DiscountCard extends StatelessWidget {
  final double diskonTerpakai;
  final NumberFormat currencyFormat;
  final double padding;

  const DiscountCard({
    super.key,
    required this.diskonTerpakai,
    required this.currencyFormat,
    this.padding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Diskon Terpakai',
            style: TextStyle(
              fontSize: padding > 16 ? 18 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (padding > 16)
            const SizedBox(height: 16)
          else
            const SizedBox(height: 8),
          Text(
            currencyFormat.format(diskonTerpakai),
            style: TextStyle(
              fontSize: padding > 16 ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.warning,
            ),
          ),
          SizedBox(height: padding > 16 ? 8 : 4),
          Text(
            'Total potongan promo hari ini',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: padding > 16 ? 14 : 13,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final double totalOmzet;
  final double cashAmount;
  final int cashTrx;
  final double qrisAmount;
  final int qrisTrx;
  final double transferAmount;
  final int transferTrx;
  final NumberFormat currencyFormat;
  final bool isHorizontal;
  final double padding;

  const PaymentCard({
    super.key,
    required this.totalOmzet,
    required this.cashAmount,
    required this.cashTrx,
    required this.qrisAmount,
    required this.qrisTrx,
    required this.transferAmount,
    required this.transferTrx,
    required this.currencyFormat,
    this.isHorizontal = false,
    this.padding = 16,
  });

  @override
  Widget build(BuildContext context) {
    final double titleFontSize = padding > 16 ? 16 : 14;

    Widget cashContent = Container(
      padding: EdgeInsets.all(padding > 16 ? 16 : 12),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PaymentRow(
            name: 'Cash',
            trx: cashTrx,
            amount: cashAmount,
            totalAmount: totalOmzet,
            currencyFormat: currencyFormat,
            barColor: AppColors.warning,
            titleFontSize: titleFontSize,
            valueFontSize: titleFontSize,
          ),
          SizedBox(height: padding > 16 ? 12 : 8),
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warning,
                size: padding > 16 ? 20 : 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pastikan kas fisik laci sesuai dengan ${currencyFormat.format(cashAmount)} ini.',
                  style: TextStyle(
                    color: AppColors.warningText,
                    fontSize: padding > 16 ? 13 : 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    Widget qrisContent = PaymentRow(
      name: 'QRIS',
      trx: qrisTrx,
      amount: qrisAmount,
      totalAmount: totalOmzet,
      currencyFormat: currencyFormat,
      barColor: AppColors.info,
      titleFontSize: titleFontSize,
      valueFontSize: titleFontSize,
    );
    Widget transferContent = PaymentRow(
      name: 'Transfer',
      trx: transferTrx,
      amount: transferAmount,
      totalAmount: totalOmzet,
      currencyFormat: currencyFormat,
      barColor: AppColors.purple,
      titleFontSize: titleFontSize,
      valueFontSize: titleFontSize,
    );

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rincian Kas & Pembayaran',
            style: TextStyle(
              fontSize: padding > 16 ? 20 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: padding > 16 ? 24 : 16),
          if (isHorizontal)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: cashContent),
                const SizedBox(width: 24),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      qrisContent,
                      const SizedBox(height: 24),
                      transferContent,
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                cashContent,
                SizedBox(height: padding > 16 ? 24 : 16),
                qrisContent,
                SizedBox(height: padding > 16 ? 24 : 12),
                transferContent,
              ],
            ),
        ],
      ),
    );
  }
}

class CollapsibleAdditionalInfo extends StatelessWidget {
  final ReportSummary summary;
  final double pajakTerkumpul;
  final NumberFormat currencyFormat;
  final double fontSize;

  const CollapsibleAdditionalInfo({
    super.key,
    required this.summary,
    required this.pajakTerkumpul,
    required this.currencyFormat,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: false,
        title: const Text(
          'Info Tambahan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Menu Terlaris',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize > 14 ? 16 : 14,
              ),
            ),
          ),
          SizedBox(height: fontSize > 14 ? 12 : 8),
          if (summary.topMenus.isEmpty)
            const Text(
              'Belum ada pesanan hari ini',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ...summary.topMenus.asMap().entries.map((entry) {
            return TopMenuItem(
              rank: entry.key + 1,
              name: entry.value.name,
              qty: entry.value.qty,
              fontSize: fontSize,
            );
          }),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pajak (PPN) Terkumpul',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                currencyFormat.format(pajakTerkumpul),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Grafik Performa Penjualan (Mini)',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
