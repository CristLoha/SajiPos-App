import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ReportTabletPage extends StatefulWidget {
  const ReportTabletPage({super.key});

  @override
  State<ReportTabletPage> createState() => _ReportTabletPageState();
}

class _ReportTabletPageState extends State<ReportTabletPage> {
  String _selectedFilter = 'Hari Ini';
  final List<String> _filters = [
    'Hari Ini',
    '7 Hari',
    'Bulan Ini',
    'Tahun Ini',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row (Title)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Laporan Penjualan',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
              ),

              // Filter Tabs (Style like Category Tabs / Promo Tabs)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      bool isSelected = _selectedFilter == filter;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedFilter = filter);
                          if (filter == 'Custom') {
                            _showCustomDateBottomSheet();
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? null
                                : Border.all(color: AppColors.border),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.accent.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Kartu Ringkasan (Grid 2x2 di portrait / mobile, 4 kolom di landscape tablet)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Di tablet, anggap landscape bila >= 768 untuk lebih fleksibel (atau 1024)
                    bool isLandscapeTablet = constraints.maxWidth >= 768;

                    if (isLandscapeTablet) {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              'Omzet',
                              'Rp 2.500.000',
                              Icons.account_balance_wallet,
                              AppColors.success,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSummaryCard(
                              'Transaksi',
                              '45',
                              Icons.receipt_long,
                              AppColors.accent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSummaryCard(
                              'Pajak',
                              'Rp 250.000',
                              Icons.request_quote,
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSummaryCard(
                              'Diskon',
                              'Rp 50.000',
                              Icons.local_offer,
                              AppColors.danger,
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                'Omzet',
                                'Rp 2.500.000',
                                Icons.account_balance_wallet,
                                AppColors.success,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSummaryCard(
                                'Transaksi',
                                '45',
                                Icons.receipt_long,
                                AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                'Pajak',
                                'Rp 250.000',
                                Icons.request_quote,
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSummaryCard(
                                'Diskon',
                                'Rp 50.000',
                                Icons.local_offer,
                                AppColors.danger,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Grafik Performa Penjualan (Sederhana)
              _buildSectionHeader('Performa Penjualan'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                height: 200,
                child: Center(
                  child: Text(
                    '[ Area Chart Placeholder ]\nRp 500rb - Rp 1jt\nTap titik untuk tooltip drill-down',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Metode Pembayaran
              _buildSectionHeader('Metode Pembayaran'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildPaymentMethodBar('QRIS', 25, 'Rp 1.500.000'),
                    const SizedBox(height: 12),
                    _buildPaymentMethodBar('Tunai', 15, 'Rp 750.000'),
                    const SizedBox(height: 12),
                    _buildPaymentMethodBar('Transfer Bank', 5, 'Rp 250.000'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5 Menu Terlaris
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '5 Menu Terlaris',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return _buildTopMenuCard(index + 1);
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodBar(String method, int count, String total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(method, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(total, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$count trx',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: count / 45, // dummy max
          backgroundColor: AppColors.background,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          borderRadius: BorderRadius.circular(4),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildTopMenuCard(int rank) {
    return ListTile(
      leading: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: rank <= 3
              ? AppColors.accent.withValues(alpha: 0.1)
              : AppColors.background,
          shape: BoxShape.circle,
        ),
        child: Text(
          '#$rank',
          style: TextStyle(
            color: rank <= 3 ? AppColors.accent : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        'Nasi Goreng Spesial $rank',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: const Text('Makanan Utama', style: TextStyle(fontSize: 12)),
      trailing: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '120 porsi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            'Rp 3.600.000',
            style: TextStyle(
              color: AppColors.success,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomDateBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Tanggal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildDateInput('Dari Tanggal', 'Pilih...')),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateInput('Sampai Tanggal', 'Pilih...'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Terapkan Filter'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateInput(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                placeholder,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
