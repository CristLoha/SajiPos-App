import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import '../entities/cost_setting.dart';
import '../repositories/cost_setting_repository.dart';

class GetCostSetting {
  final CostSettingRepository repository;

  GetCostSetting(this.repository);

  Future<Either<Failure, CostSetting>> call() async {
    return await repository.getCostSetting();
  }
}

class GetCachedCostSetting {
  final CostSettingRepository repository;

  GetCachedCostSetting(this.repository);

  Future<Either<Failure, CostSetting>> call() async {
    return await repository.getCachedCostSetting();
  }
}

class UpdateCostSetting {
  final CostSettingRepository repository;

  UpdateCostSetting(this.repository);

  Future<Either<Failure, CostSetting>> call(CostSetting costSetting) async {
    return await repository.updateCostSetting(costSetting);
  }
}
