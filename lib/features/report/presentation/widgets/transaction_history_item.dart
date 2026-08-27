import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';

class TransactionHistoryItem extends StatelessWidget {
  final String id;
  final String time;
  final String customerName;
  final String paymentMethod;
  final int totalItems;
  final double grandTotal;
  final String status;
  final EdgeInsetsGeometry padding;
  final double titleFontSize;
  final double iconSize;

  const TransactionHistoryItem({
    super.key,
    required this.id,
    required this.time,
    required this.customerName,
    required this.paymentMethod,
    required this.totalItems,
    required this.grandTotal,
    required this.status,
    this.padding = EdgeInsets.zero,
    this.titleFontSize = 13,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Convert status to readable text and color
    String statusText = 'Selesai';
    Color statusColor = AppColors.success;

    if (status.toLowerCase() == 'pending') {
      statusText = 'Tertunda';
      statusColor = Colors.orange;
    } else if (status.toLowerCase() == 'cancelled' ||
        status.toLowerCase() == 'failed') {
      statusText = 'Batal';
      statusColor = AppColors.danger;
    }

    return Padding(
      padding: padding,
      child: ListTile(
        contentPadding: padding == EdgeInsets.zero ? null : EdgeInsets.zero,
        leading: Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(iconSize > 40 ? 12 : 8),
          ),
          child: const Icon(Icons.receipt_long, color: AppColors.textSecondary),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                id,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: iconSize > 40 ? 4.0 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$time • $paymentMethod • $totalItems Item',
                style: TextStyle(fontSize: titleFontSize - 1),
              ),
              if (customerName.isNotEmpty)
                Text(
                  'Pelanggan: $customerName',
                  style: TextStyle(
                    fontSize: titleFontSize - 2,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(grandTotal),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: titleFontSize + 1,
                color: AppColors.textPrimary,
              ),
            ),
            if (iconSize > 40) const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: titleFontSize - 3,
                  fontWeight: iconSize > 40
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
