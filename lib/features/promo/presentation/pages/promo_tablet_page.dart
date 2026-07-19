import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';

class PromoTabletPage extends StatefulWidget {
  const PromoTabletPage({super.key});

  @override
  State<PromoTabletPage> createState() => _PromoTabletPageState();
}

class _PromoTabletPageState extends State<PromoTabletPage> {
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (Title + Search + Filter)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Promo & Diskon',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 320,
                        height: 48,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Cari nama atau kode promo...',
                            hintStyle: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.textSecondary,
                            ),
                            filled: true,
                            fillColor: AppColors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.filter_list_rounded,
                            color: AppColors.textPrimary,
                          ),
                          onPressed: () {
                            // TODO: Tampilkan filter bottom sheet
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Segmented Control / Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTab(0, 'Berlaku Sekarang'),
                    const SizedBox(width: 12),
                    _buildTab(1, 'Kedaluwarsa'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Promo List
            // Promo List
            // Promo List
            // Promo List
            Expanded(
              child: _filteredPromos.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 24,
                        left: 16,
                        right: 16,
                        top: 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: _filteredPromos.length,
                      itemBuilder: (context, index) {
                        return _buildPromoCard(_filteredPromos[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: AppColors.border),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
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

    String discountValue = promo['type'] == 'percent'
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
        mainAxisSize: MainAxisSize.min, // Tinggi dinamis sesuai konten
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

          // Value
          Row(
            children: [
              const Icon(
                Icons.local_offer_outlined,
                color: AppColors.accent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Diskon $discountValue',
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

          // Terms & Dates
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

          // Action Button
          if (_selectedTabIndex == 0)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Apply to active order
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Promo diterapkan ke pesanan'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
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
          Icon(Icons.discount_outlined, size: 64, color: AppColors.border),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada promo di kategori ini',
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
