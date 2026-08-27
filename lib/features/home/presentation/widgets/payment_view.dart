// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/features/order/domain/entities/order_item_request.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:saji_pos_app/features/order/domain/entities/order_request.dart';
import 'package:saji_pos_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:saji_pos_app/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/constants/app_colors.dart';

class PaymentView extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const PaymentView({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  int _selectedTabIndex = 0;
  String? _snapRedirectUrl;
  int? _currentOrderId;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Kembalikan state pembayaran jika sebelumnya sudah di-generate (berguna untuk mobile & tablet saat back/pindah menu)
    final orderState = context.read<OrderBloc>().state;
    
    // Kembalikan state pembayaran jika sebelumnya sudah di-generate
    if (orderState is OrderSuccess || orderState is OrderStatusChecked) {
      final order = (orderState is OrderSuccess) ? orderState.order : (orderState as OrderStatusChecked).order;
      final snapUrl = order.snapRedirectUrl ?? order.qrImageUrl ?? order.qrString;
      
      if (snapUrl != null && snapUrl.isNotEmpty) {
        _currentOrderId = order.id;
        _snapRedirectUrl = snapUrl;
        if (order.paymentMethod.toUpperCase() == 'QRIS') {
          _selectedTabIndex = 1;
        } else if (order.paymentMethod.toUpperCase() == 'TRANSFER') {
          _selectedTabIndex = 2;
        }
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: const Text(
            'Pembayaran',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Metode Bayar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(
                        0,
                        'Cash',
                        Icons.payments_outlined,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTabButton(
                        1,
                        'QRIS',
                        Icons.qr_code_2_rounded,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTabButton(
                        2,
                        'Transfer',
                        Icons.account_balance_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                if (_selectedTabIndex == 0) _buildCashSection(),
                if (_selectedTabIndex == 1) _buildQrisSection(),
                if (_selectedTabIndex == 2) _buildTransferSection(),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Batalkan',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: BlocConsumer<OrderBloc, OrderState>(
                    listener: (context, state) {
                      if (state is OrderSuccess) {
                        final order = state.order;
                        final snapUrl = order.snapRedirectUrl ?? order.qrImageUrl ?? order.qrString;
                        _currentOrderId = order.id;

                        if (order.paymentMethod == 'CASH') {
                          widget.onConfirm();
                        } else if (snapUrl != null && snapUrl.isNotEmpty) {
                          debugPrint('\n=============================================');
                          debugPrint('🔗 LINK / QRIS:');
                          debugPrint(snapUrl);
                          debugPrint('=============================================\n');
                          setState(() {
                            _snapRedirectUrl = snapUrl;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Link pembayaran belum tersedia dari server.'),
                            ),
                          );
                        }
                      } else if (state is OrderStatusChecked) {
                        final status = state.order.paymentStatus?.toLowerCase();
                        if (status == 'settlement' ||
                            status == 'paid' ||
                            status == 'success' ||
                            status == 'capture') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Pembayaran berhasil dikonfirmasi!',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          widget.onConfirm();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Status pembayaran saat ini: ${status ?? 'pending'}. Silakan bayar terlebih dahulu.',
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      } else if (state is OrderError) {
                        debugPrint("🔥 ERROR SAAT CHECKOUT: ${state.message}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: AppColors.danger,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is OrderLoading;
                      return ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (_selectedTabIndex == 1 ||
                                    _selectedTabIndex == 2) {
                                  if (_snapRedirectUrl != null &&
                                      _currentOrderId != null) {
                                    context.read<OrderBloc>().add(
                                      CheckOrderStatusEvent(_currentOrderId!),
                                    );
                                  } else {
                                    _submitOrder(context);
                                  }
                                } else {
                                  _submitOrder(context);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              (_snapRedirectUrl != null &&
                                  (_selectedTabIndex == 1 ||
                                      _selectedTabIndex == 2))
                              ? Colors.green
                              : AppColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                (_selectedTabIndex == 1 ||
                                        _selectedTabIndex == 2)
                                    ? (_snapRedirectUrl != null
                                          ? 'Cek Status Pembayaran'
                                          : 'Konfirmasi')
                                    : 'Konfirmasi',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(int index, String title, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        if (_selectedTabIndex != index) {
          setState(() {
            _selectedTabIndex = index;
            _snapRedirectUrl = null;
            _currentOrderId = null;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrisSection() {
    return Center(
      child: Column(
        children: [
          InkWell(
            onTap: _snapRedirectUrl != null && _snapRedirectUrl!.isNotEmpty
                ? () async {
                    final uri = Uri.parse(_snapRedirectUrl!);
                    try {
                      final launched = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!launched) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Browsernya gak mau kebuka nih di perangkat ini.',
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: Tidak dapat membuka link'),
                        ),
                      );
                    }
                  }
                : null,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 200,
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _snapRedirectUrl != null
                      ? AppColors.accent
                      : AppColors.border,
                  width: _snapRedirectUrl != null ? 2 : 1,
                ),
              ),
              child: _snapRedirectUrl != null && _snapRedirectUrl!.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.open_in_browser_rounded,
                          size: 80,
                          color: AppColors.accent,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Buka Link\nPembayaran',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : Icon(
                      Icons.qr_code_2_rounded,
                      size: 140,
                      color: AppColors.accent.withValues(alpha: 0.7),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _snapRedirectUrl != null && _snapRedirectUrl!.isNotEmpty
                ? 'Klik kotak di atas untuk membayar, lalu klik "Cek Status Pembayaran" di bawah'
                : 'Pilih "Konfirmasi" untuk checkout',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Panduan Pembayaran QRIS:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                _buildInstructionRow('1', 'Pastikan pesanan sudah sesuai, lalu klik tombol "Konfirmasi" di bawah.'),
                _buildInstructionRow('2', 'Klik kotak QRIS di atas untuk membuka link pembayaran dari Midtrans.'),
                _buildInstructionRow('3', 'Scan QR Code yang muncul menggunakan aplikasi e-Wallet atau m-Banking Anda.'),
                _buildInstructionRow('4', 'Setelah berhasil bayar, kembali ke aplikasi ini dan klik "Cek Status Pembayaran".'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferSection() {
    return Center(
      child: Column(
        children: [
          InkWell(
            onTap: _snapRedirectUrl != null && _snapRedirectUrl!.isNotEmpty
                ? () async {
                    final uri = Uri.parse(_snapRedirectUrl!);
                    try {
                      final launched = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!launched) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Browsernya gak mau kebuka nih di perangkat ini.',
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: Tidak dapat membuka link'),
                        ),
                      );
                    }
                  }
                : null,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 200,
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _snapRedirectUrl != null
                      ? AppColors.accent
                      : AppColors.border,
                  width: _snapRedirectUrl != null ? 2 : 1,
                ),
              ),
              child: _snapRedirectUrl != null && _snapRedirectUrl!.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.open_in_browser_rounded,
                          size: 80,
                          color: AppColors.accent,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Buka Link\nTransfer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : Icon(
                      Icons.account_balance_rounded,
                      size: 140,
                      color: AppColors.accent.withValues(alpha: 0.7),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _snapRedirectUrl != null && _snapRedirectUrl!.isNotEmpty
                ? 'Klik kotak di atas untuk melihat pilihan Bank Transfer, lalu klik "Cek Status Pembayaran" di bawah'
                : 'Pilih "Konfirmasi" untuk checkout via Transfer',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Panduan Bank Transfer / Virtual Account:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                _buildInstructionRow('1', 'Pastikan pesanan sudah sesuai, lalu klik tombol "Konfirmasi" di bawah.'),
                _buildInstructionRow('2', 'Klik kotak Transfer di atas untuk membuka link pembayaran.'),
                _buildInstructionRow('3', 'Pilih bank tujuan, lalu salin nomor Virtual Account yang muncul.'),
                _buildInstructionRow('4', 'Lakukan transfer via ATM, Internet Banking, atau m-Banking.'),
                _buildInstructionRow('5', 'Setelah berhasil bayar, kembali ke aplikasi ini dan klik "Cek Status Pembayaran".'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionRow(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nominal Uang',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Rp 0',
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Pilihan Cepat',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildCashShortcutButton('Uang Pas', isHighlight: true),
            _buildCashShortcutButton('Rp 50.000'),
            _buildCashShortcutButton('Rp 100.000'),
            _buildCashShortcutButton('Rp 150.000'),
          ],
        ),
      ],
    );
  }

  Widget _buildCashShortcutButton(String label, {bool isHighlight = false}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isHighlight ? AppColors.accent : AppColors.accentLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isHighlight ? AppColors.white : AppColors.accent,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _submitOrder(BuildContext context) {
    final cartState = context.read<CartCubit>().state;
    final orderItems = cartState.items.map((item) {
      return OrderItemRequest(
        productId: item.product.id,
        quantity: item.quantity,
        price: item.product.price.toDouble(),
        note: item.note,
      );
    }).toList();

    int cashierId = 1;
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      if (authState.authData.user.id != 0) {
        cashierId = authState.authData.user.id;
      }
    }

    final request = OrderRequest(
      cashierId: cashierId,
      transactionTime: DateTime.now().toIso8601String(),
      subTotal: cartState.subTotal,
      discountId: cartState.activeDiscount?.id,
      discountAmount: cartState.diskon,
      shippingCost: cartState.shippingFeeAmount,
      serviceCharge: cartState.serviceFeeAmount,
      tax: cartState.pajak,
      total: cartState.total, // Ensure we send the correct total after discount
      paymentMethod: _selectedTabIndex == 0
          ? 'CASH'
          : _selectedTabIndex == 1
          ? 'QRIS'
          : 'transfer',
      orderItems: orderItems,
    );
    context.read<OrderBloc>().add(SubmitOrderEvent(request));
  }
}
