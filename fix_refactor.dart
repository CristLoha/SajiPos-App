import 'dart:io';

void main() {
  final files = [
    'lib/features/cart/presentation/cubit/cart_state.dart',
    'lib/features/cost_setting/data/repositories/cost_setting_repository_impl.dart',
    'lib/features/cost_setting/domain/repositories/cost_setting_repository.dart',
    'lib/features/cost_setting/domain/usecases/cost_setting_usecases.dart',
    'lib/features/cost_setting/presentation/bloc/cost_setting_bloc.dart',
    'lib/features/cost_setting/presentation/pages/cost_setting_page.dart',
    'lib/features/settings/presentation/pages/settings_page.dart'
  ];

  for (final path in files) {
    final file = File(path);
    if (!file.existsSync()) continue;

    String content = file.readAsStringSync();
    
    // Fix includeShippingInCostSetting -> includeShippingInTax
    content = content.replaceAll('includeShippingInCostSetting', 'includeShippingInTax');
    content = content.replaceAll('includeServiceFeeInCostSetting', 'includeServiceFeeInTax');
    
    // Fix Tax -> CostSetting for type arguments
    content = content.replaceAll('<Tax>', '<CostSetting>');
    
    // Fix costSetting_bloc arguments
    content = content.replaceAll('emit(CostSettingLoaded(tax))', 'emit(CostSettingLoaded(costSetting))');

    // Fix cost_setting_repository_impl
    content = content.replaceAll('final updatedCostSetting = await', 'final updatedTax = await');
    content = content.replaceAll('return Right(updatedCostSetting)', 'return Right(updatedTax)');
    content = content.replaceAll('final cachedCostSetting = await', 'final cachedTax = await');
    content = content.replaceAll('return Right(cachedCostSetting)', 'return Right(cachedTax)');

    // Fix cost_setting_page variables
    content = content.replaceAll('_includeShippingInCostSetting', '_includeShippingInTax');
    content = content.replaceAll('_includeServiceFeeInCostSetting', '_includeServiceFeeInTax');
    content = content.replaceAll('final updatedCostSetting = CostSetting(', 'final updatedTax = CostSetting(');
    content = content.replaceAll('UpdateCostSettingEvent(updatedCostSetting)', 'UpdateCostSettingEvent(updatedTax)');

    // Fix settings_page
    content = content.replaceAll('state.tax', 'state.costSetting');

    file.writeAsStringSync(content);
  }
}
