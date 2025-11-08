import 'package:get_it/get_it.dart';
import '../network/supabase_client.dart';
import '../network/session_manager.dart';
import '../network/progress_service.dart';
import '../network/audio_api_service.dart';
import '../network/secure_storage_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core services
  getIt.registerLazySingleton(() => AppSupabase());
  getIt.registerLazySingleton(() => SessionManager.instance);
  getIt.registerLazySingleton(() => SecureStorageService.instance);

  // API services
  getIt.registerLazySingleton(() => ProgressService());
  getIt.registerLazySingleton(() => AudioApiService());
}
