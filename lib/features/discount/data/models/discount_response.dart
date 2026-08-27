import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/discount/data/models/discount_model.dart';

class DiscountResponse extends Equatable {
  final List<DiscountModel> discountList;

  const DiscountResponse({required this.discountList});

  factory DiscountResponse.fromJson(Map<String, dynamic> json) =>
      DiscountResponse(
        discountList: json["data"] != null
            ? List<DiscountModel>.from(
                (json["data"] as List).map((x) => DiscountModel.fromJson(x)),
              )
            : [],
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(discountList.map((x) => x.toJson())),
  };

  @override
  List<Object> get props => [discountList];
}
