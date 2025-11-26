import 'package:get_it/get_it.dart';
import '../network/supabase_client.dart';
import '../network/session_manager.dart';
import '../network/progress_service.dart';
import '../network/audio_api_service.dart';
import '../network/secure_storage_service.dart';

/// Global service locator instance using GetIt for dependency injection.
/// 
/// This provides a centralized registry for accessing services throughout
/// the application without direct dependency instantiation.
final getIt = GetIt.instance;

/// Initializes and registers all application services with the service locator.
/// 
/// This function should be called during application startup to set up
/// the dependency injection container. All services are registered as
/// lazy singletons, meaning they are instantiated only when first accessed.
/// 
/// Service Registration Categories:
/// - Core Services: Fundamental app infrastructure (database, session, storage)
/// - API Services: Business logic and external communication layers
/// 
/// Usage:
/// ```dart
/// void main() {
///   setupServiceLocator();
///   runApp(MyApp());
/// }
/// ```
void setupServiceLocator() {
  // ===========================================================================
  // CORE SERVICES
  // ===========================================================================
  
  /// Supabase client for database operations and real-time features
  /// Usage: Data persistence, user management, real-time subscriptions
  getIt.registerLazySingleton(() => AppSupabase());
  
  /// Session manager for authentication state and user session tracking
  /// Usage: Auth state monitoring, token validation, user session persistence
  getIt.registerLazySingleton(() => SessionManager.instance);
  
  /// Secure storage service for encrypted local data storage
  /// Usage: Token storage, sensitive user preferences, secure caching
  getIt.registerLazySingleton(() => SecureStorageService.instance);

  // ===========================================================================
  // API SERVICES
  // ===========================================================================
  
  /// Progress service for user learning metrics and achievement tracking
  /// Usage: XP updates, streak management, challenge completion tracking
  getIt.registerLazySingleton(() => ProgressService());
  
  /// Audio API service for managing audio content and media processing
  /// Usage: Sound effect management, audio content delivery, media API calls
  getIt.registerLazySingleton(() => AudioApiService());
}
