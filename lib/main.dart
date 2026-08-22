import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:saji_pos_app/core/utils/app_router.dart';
import 'package:saji_pos_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:saji_pos_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:saji_pos_app/features/discount/presentation/bloc/discount_bloc.dart';
import 'package:saji_pos_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:saji_pos_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:saji_pos_app/features/report/presentation/bloc/report_bloc.dart';
import 'package:saji_pos_app/features/settings/presentation/cubit/sync_cubit.dart';
import 'package:saji_pos_app/features/store_profile/presentation/bloc/store_profile_bloc.dart';
import 'package:saji_pos_app/features/cost_setting/presentation/bloc/cost_setting_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await di.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<AuthBloc>()..add(AuthCheckStatus()),
        ),
        BlocProvider(
          create: (_) => di.locator<ProductBloc>()..add(GetProductsEvent()),
        ),
        BlocProvider(create: (_) => di.locator<CartCubit>()),
        BlocProvider(
          create: (_) => di.locator<CategoryBloc>()..add(GetCategoriesEvent()),
        ),

        BlocProvider(create: (_) => di.locator<OrderBloc>()),

        BlocProvider(
          create: (_) =>
              di.locator<DiscountBloc>()..add(const FetchActiveDiscounts(status: 'active')),
        ),
        BlocProvider(create: (_) => di.locator<ReportBloc>()),
        BlocProvider(create: (_) => di.locator<SyncCubit>()),
        BlocProvider(create: (_) => di.locator<ThemeCubit>()),
        BlocProvider(create: (_) => di.locator<CostSettingBloc>()..add(LoadCachedCostSetting())),
        BlocProvider(create: (_) => di.locator<StoreProfileBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return MaterialApp.router(
            title: 'Saji Pos App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
