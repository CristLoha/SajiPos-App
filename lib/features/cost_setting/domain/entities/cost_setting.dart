import 'package:equatable/equatable.dart';

class CostSetting extends Equatable {
  final double shippingFee;
  final bool includeShippingInTax;
  final double serviceFee;
  final bool includeServiceFeeInTax;
  final double taxPercentage;

  const CostSetting({
    required this.shippingFee,
    required this.includeShippingInTax,
    required this.serviceFee,
    required this.includeServiceFeeInTax,
    required this.taxPercentage,
  });

  @override
  List<Object?> get props => [
    shippingFee,
    includeShippingInTax,
    serviceFee,
    includeServiceFeeInTax,
    taxPercentage,
  ];
}
