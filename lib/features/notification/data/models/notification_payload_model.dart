import '../../domain/entities/notification_payload.dart';

class NotificationPayloadModel {
  final int? campaignId;
  final String? action;

  NotificationPayloadModel({this.campaignId, this.action});

  factory NotificationPayloadModel.fromJson(Map<String, dynamic> json) {
    return NotificationPayloadModel(
      campaignId: json['campaign_id'] != null
          ? int.tryParse(json['campaign_id'].toString())
          : null,
      action: json['action'],
    );
  }

  NotificationPayload toEntity() {
    return NotificationPayload(campaignId: campaignId, action: action);
  }
}
