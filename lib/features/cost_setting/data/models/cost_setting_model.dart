import 'package:equatable/equatable.dart';
import '../../domain/entities/cost_setting.dart';

class CostSettingModel extends Equatable {
  final double shippingFee;
  final bool includeShippingInTax;
  final double serviceFee;
  final bool includeServiceFeeInTax;
  final double taxPercentage;

  const CostSettingModel({
    required this.shippingFee,
    required this.includeShippingInTax,
    required this.serviceFee,
    required this.includeServiceFeeInTax,
    required this.taxPercentage,
  });

  factory CostSettingModel.fromJson(Map<String, dynamic> json) {
    return CostSettingModel(
      shippingFee:
          double.tryParse(json['shipping_fee']?.toString() ?? '0') ?? 0.0,
      includeShippingInTax:
          json['include_shipping_in_tax'] == true ||
          json['include_shipping_in_tax'] == 1,
      serviceFee:
          double.tryParse(json['service_fee']?.toString() ?? '0') ?? 0.0,
      includeServiceFeeInTax:
          json['include_service_fee_in_tax'] == true ||
          json['include_service_fee_in_tax'] == 1,
      taxPercentage:
          double.tryParse(json['tax_percentage']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shipping_fee': shippingFee,
      'include_shipping_in_tax': includeShippingInTax,
      'service_fee': serviceFee,
      'include_service_fee_in_tax': includeServiceFeeInTax,
      'tax_percentage': taxPercentage,
    };
  }

  factory CostSettingModel.fromEntity(CostSetting entity) {
    return CostSettingModel(
      shippingFee: entity.shippingFee,
      includeShippingInTax: entity.includeShippingInTax,
      serviceFee: entity.serviceFee,
      includeServiceFeeInTax: entity.includeServiceFeeInTax,
      taxPercentage: entity.taxPercentage,
    );
  }

  CostSetting toEntity() {
    return CostSetting(
      shippingFee: shippingFee,
      includeShippingInTax: includeShippingInTax,
      serviceFee: serviceFee,
      includeServiceFeeInTax: includeServiceFeeInTax,
      taxPercentage: taxPercentage,
    );
  }

  @override
  List<Object?> get props => [
    shippingFee,
    includeShippingInTax,
    serviceFee,
    includeServiceFeeInTax,
    taxPercentage,
  ];
}
