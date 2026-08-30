import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import 'package:saji_pos_app/features/order/presentation/bloc/order_bloc.dart';
import '../bloc/history_bloc.dart';
import '../../domain/entities/transaction.dart';
import '../widgets/payment_qr_dialog.dart';
import '../widgets/transaction_list_widget.dart';
import '../widgets/history_error_view.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<HistoryBloc>().add(GetHistoryEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Pesanan & Riwayat',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      bottom: TabBar(
        controller: _tabController,
        labelColor: AppColors.accent,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.accent,
        tabs: const [
          Tab(text: 'Pending'),
          Tab(text: 'Selesai'),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HistoryBloc, HistoryState>(
          listener: _onHistoryStateChanged,
        ),
        BlocListener<OrderBloc, OrderState>(
          listener: _onOrderStateChanged,
        ),
      ],
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: _buildHistoryContent,
      ),
    );
  }

  void _onHistoryStateChanged(BuildContext context, HistoryState state) {
    if (state is HistorySyncSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.green,
        ),
      );
    } else if (state is HistorySyncError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  void _onOrderStateChanged(BuildContext context, OrderState state) {
    if (state is OrderLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    } else if (state is OrderStatusChecked) {
      Navigator.of(context).pop(); // dismiss loading
      final order = state.order;

      if (order.qrString != null && order.qrString!.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => PaymentQrDialog(order: order),
        );
      } else if (order.snapRedirectUrl != null &&
          order.snapRedirectUrl!.isNotEmpty) {
        final uri = Uri.parse(order.snapRedirectUrl!);
        canLaunchUrl(uri).then((canLaunch) {
          if (canLaunch) {
            launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tidak dapat membuka link pembayaran'),
                ),
              );
            }
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Detail pembayaran belum tersedia dari server.'),
          ),
        );
      }
    } else if (state is OrderError) {
      Navigator.of(context).pop(); // dismiss loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Widget _buildHistoryContent(BuildContext context, HistoryState state) {
    if (state is HistoryLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    } else if (state is HistoryError) {
      return const HistoryErrorView();
    }

    List<TransactionEntity> transactions = [];
    int? syncingOrderId;

    if (state is HistoryLoaded) {
      transactions = state.transactions;
    } else if (state is HistorySyncing) {
      transactions = state.transactions;
      syncingOrderId = state.syncingOrderId;
    } else if (state is HistorySyncSuccess) {
      transactions = state.transactions;
    } else if (state is HistorySyncError) {
      transactions = state.transactions;
    }

    if (transactions.isNotEmpty ||
        state is HistoryLoaded ||
        state is HistorySyncSuccess ||
        state is HistorySyncError ||
        state is HistorySyncing) {
      final pendingTransactions = transactions
          .where((t) => t.paymentStatus?.toLowerCase() == 'pending')
          .toList();
      final completedTransactions = transactions.where((t) {
        final status = t.paymentStatus?.toLowerCase() ?? '';
        return status != 'pending' &&
            status != 'failed' &&
            status != 'expire' &&
            status != 'cancel' &&
            status != 'deny';
      }).toList();

      return TabBarView(
        controller: _tabController,
        children: [
          TransactionListWidget(
            transactions: pendingTransactions,
            isPending: true,
            syncingOrderId: syncingOrderId,
          ),
          TransactionListWidget(
            transactions: completedTransactions,
            isPending: false,
            syncingOrderId: syncingOrderId,
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
