import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/core/constants/app_colors.dart';
import 'package:saji_pos_app/features/cost_setting/presentation/bloc/cost_setting_bloc.dart';
import 'package:saji_pos_app/features/cost_setting/domain/entities/cost_setting.dart';

class CostSettingPage extends StatefulWidget {
  final bool isEmbedded;
  const CostSettingPage({super.key, this.isEmbedded = false});

  @override
  State<CostSettingPage> createState() => _CostSettingPageState();
}

class _CostSettingPageState extends State<CostSettingPage> {
  final _taxPercentageController = TextEditingController();
  final _shippingFeeController = TextEditingController();
  final _serviceFeeController = TextEditingController();

  bool _includeShippingInTax = false;
  bool _includeServiceFeeInTax = false;

  @override
  void initState() {
    super.initState();
    context.read<CostSettingBloc>().add(LoadCostSetting());
  }

  @override
  void dispose() {
    _taxPercentageController.dispose();
    _shippingFeeController.dispose();
    _serviceFeeController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final taxPercentage = double.tryParse(_taxPercentageController.text) ?? 0.0;
    final shippingFee = double.tryParse(_shippingFeeController.text) ?? 0.0;
    final serviceFee = double.tryParse(_serviceFeeController.text) ?? 0.0;

    final updated = CostSetting(
      shippingFee: shippingFee,
      includeShippingInTax: _includeShippingInTax,
      serviceFee: serviceFee,
      includeServiceFeeInTax: _includeServiceFeeInTax,
      taxPercentage: taxPercentage,
    );

    context.read<CostSettingBloc>().add(UpdateCostSettingEvent(updated));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pengaturan biaya berhasil disimpan'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.accent,
      ),
    );
    if (!widget.isEmbedded) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget content = BlocConsumer<CostSettingBloc, CostSettingState>(
      listener: (context, state) {
        if (state is CostSettingLoaded) {
          final cs = state.costSetting;
          _taxPercentageController.text = cs.taxPercentage > 0 ? cs.taxPercentage.toString() : '';
          _shippingFeeController.text = cs.shippingFee > 0 ? cs.shippingFee.toString() : '';
          _serviceFeeController.text = cs.serviceFee > 0 ? cs.serviceFee.toString() : '';
          setState(() {
            _includeShippingInTax = cs.includeShippingInTax;
            _includeServiceFeeInTax = cs.includeServiceFeeInTax;
          });
        }
      },
      builder: (context, state) {
        if (state is CostSettingLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            // Tablet: content max 560px centered; Mobile: full width
            final isTablet = constraints.maxWidth > 600;
            final contentWidth = isTablet ? 560.0 : constraints.maxWidth;

            return SingleChildScrollView(
              physics: widget.isEmbedded ? const NeverScrollableScrollPhysics() : null,
              padding: EdgeInsets.symmetric(
                horizontal: widget.isEmbedded ? 0 : (isTablet ? (constraints.maxWidth - contentWidth) / 2 : 20),
                vertical: widget.isEmbedded ? 0 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isEmbedded)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24.0, left: 4.0),
                      child: Text(
                        'Kelola Pembayaran',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  // ─── CARD: Pajak ───
                  _buildCard(
                    isDark: isDark,
                    theme: theme,
                    icon: Icons.receipt_long_rounded,
                    iconColor: AppColors.accent,
                    title: 'Pajak',
                    child: _buildTextField(
                      controller: _taxPercentageController,
                      label: 'Persentase (%)',
                      hint: '11',
                      isDark: isDark,
                      theme: theme,
                      suffix: '%',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── CARD: Biaya Layanan ───
                  _buildCard(
                    isDark: isDark,
                    theme: theme,
                    icon: Icons.room_service_rounded,
                    iconColor: AppColors.warning,
                    title: 'Biaya Layanan',
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _serviceFeeController,
                          label: 'Nominal (Rp)',
                          hint: '5000',
                          isDark: isDark,
                          theme: theme,
                          prefix: 'Rp',
                        ),
                        const SizedBox(height: 12),
                        _buildCheckbox(
                          label: 'Masukkan ke kalkulasi pajak',
                          value: _includeServiceFeeInTax,
                          onChanged: (val) => setState(() => _includeServiceFeeInTax = val ?? false),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── CARD: Ongkos Kirim ───
                  _buildCard(
                    isDark: isDark,
                    theme: theme,
                    icon: Icons.local_shipping_rounded,
                    iconColor: AppColors.success,
                    title: 'Ongkos Kirim',
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _shippingFeeController,
                          label: 'Nominal (Rp)',
                          hint: '10000',
                          isDark: isDark,
                          theme: theme,
                          prefix: 'Rp',
                        ),
                        const SizedBox(height: 12),
                        _buildCheckbox(
                          label: 'Masukkan ke kalkulasi pajak',
                          value: _includeShippingInTax,
                          onChanged: (val) => setState(() => _includeShippingInTax = val ?? false),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ─── BUTTON: Simpan ───
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );

    if (widget.isEmbedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Kelola Pembayaran'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: content,
    );
  }

  // ─────────────────────── CARD WRAPPER ───────────────────────
  Widget _buildCard({
    required bool isDark,
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1D3B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2D4B) : AppColors.border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: icon + title
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  // ─────────────────────── TEXT FIELD ───────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    required ThemeData theme,
    String? prefix,
    String? suffix,
  }) {
    final fillColor = isDark ? const Color(0xFF0F1123) : AppColors.background;
    final labelColor = isDark ? Colors.white70 : AppColors.textSecondary;

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
      ],
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: labelColor, fontSize: 14),
        hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.5), fontSize: 14),
        filled: true,
        fillColor: fillColor,
        prefixText: prefix != null ? '$prefix  ' : null,
        prefixStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white54 : AppColors.textSecondary,
        ),
        suffixText: suffix,
        suffixStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white54 : AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  // ─────────────────────── CHECKBOX ───────────────────────
  Widget _buildCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: value,
                activeColor: AppColors.accent,
                checkColor: Colors.white,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
