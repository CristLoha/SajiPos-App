import 'package:equatable/equatable.dart';
import '../../domain/entities/report_summary.dart';
import '../../../order/data/models/order_model.dart';

class ReportSummaryModel extends Equatable {
  final double totalOmzet;
  final int totalTransactions;
  final double discountAmount;
  final double taxAmount;
  final Map<String, dynamic> cash;
  final Map<String, dynamic> qris;
  final Map<String, dynamic> transfer;
  final List<Map<String, dynamic>> topMenus;

  const ReportSummaryModel({
    required this.totalOmzet,
    required this.totalTransactions,
    required this.discountAmount,
    required this.taxAmount,
    required this.cash,
    required this.qris,
    required this.transfer,
    required this.topMenus,
  });

  factory ReportSummaryModel.fromOrders(List<OrderModel> orders) {
    double omzet = 0;
    int transactions = orders.length;
    double discount = 0;
    double tax = 0;

    double cashAmount = 0;
    int cashCount = 0;
    double qrisAmount = 0;
    int qrisCount = 0;
    double transferAmount = 0;
    int transferCount = 0;

    Map<String, int> menuCounts = {};

    for (var order in orders) {
      omzet += order.total;
      discount += order.discountAmount;
      tax += order.tax;

      String method = order.paymentMethod.toLowerCase();
      if (method == 'cash') {
        cashAmount += order.total;
        cashCount++;
      } else if (method == 'qris') {
        qrisAmount += order.total;
        qrisCount++;
      } else if (method == 'transfer') {
        transferAmount += order.total;
        transferCount++;
      }

      for (var item in order.orderItems) {
        String name = item.productName ?? 'Item ${item.productId}';
        menuCounts[name] = (menuCounts[name] ?? 0) + item.quantity;
      }
    }

    var sortedMenus = menuCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<Map<String, dynamic>> topMenusData = sortedMenus
        .take(5)
        .map((e) => {'name': e.key, 'qty': e.value})
        .toList();

    return ReportSummaryModel(
      totalOmzet: omzet,
      totalTransactions: transactions,
      discountAmount: discount,
      taxAmount: tax,
      cash: {'amount': cashAmount, 'count': cashCount},
      qris: {'amount': qrisAmount, 'count': qrisCount},
      transfer: {'amount': transferAmount, 'count': transferCount},
      topMenus: topMenusData,
    );
  }

  ReportSummary toEntity() {
    return ReportSummary(
      totalOmzet: totalOmzet,
      totalTransactions: totalTransactions,
      discountAmount: discountAmount,
      taxAmount: taxAmount,
      cash: PaymentSummary(
        amount: (cash['amount'] as num).toDouble(),
        count: cash['count'] as int,
      ),
      qris: PaymentSummary(
        amount: (qris['amount'] as num).toDouble(),
        count: qris['count'] as int,
      ),
      transfer: PaymentSummary(
        amount: (transfer['amount'] as num).toDouble(),
        count: transfer['count'] as int,
      ),
      topMenus: topMenus
          .map((e) => TopMenu(name: e['name'] as String, qty: e['qty'] as int))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
    totalOmzet,
    totalTransactions,
    discountAmount,
    taxAmount,
    cash,
    qris,
    transfer,
    topMenus,
  ];
}
