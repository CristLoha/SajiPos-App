import 'package:get_it/get_it.dart';
import 'package:saji_pos_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_cubit.dart';

// Auth
import 'package:saji_pos_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saji_pos_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:saji_pos_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:saji_pos_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:saji_pos_app/features/auth/domain/usecases/get_token.dart';
import 'package:saji_pos_app/features/auth/domain/usecases/post_login.dart';
import 'package:saji_pos_app/features/auth/domain/usecases/post_logout.dart';
import 'package:saji_pos_app/features/auth/presentation/bloc/auth_bloc.dart';

// Category
import 'package:saji_pos_app/features/category/data/datasources/category_remote_data_source.dart';
import 'package:saji_pos_app/features/category/data/repositories/category_repository_impl.dart';
import 'package:saji_pos_app/features/category/domain/repositories/category_repository.dart';
import 'package:saji_pos_app/features/category/domain/usecases/get_categories.dart';

// Product
import 'package:saji_pos_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:saji_pos_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:saji_pos_app/features/product/data/repositories/product_detail_repository_impl.dart';
import 'package:saji_pos_app/features/product/domain/repositories/product_repository.dart';
import 'package:saji_pos_app/features/product/domain/repositories/product_detail_repository.dart';
import 'package:saji_pos_app/features/product/domain/usecases/get_product.dart';
import 'package:saji_pos_app/features/product/domain/usecases/get_product_detail.dart';
import 'package:saji_pos_app/features/product/presentation/bloc/product_bloc.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    ),
  );

  // Data sources
  locator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: locator()),
  );
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(dio: locator()),
  );

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<ProductDetailRepository>(
    () => ProductDetailRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // Use cases
  locator.registerLazySingleton(() => GetToken(locator()));
  locator.registerLazySingleton(() => PostLogin(locator()));
  locator.registerLazySingleton(() => PostLogout(locator()));
  locator.registerLazySingleton(() => GetProduct(locator()));
  locator.registerLazySingleton(() => GetCategories(locator()));
  locator.registerLazySingleton(() => GetProductDetail(locator()));

  // Bloc
  locator.registerFactory(
    () => AuthBloc(
      getToken: locator(),
      postLogin: locator(),
      postLogout: locator(),
    ),
  );
  locator.registerFactory(() => ProductBloc(locator()));
  locator.registerFactory(() => CartCubit());

  locator.registerFactory(() => CategoryBloc(locator()));
}
