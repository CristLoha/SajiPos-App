import 'package:get_it/get_it.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:saji_pos_app/features/history/data/datasources/history_remote_data_source.dart';
import 'package:saji_pos_app/features/history/data/repositories/history_repository_impl.dart';
import 'package:saji_pos_app/features/history/domain/repositories/history_repository.dart';
import 'package:saji_pos_app/features/history/domain/usecases/get_transactions.dart';
import 'package:saji_pos_app/features/history/domain/usecases/sync_midtrans_status.dart';
import 'package:saji_pos_app/features/history/presentation/bloc/history_bloc.dart';
import 'package:saji_pos_app/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:saji_pos_app/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:saji_pos_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:saji_pos_app/features/notification/domain/usecases/get_initial_notification.dart';
import 'package:saji_pos_app/features/notification/domain/usecases/on_notification_opened_app.dart';
import 'package:saji_pos_app/features/notification/domain/usecases/subscribe_to_promo_topic.dart';
import 'package:saji_pos_app/features/notification/presentation/bloc/notification_bloc.dart';

import 'package:saji_pos_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:saji_pos_app/features/discount/data/datasources/discount_remote_data_source.dart';
import 'package:saji_pos_app/features/discount/data/repositories/discount_repository_impl.dart';
import 'package:saji_pos_app/features/discount/domain/repositories/discount_repository.dart';
import 'package:saji_pos_app/features/discount/domain/usecases/get_active_discount.dart';
import 'package:saji_pos_app/features/discount/domain/usecases/get_unseen_discount_count.dart';
import 'package:saji_pos_app/features/discount/domain/usecases/mark_discounts_as_seen.dart';
import 'package:saji_pos_app/features/discount/presentation/bloc/discount_bloc.dart';
import 'package:saji_pos_app/features/order/data/datasource/order_remote_data_source.dart';
import 'package:saji_pos_app/features/order/data/datasource/order_local_data_source.dart';
import 'package:saji_pos_app/features/order/data/repositories/order_repository_impl.dart';
import 'package:saji_pos_app/features/order/domain/repositories/order_repository.dart';
import 'package:saji_pos_app/features/order/domain/usecases/submit_order.dart';
import 'package:saji_pos_app/features/order/domain/usecases/get_order_status.dart';
import 'package:saji_pos_app/features/order/domain/usecases/sync_pending_orders.dart';
import 'package:saji_pos_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:saji_pos_app/core/theme/theme_cubit.dart';
import 'package:saji_pos_app/features/cost_setting/data/datasources/cost_setting_remote_data_source.dart';
import 'package:saji_pos_app/features/cost_setting/data/datasources/cost_setting_local_data_source.dart';
import 'package:saji_pos_app/features/cost_setting/data/repositories/cost_setting_repository_impl.dart';
import 'package:saji_pos_app/features/cost_setting/domain/repositories/cost_setting_repository.dart';
import 'package:saji_pos_app/features/cost_setting/domain/usecases/cost_setting_usecases.dart';
import 'package:saji_pos_app/features/cost_setting/presentation/bloc/cost_setting_bloc.dart';
import 'package:saji_pos_app/features/report/data/datasources/report_remote_data_source.dart';
import 'package:saji_pos_app/features/report/data/repositories/report_repository_impl.dart';
import 'package:saji_pos_app/features/report/domain/repositories/report_repository.dart';
import 'package:saji_pos_app/features/report/domain/usecases/get_today_summary.dart';
import 'package:saji_pos_app/features/report/presentation/bloc/report_bloc.dart';
import 'package:saji_pos_app/features/store_profile/data/datasources/store_profile_remote_data_source.dart';
import 'package:saji_pos_app/features/store_profile/data/repositories/store_profile_repository_impl.dart';
import 'package:saji_pos_app/features/store_profile/domain/repositories/store_profile_repository.dart';
import 'package:saji_pos_app/features/store_profile/domain/usecases/get_store_profile.dart';
import 'package:saji_pos_app/features/store_profile/presentation/bloc/store_profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:saji_pos_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:saji_pos_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saji_pos_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:saji_pos_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:saji_pos_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:saji_pos_app/features/auth/domain/usecases/get_token.dart';
import 'package:saji_pos_app/features/auth/domain/usecases/post_login.dart';
import 'package:saji_pos_app/features/auth/domain/usecases/post_logout.dart';
import 'package:saji_pos_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:saji_pos_app/features/category/data/datasources/category_remote_data_source.dart';
import 'package:saji_pos_app/features/category/data/repositories/category_repository_impl.dart';
import 'package:saji_pos_app/features/category/domain/repositories/category_repository.dart';
import 'package:saji_pos_app/features/category/domain/usecases/get_categories.dart';
import 'package:saji_pos_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:saji_pos_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:saji_pos_app/features/product/data/repositories/product_detail_repository_impl.dart';
import 'package:saji_pos_app/features/product/domain/repositories/product_repository.dart';
import 'package:saji_pos_app/features/product/domain/repositories/product_detail_repository.dart';
import 'package:saji_pos_app/features/product/domain/usecases/get_product.dart';
import 'package:saji_pos_app/features/product/domain/usecases/get_product_detail.dart';
import 'package:saji_pos_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:saji_pos_app/core/data/database_helper.dart';
import 'package:saji_pos_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:saji_pos_app/features/category/data/datasources/category_local_data_source.dart';
import 'package:saji_pos_app/features/discount/data/datasources/discount_local_data_source.dart';
import 'package:saji_pos_app/features/product/domain/usecases/sync_products.dart';
import 'package:saji_pos_app/features/settings/presentation/cubit/sync_cubit.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => DatabaseHelper.instance);
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
  locator.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(dbHelper: locator()),
  );
  locator.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(dbHelper: locator()),
  );
  locator.registerLazySingleton<DiscountLocalDataSource>(
    () => DiscountLocalDataSourceImpl(
      dbHelper: locator(),
      sharedPreferences: locator(),
    ),
  );
  locator.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSourceImpl(dbHelper: locator()),
  );
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

  locator.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(dio: locator()),
  );

  locator.registerLazySingleton<DiscountRemoteDataSource>(
    () => DiscountRemoteDataSourceImpl(dio: locator()),
  );

  locator.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<StoreProfileRemoteDataSource>(
    () => StoreProfileRemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<HistoryRemoteDataSource>(
    () => HistoryRemoteDataSourceImpl(dio: locator(), sharedPreferences: locator()),
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
      productLocalDataSource: locator(),
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
      authLocalDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: locator(),
      authLocalDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<DiscountRepository>(
    () => DiscountRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      authLocalDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<StoreProfileRepository>(
    () => StoreProfileRepositoryImpl(
      remoteDataSource: locator(),
      authLocalDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(remoteDataSource: locator()),
  );

  // Use cases
  locator.registerLazySingleton(() => GetToken(locator()));
  locator.registerLazySingleton(() => PostLogin(locator()));
  locator.registerLazySingleton(() => PostLogout(locator()));
  locator.registerLazySingleton(() => GetProduct(locator()));
  locator.registerLazySingleton(() => GetCategories(locator()));
  locator.registerLazySingleton(() => GetProductDetail(locator()));
  locator.registerLazySingleton(() => SubmitOrder(locator()));
  locator.registerLazySingleton(() => GetOrderStatus(locator()));
  locator.registerLazySingleton(() => GetActiveDiscount(locator()));
  locator.registerLazySingleton(() => GetUnseenDiscountCount(locator()));
  locator.registerLazySingleton(() => MarkDiscountsAsSeen(locator()));
  locator.registerLazySingleton(() => GetTodaySummary(locator()));
  locator.registerLazySingleton(
    () => SyncProducts(locator(), locator(), locator()),
  );
  locator.registerLazySingleton(() => GetStoreProfile(locator()));
  locator.registerLazySingleton(() => GetTransactions(locator()));
  locator.registerLazySingleton(() => SyncMidtransStatus(locator()));

  // Bloc
  locator.registerFactory(
    () => AuthBloc(
      getToken: locator(),
      postLogin: locator(),
      postLogout: locator(),
    ),
  );
  locator.registerFactory(() => ProductBloc(locator()));
  locator.registerFactory(() => CartCubit(sharedPreferences: locator()));

  locator.registerFactory(() => CategoryBloc(locator()));
  locator.registerFactory(
    () => OrderBloc(submitOrder: locator(), getOrderStatus: locator()),
  );
  locator.registerFactory(
    () => HistoryBloc(getTransactions: locator(), syncMidtransStatus: locator()),
  );

  locator.registerFactory(
    () => DiscountBloc(
      getActiveDiscount: locator(),
      getUnseenDiscountCount: locator(),
      markDiscountsAsSeen: locator(),
    ),
  );
  locator.registerFactory(() => ReportBloc(getTodaySummary: locator()));
  locator.registerFactory(
    () => SyncCubit(
      syncProducts: locator(),
      syncPendingOrders: locator(),
      sharedPreferences: locator(),
    ),
  );
  locator.registerFactory(() => ThemeCubit(sharedPreferences: locator()));
  locator.registerFactory(() => StoreProfileBloc(getStoreProfile: locator()));

  // CostSetting Feature
  locator.registerLazySingleton<CostSettingRemoteDataSource>(
    () => CostSettingRemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<CostSettingLocalDataSource>(
    () => CostSettingLocalDataSourceImpl(sharedPreferences: locator()),
  );
  locator.registerLazySingleton<CostSettingRepository>(
    () => CostSettingRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      authLocalDataSource: locator(),
    ),
  );
  locator.registerLazySingleton(() => GetCostSetting(locator()));
  locator.registerLazySingleton(() => GetCachedCostSetting(locator()));
  locator.registerLazySingleton(() => UpdateCostSetting(locator()));

  // Add SyncPendingOrders to Use cases if missing
  locator.registerLazySingleton(() => SyncPendingOrders(locator()));

  locator.registerFactory(
    () => CostSettingBloc(
      getCostSetting: locator(),
      updateCostSetting: locator(),
      getCachedCostSetting: locator(),
    ),
  );
  // Notification Feature
  locator.registerLazySingleton(() => FirebaseMessaging.instance);
  locator.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(firebaseMessaging: locator()),
  );
  locator.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: locator()),
  );
  locator.registerLazySingleton(() => SubscribeToPromoTopic(locator()));
  locator.registerLazySingleton(() => GetInitialNotification(locator()));
  locator.registerLazySingleton(() => OnNotificationOpenedApp(locator()));
  locator.registerFactory(
    () => NotificationBloc(
      subscribeToPromoTopic: locator(),
      getInitialNotification: locator(),
      onNotificationOpenedApp: locator(),
    ),
  );
}
