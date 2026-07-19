import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';

class PromoMobilePage extends StatefulWidget {
  const PromoMobilePage({super.key});

  @override
  State<PromoMobilePage> createState() => _PromoMobilePageState();
}

class _PromoMobilePageState extends State<PromoMobilePage> {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  // Dummy data
  final List<Map<String, dynamic>> _dummyPromos = [
    {
      'name': 'Diskon Akhir Pekan',
      'code': 'WEEKEND20',
      'type': 'percent',
      'value': 20,
      'status': 'active', // active, upcoming, expired, expiring_soon
      'start_date': '2026-07-16',
      'end_date': '2026-07-18',
      'terms': 'Min. transaksi Rp 100.000',
    },
    {
      'name': 'HUT SajiPOS',
      'code': 'SAJI10',
      'type': 'percent',
      'value': 10,
      'status': 'active', // changed from upcoming since we remove Akan Datang
      'start_date': '2026-08-01',
      'end_date': '2026-08-05',
      'terms': 'Semua menu',
    },
    {
      'name': 'Lebaran Sale',
      'code': 'LEBARAN',
      'type': 'nominal',
      'value': 20000,
      'status': 'expired',
      'start_date': '2026-04-01',
      'end_date': '2026-04-10',
      'terms': 'Tanpa min. transaksi',
    },
  ];

  List<Map<String, dynamic>> get _filteredPromos {
    String search = _searchController.text.toLowerCase();
    return _dummyPromos.where((promo) {
      bool matchesSearch =
          promo['name'].toLowerCase().contains(search) ||
          promo['code'].toLowerCase().contains(search);

      bool matchesTab = false;
      if (_selectedTabIndex == 0) {
        matchesTab =
            promo['status'] == 'active' || promo['status'] == 'expiring_soon';
      } else if (_selectedTabIndex == 1) {
        matchesTab = promo['status'] == 'expired';
      }

      return matchesSearch && matchesTab;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Promo & Diskon'),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Tampilkan filter bottom sheet
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Cari nama atau kode promo...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Segmented Control / Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildTab(0, 'Berlaku Sekarang'),
                const SizedBox(width: 8),
                _buildTab(1, 'Kedaluwarsa'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Promo List
          Expanded(
            child: _filteredPromos.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: _filteredPromos.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _buildPromoCard(_filteredPromos[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? null : Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoCard(Map<String, dynamic> promo) {
    Color statusColor;
    String statusText;
    switch (promo['status']) {
      case 'active':
        statusColor = AppColors.success;
        statusText = 'Aktif';
        break;
      case 'expiring_soon':
        statusColor = Colors.orange;
        statusText = 'Segera Berakhir';
        break;
      case 'upcoming':
        statusColor = AppColors.grey;
        statusText = 'Akan Datang';
        break;
      case 'expired':
      default:
        statusColor = AppColors.danger;
        statusText = 'Kedaluwarsa';
        break;
    }

    String discountValueText = promo['type'] == 'percent'
        ? '${promo['value']}%'
        : 'Rp ${promo['value'].toString()}';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  promo['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Code
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: promo['code']));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kode promo disalin!')),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  style: BorderStyle.solid,
                  color: AppColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    promo['code'],
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.copy,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.local_offer_outlined,
                color: AppColors.accent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Diskon $discountValueText',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  promo['terms'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Berlaku: ${promo['start_date']} s.d ${promo['end_date']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_selectedTabIndex == 0)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Promo diterapkan ke pesanan'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Gunakan di Transaksi'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.discount_outlined,
            size: 64,
            color: AppColors.border,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada Promo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          if (_selectedTabIndex == 0)
            const Text(
              'Tidak ada promo aktif saat ini.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }
}
