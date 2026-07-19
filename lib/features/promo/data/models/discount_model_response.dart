import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/promo/data/models/discount_model.dart';

class DiscountModelResponse extends Equatable {
  final List<DiscountModel> discountList;

  const DiscountModelResponse({required this.discountList});
  factory DiscountModelResponse.fromJson(Map<String, dynamic> json) =>
      DiscountModelResponse(
        discountList: List<DiscountModel>.from(
          (json["data"] as List).map((x) => DiscountModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(discountList.map((x) => x.toJson())),
  };

  @override
  List<Object> get props => [discountList];
}
