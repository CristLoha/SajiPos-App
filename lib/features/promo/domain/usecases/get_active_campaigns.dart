import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/promo/domain/entities/campaign.dart';
import 'package:saji_pos_app/features/promo/domain/repositories/campaign_repository.dart';

class GetActiveCampaigns {
  final CampaignRepository repository;

  GetActiveCampaigns(this.repository);

  Future<Either<Failure, List<Campaign>>> execute() {
    return repository.getActiveCampaigns();
  }
}
