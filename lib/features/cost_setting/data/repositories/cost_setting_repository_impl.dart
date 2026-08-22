import 'package:dartz/dartz.dart';

import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/cost_setting.dart';
import '../../domain/repositories/cost_setting_repository.dart';
import '../datasources/cost_setting_local_data_source.dart';
import '../datasources/cost_setting_remote_data_source.dart';
import '../models/cost_setting_model.dart';

class CostSettingRepositoryImpl implements CostSettingRepository {
  final CostSettingRemoteDataSource remoteDataSource;
  final CostSettingLocalDataSource localDataSource;
  final AuthLocalDataSource authLocalDataSource;

  CostSettingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, CostSetting>> getCostSetting() async {
    try {
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        return const Left(ServerFailure('Sesi kamu udah habis nih, login lagi yuk.'));
      }
      final model = await remoteDataSource.getCostSetting(token);
      await localDataSource.cacheCostSetting(model);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure('Ada kendala nih, yuk coba refresh lagi.'));
    }
  }

  @override
  Future<Either<Failure, CostSetting>> updateCostSetting(CostSetting costSetting) async {
    try {
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        return const Left(ServerFailure('Sesi kamu udah habis nih, login lagi yuk.'));
      }
      final model = CostSettingModel.fromEntity(costSetting);
      final updatedModel = await remoteDataSource.updateCostSetting(token, model);
      await localDataSource.cacheCostSetting(updatedModel);
      return Right(updatedModel.toEntity());
    } catch (e) {
      return Left(ServerFailure('Ada kendala nih, yuk coba refresh lagi.'));
    }
  }

  @override
  Future<Either<Failure, CostSetting>> getCachedCostSetting() async {
    try {
      final model = await localDataSource.getCachedCostSetting();
      return Right(model.toEntity());
    } catch (e) {
      return const Left(CacheFailure('Data pajak di perangkat belum bisa diambil.'));
    }
  }
}
