part of 'campaign_bloc.dart';

sealed class CampaignEvent extends Equatable {
  const CampaignEvent();

  @override
  List<Object> get props => [];
}

class FetchActiveCampaigns extends CampaignEvent {}
