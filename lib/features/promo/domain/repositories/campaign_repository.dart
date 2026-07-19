import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/promo/domain/entities/campaign.dart';

abstract class CampaignRepository {
  Future<Either<Failure, List<Campaign>>> getActiveCampaigns();
}
