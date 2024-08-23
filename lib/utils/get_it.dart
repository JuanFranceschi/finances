import 'package:finances/services/account_service.dart';
import 'package:finances/services/category_service.dart';
import 'package:finances/services/database_controller.dart';
import 'package:finances/services/preferences_service.dart';
import 'package:finances/services/transactions_service.dart';
import 'package:finances/utils/app_utils.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // getIt.registerLazySingleton<RudolphService>(() => RudolphService());
  // getIt.registerFactory<ToastManager>(() => ToastManager(FToast()));

  getIt.registerSingleton<DatabaseController>(DatabaseController());
  getIt.registerSingleton<AppUtils>(AppUtils());
  getIt.registerSingleton<PreferencesService>(PreferencesService());

  getIt.registerLazySingleton<TransactionsService>(() => TransactionsService());
  getIt.registerLazySingleton<CategoryService>(() => CategoryService());
  getIt.registerLazySingleton<AccountService>(() => AccountService());
}
