import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/promo/data/datasources/campaign_remote_data_source.dart';
import 'package:saji_pos_app/features/promo/domain/entities/campaign.dart';
import 'package:saji_pos_app/features/promo/domain/repositories/campaign_repository.dart';

class CampaignRepositoryImpl implements CampaignRepository {
  final CampaignRemoteDataSource remoteDataSource;

  CampaignRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<Campaign>>> getActiveCampaigns() async {
    try {
      final campaignModels = await remoteDataSource.getActiveCampaigns();
      final campaigns = campaignModels
          .map((model) => model.toEntity())
          .toList();

      return Right(campaigns);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Terjadi kesalahan pada server'));
    } catch (e) {
      return const Left(ServerFailure('Terjadi kesalahan yang tidak terduga.'));
    }
  }
}
