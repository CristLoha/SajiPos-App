import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import '../entities/cost_setting.dart';

abstract class CostSettingRepository {
  Future<Either<Failure, CostSetting>> getCostSetting();
  Future<Either<Failure, CostSetting>> updateCostSetting(CostSetting costSetting);
  Future<Either<Failure, CostSetting>> getCachedCostSetting();
}
