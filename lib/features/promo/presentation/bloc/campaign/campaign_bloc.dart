import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/promo/domain/entities/campaign.dart';
import 'package:saji_pos_app/features/promo/domain/usecases/get_active_campaigns.dart';

part 'campaign_event.dart';
part 'campaign_state.dart';

class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  final GetActiveCampaigns getActiveCampaigns;
  CampaignBloc({required this.getActiveCampaigns}) : super(CampaignInitial()) {
    on<FetchActiveCampaigns>((event, emit) async{

    emit(CampaignLoading());

    final result = await getActiveCampaigns.execute();

    result.fold(
      (failure) => emit(CampaignError(message: failure.message)),
      (campaigns) => emit(CampaignLoaded(campaigns: campaigns)),
    );
    });
  }
}
