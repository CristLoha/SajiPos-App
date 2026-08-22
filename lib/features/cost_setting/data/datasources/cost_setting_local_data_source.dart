import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import '../models/cost_setting_model.dart';

abstract class CostSettingLocalDataSource {
  Future<void> cacheCostSetting(CostSettingModel taxModel);
  Future<CostSettingModel> getCachedCostSetting();
}

class CostSettingLocalDataSourceImpl implements CostSettingLocalDataSource {
  final SharedPreferences sharedPreferences;

  CostSettingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheCostSetting(CostSettingModel taxModel) async {
    try {
      final jsonString = json.encode(taxModel.toJson());
      await sharedPreferences.setString('CACHED_TAX', jsonString);
    } catch (e) {
      throw const DatabaseException('Pajaknya gagal disimpan di perangkat.');
    }
  }

  @override
  Future<CostSettingModel> getCachedCostSetting() async {
    try {
      final jsonString = sharedPreferences.getString('CACHED_TAX');
      if (jsonString != null) {
        return CostSettingModel.fromJson(json.decode(jsonString));
      } else {
        return const CostSettingModel(
          shippingFee: 0,
          includeShippingInTax: false,
          serviceFee: 0,
          includeServiceFeeInTax: false,
          taxPercentage: 0,
        );
      }
    } catch (e) {
      throw const DatabaseException('Pajaknya gagal dimuat nih.');
    }
  }
}
