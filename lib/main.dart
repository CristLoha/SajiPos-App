import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/core/utils/app_router.dart';
import 'package:saji_pos_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:saji_pos_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:saji_pos_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'core/theme/app_theme.dart';
import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        BlocProvider(create: (_) => di.locator<ProductBloc>()..add(GetProductsEvent())),
        BlocProvider(create: (_) => di.locator<CartCubit>()),
        BlocProvider(create: (_) => di.locator<CategoryBloc>()..add(GetCategoriesEvent())),
      ],
      child: MaterialApp.router(
        title: 'Saji Pos App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
