import 'package:equatable/equatable.dart';
import '../../../order/data/models/order_model.dart';

class ReportSummaryResponse extends Equatable {
  final List<OrderModel> orderList;

  const ReportSummaryResponse({required this.orderList});

  factory ReportSummaryResponse.fromJson(Map<String, dynamic> json) =>
      ReportSummaryResponse(
        orderList: json["data"] != null
            ? List<OrderModel>.from(
                (json["data"] as List).map((x) => OrderModel.fromJson(x)),
              )
            : [],
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(orderList.map((x) => x.toJson())),
  };

  @override
  List<Object> get props => [orderList];
}
