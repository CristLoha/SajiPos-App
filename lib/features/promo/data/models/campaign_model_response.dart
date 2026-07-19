import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/promo/data/models/campaign_model.dart';

class CampaignModelResponse extends Equatable {
  final List<CampaignModel> campaignList;

  const CampaignModelResponse({required this.campaignList});

  factory CampaignModelResponse.fromJson(Map<String, dynamic> json) =>
      CampaignModelResponse(
        campaignList: List<CampaignModel>.from(
          (json["data"] as List).map((x) => CampaignModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(campaignList.map((x) => x.toJson())),
  };

  @override
  List<Object> get props => [campaignList];
}
