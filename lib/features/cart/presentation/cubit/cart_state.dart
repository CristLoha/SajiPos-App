import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';
import 'package:saji_pos_app/features/discount/domain/entities/discount.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final double diskon;
  final Set<int> selectedDiscountIds;
  final Discount? activeDiscount;

  final double taxPercentage;
  final double shippingFeeAmount;
  final double serviceFeeAmount;
  final bool includeShippingInTax;
  final bool includeServiceFeeInTax;

  const CartState({
    this.items = const [],
    this.diskon = 0.0,
    this.selectedDiscountIds = const {},
    this.activeDiscount,
    this.taxPercentage = 0.0,
    this.shippingFeeAmount = 0.0,
    this.serviceFeeAmount = 0.0,
    this.includeShippingInTax = false,
    this.includeServiceFeeInTax = false,
  });

  double get subTotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get subTotalAfterDiscount {
    double result = subTotal - diskon;
    return result < 0 ? 0 : result;
  }

  double get taxBase => subTotalAfterDiscount 
      + (includeShippingInTax ? shippingFeeAmount : 0) 
      + (includeServiceFeeInTax ? serviceFeeAmount : 0);

  double get pajak => taxBase * (taxPercentage / 100);
  
  double get total => subTotalAfterDiscount + shippingFeeAmount + serviceFeeAmount + pajak;

  CartState copyWith({
    List<CartItem>? items,
    double? diskon,
    Set<int>? selectedDiscountIds,
    Discount? activeDiscount,
    bool clearDiscount = false,
    double? taxPercentage,
    double? shippingFeeAmount,
    double? serviceFeeAmount,
    bool? includeShippingInTax,
    bool? includeServiceFeeInTax,
  }) {
    return CartState(
      items: items ?? this.items,
      diskon: diskon ?? this.diskon,
      selectedDiscountIds: selectedDiscountIds ?? this.selectedDiscountIds,
      activeDiscount: clearDiscount ? null : (activeDiscount ?? this.activeDiscount),
      taxPercentage: taxPercentage ?? this.taxPercentage,
      shippingFeeAmount: shippingFeeAmount ?? this.shippingFeeAmount,
      serviceFeeAmount: serviceFeeAmount ?? this.serviceFeeAmount,
      includeShippingInTax: includeShippingInTax ?? this.includeShippingInTax,
      includeServiceFeeInTax: includeServiceFeeInTax ?? this.includeServiceFeeInTax,
    );
  }

  @override
  List<Object?> get props => [
    items,
    diskon,
    selectedDiscountIds,
    activeDiscount,
    taxPercentage,
    shippingFeeAmount,
    serviceFeeAmount,
    includeShippingInTax,
    includeServiceFeeInTax,
    items.map((e) => '${e.product.id}-${e.quantity}-${e.note}').toList(),
  ];

  factory CartState.fromJson(Map<String, dynamic> json) {
    return CartState(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      diskon: (json['diskon'] as num?)?.toDouble() ?? 0.0,
      selectedDiscountIds: (json['selectedDiscountIds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toSet() ??
          const {},
      activeDiscount: json['activeDiscount'] != null
          ? Discount.fromJson(json['activeDiscount'] as Map<String, dynamic>)
          : null,
      taxPercentage: (json['taxPercentage'] as num?)?.toDouble() ?? 0.0,
      shippingFeeAmount: (json['shippingFeeAmount'] as num?)?.toDouble() ?? 0.0,
      serviceFeeAmount: (json['serviceFeeAmount'] as num?)?.toDouble() ?? 0.0,
      includeShippingInTax: json['includeShippingInTax'] ?? false,
      includeServiceFeeInTax: json['includeServiceFeeInTax'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'diskon': diskon,
      'selectedDiscountIds': selectedDiscountIds.toList(),
      'activeDiscount': activeDiscount?.toJson(),
      'taxPercentage': taxPercentage,
      'shippingFeeAmount': shippingFeeAmount,
      'serviceFeeAmount': serviceFeeAmount,
      'includeShippingInTax': includeShippingInTax,
      'includeServiceFeeInTax': includeServiceFeeInTax,
    };
  }
}
