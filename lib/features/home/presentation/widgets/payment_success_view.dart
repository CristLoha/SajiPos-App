import 'dart:ui' as ui;
import 'package:saji_pos_app/features/store_profile/presentation/bloc/store_profile_bloc.dart';
import 'package:saji_pos_app/features/store_profile/presentation/bloc/store_profile_event.dart';
import 'package:saji_pos_app/features/store_profile/presentation/bloc/store_profile_state.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/components/receipt_clipper.dart';
import 'package:saji_pos_app/features/order/presentation/bloc/order_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/api_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentSuccessView extends StatefulWidget {
  final VoidCallback onBackToHome;

  const PaymentSuccessView({super.key, required this.onBackToHome});

  @override
  State<PaymentSuccessView> createState() => _PaymentSuccessViewState();
}

class _PaymentSuccessViewState extends State<PaymentSuccessView> {
  final GlobalKey _boundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreProfileBloc>().add(FetchStoreProfileEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final now = DateTime.now();
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          final items = cartState.items;
          final subTotal = cartState.subTotal;

          return Column(
            children: [
              // Header UI (Not part of receipt)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Struk Pembayaran',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const Divider(height: 1),

              // Scrollable receipt area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: RepaintBoundary(
                        key: _boundaryKey,
                        child: ClipPath(
                          clipper: ReceiptClipper(),
                          child: Container(
                            color: Colors.white, // ALWAYS WHITE
                            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                            child: BlocBuilder<StoreProfileBloc, StoreProfileState>(
                              builder: (context, storeProfileState) {
                                String storeName = 'SAJI POS';
                                String storeAddress =
                                    'Alamat Toko Belum Diatur';
                                String storePhone = '-';
                                bool showAddress = true;
                                bool showPhone = true;

                                if (storeProfileState is StoreProfileLoaded) {
                                  storeName =
                                      storeProfileState.storeProfile.name;
                                  if (storeProfileState
                                      .storeProfile
                                      .address
                                      .isNotEmpty) {
                                    storeAddress =
                                        storeProfileState.storeProfile.address;
                                  }
                                  if (storeProfileState
                                      .storeProfile
                                      .phone
                                      .isNotEmpty) {
                                    storePhone =
                                        storeProfileState.storeProfile.phone;
                                  }
                                  showAddress = storeProfileState
                                      .storeProfile
                                      .showAddressOnReceipt;
                                  showPhone = storeProfileState
                                      .storeProfile
                                      .showPhoneOnReceipt;
                                }

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // STORE HEADER
                                    Text(
                                      storeName,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Courier',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    if (showAddress) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        storeAddress,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Courier',
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                    if (showPhone) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        'Telp: $storePhone',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Courier',
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 16),
                                    _buildDashedDivider(),
                                    const SizedBox(height: 16),

                                    // Status
                                    const Text(
                                      'LUNAS',
                                      style: TextStyle(
                                        fontFamily: 'Courier',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      dateFormat.format(now),
                                      style: const TextStyle(
                                        fontFamily: 'Courier',
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDashedDivider(),
                                    const SizedBox(height: 16),

                                    // Item list
                                    ...items.map(
                                      (item) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.product.name,
                                              style: const TextStyle(
                                                fontFamily: 'Courier',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${item.quantity}x @ ${formatCurrency.format(item.product.price)}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Courier',
                                                    color: Colors.black87,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  formatCurrency.format(
                                                    item.totalPrice,
                                                  ),
                                                  style: const TextStyle(
                                                    fontFamily: 'Courier',
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    _buildDashedDivider(),
                                    const SizedBox(height: 12),

                                    // Summary rows
                                    _buildReceiptRow(
                                      'Subtotal',
                                      formatCurrency.format(subTotal),
                                    ),
                                    if (cartState.shippingFeeAmount > 0) ...[
                                      const SizedBox(height: 6),
                                      _buildReceiptRow(
                                        'Ongkos Kirim',
                                        '+ ${formatCurrency.format(cartState.shippingFeeAmount)}',
                                      ),
                                    ],
                                    if (cartState.serviceFeeAmount > 0) ...[
                                      const SizedBox(height: 6),
                                      _buildReceiptRow(
                                        'Biaya Layanan',
                                        '+ ${formatCurrency.format(cartState.serviceFeeAmount)}',
                                      ),
                                    ],
                                    if (cartState.taxPercentage > 0) ...[
                                      const SizedBox(height: 6),
                                      _buildReceiptRow(
                                        'Pajak (${cartState.taxPercentage.toStringAsFixed(cartState.taxPercentage.truncateToDouble() == cartState.taxPercentage ? 0 : 1)}%)',
                                        '+ ${formatCurrency.format(cartState.pajak)}',
                                      ),
                                    ],
                                    if (cartState.diskon > 0) ...[
                                      const SizedBox(height: 6),
                                      _buildReceiptRow(
                                        'Diskon',
                                        '- ${formatCurrency.format(cartState.diskon)}',
                                      ),
                                    ],
                                    const SizedBox(height: 12),
                                    _buildDashedDivider(),
                                    const SizedBox(height: 12),

                                    // Total
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'TOTAL',
                                          style: TextStyle(
                                            fontFamily: 'Courier',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          formatCurrency.format(
                                            cartState.total,
                                          ),
                                          style: const TextStyle(
                                            fontFamily: 'Courier',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Payment method
                                    BlocBuilder<OrderBloc, OrderState>(
                                      builder: (context, orderState) {
                                        String paymentMethod =
                                            'Tidak diketahui';
                                        String? receiptToken;

                                        if (orderState is OrderSuccess) {
                                          paymentMethod =
                                              orderState.order.paymentMethod;
                                          receiptToken =
                                              orderState.order.receiptToken;
                                        } else if (orderState
                                            is OrderStatusChecked) {
                                          paymentMethod =
                                              orderState.order.paymentMethod;
                                          receiptToken =
                                              orderState.order.receiptToken;
                                        }

                                        if (paymentMethod.toLowerCase() ==
                                            'qris') {
                                          paymentMethod = 'QRIS';
                                        } else if (paymentMethod
                                                .toLowerCase() ==
                                            'transfer') {
                                          paymentMethod = 'Transfer Bank';
                                        } else if (paymentMethod
                                                .toLowerCase() ==
                                            'cash') {
                                          paymentMethod = 'Tunai / Cash';
                                        }

                                        return Column(
                                          children: [
                                            _buildReceiptRow(
                                              'METODE BAYAR',
                                              paymentMethod.toUpperCase(),
                                            ),
                                            const SizedBox(height: 24),
                                            _buildDashedDivider(),
                                            const SizedBox(height: 16),

                                            // QR Code
                                            if (receiptToken != null) ...[
                                              QrImageView(
                                                data:
                                                    '${ApiConstants.baseUrl.replaceAll('/api', '')}/struk/$receiptToken',
                                                version: QrVersions.auto,
                                                size: 120.0,
                                                backgroundColor: Colors.white,
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                'Scan QR untuk struk digital',
                                                style: TextStyle(
                                                  fontFamily: 'Courier',
                                                  fontSize: 10,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ] else ...[
                                              const Text(
                                                '(Struk online menunggu sinkronisasi)',
                                                style: TextStyle(
                                                  fontFamily: 'Courier',
                                                  fontSize: 10,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ],
                                        );
                                      },
                                    ),

                                    const SizedBox(height: 24),
                                    const Text(
                                      'Terima kasih telah berbelanja!',
                                      style: TextStyle(
                                        fontFamily: 'Courier',
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Action Buttons (Outside of Receipt)
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                padding: const EdgeInsets.all(24.0),
                child: BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, orderState) {
                    String? receiptToken;
                    if (orderState is OrderSuccess) {
                      receiptToken = orderState.order.receiptToken;
                    } else if (orderState is OrderStatusChecked) {
                      receiptToken = orderState.order.receiptToken;
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (receiptToken != null) ...[
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final url = Uri.parse(
                                  '${ApiConstants.baseUrl.replaceAll('/api', '')}/struk/$receiptToken',
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Link struknya gak bisa dibuka nih.',
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.open_in_browser_rounded,
                                size: 20,
                              ),
                              label: const Text('Bagikan Struk Digital (URL)'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(
                                  color: AppColors.primary,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: () => _captureAndSavePng(context),
                            icon: const Icon(
                              Icons.download_rounded,
                              color: AppColors.white,
                            ),
                            label: const Text(
                              'Simpan Gambar Struk',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: widget.onBackToHome,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Transaksi Baru',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Courier',
            color: Colors.black87,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Courier',
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildDashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 6.0;
        final dashSpace = 4.0;
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace))
            .floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.black38),
              ),
            );
          }),
        );
      },
    );
  }

  Future<void> _captureAndSavePng(BuildContext context) async {
    try {
      final boundary =
          _boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes != null) {
        await Gal.putImageBytes(
          pngBytes,
          name: 'struk_${DateTime.now().millisecondsSinceEpoch}.png',
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Struk berhasil disimpan ke galeri!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Struk gagal disimpan nih: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
