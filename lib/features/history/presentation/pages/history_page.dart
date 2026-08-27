import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import '../bloc/history_bloc.dart';
import '../../domain/entities/transaction.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

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
      appBar: AppBar(
        title: const Text('Pesanan & Riwayat', style: TextStyle(fontWeight: FontWeight.bold)),
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
      ),
      body: BlocConsumer<HistoryBloc, HistoryState>(
        listener: (context, state) {
          if (state is HistorySyncSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is HistorySyncError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.danger),
            );
          }
        },
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          } else if (state is HistoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
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

          if (transactions.isNotEmpty || state is HistoryLoaded || state is HistorySyncSuccess || state is HistorySyncError || state is HistorySyncing) {
            final pendingTransactions = transactions
                .where((t) => t.paymentStatus?.toLowerCase() == 'pending')
                .toList();
            final completedTransactions = transactions
                .where((t) => t.paymentStatus?.toLowerCase() != 'pending')
                .toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionList(pendingTransactions, isPending: true, syncingOrderId: syncingOrderId),
                _buildTransactionList(completedTransactions, isPending: false, syncingOrderId: syncingOrderId),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionEntity> transactions, {required bool isPending, int? syncingOrderId}) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded, size: 80, color: AppColors.border),
            const SizedBox(height: 16),
            Text(
              isPending ? 'Tidak ada pesanan pending' : 'Belum ada riwayat selesai',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
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
          final isSyncing = syncingOrderId == trx.id;
          
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.border),
            ),
            child: InkWell(
              onTap: isSyncing ? null : () {
                if (isPending) {
                  context.read<HistoryBloc>().add(SyncMidtransEvent(trx.id));
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
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isPending ? Colors.orange.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            trx.paymentStatus?.toUpperCase() ?? '-',
                            style: TextStyle(
                              color: isPending ? Colors.orange : Colors.green,
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
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.payment, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              trx.paymentMethod.toUpperCase(),
                              style: const TextStyle(color: AppColors.textSecondary),
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
                    if (isPending) ...[
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isSyncing ? Icons.sync : Icons.refresh, size: 16, color: AppColors.accent),
                          const SizedBox(width: 8),
                          Text(
                            isSyncing ? 'Mengecek status...' : 'Tekan untuk cek status pembayaran',
                            style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
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
