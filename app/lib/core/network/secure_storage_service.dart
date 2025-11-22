import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for encrypted data persistence across app sessions.
/// 
/// This singleton class provides a platform-agnostic interface for securely
/// storing sensitive data like authentication tokens, user credentials,
/// and other confidential information using native platform encryption.
/// 
/// Features:
/// - Android: Uses EncryptedSharedPreferences for hardware-backed security
/// - iOS: Uses Keychain Services with first-unlock accessibility
/// - Singleton pattern ensures consistent storage access
class SecureStorageService {
  SecureStorageService._();
  static final SecureStorageService instance = SecureStorageService._();

  /// Key for storing persisted Supabase authentication sessions
  /// Versioned (v1) to allow for future migration strategies
  static const String kPersistedSession = 'sb_persisted_session_v1';

  // Secure storage instance with platform-specific encryption options
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  /// Writes a value to secure storage with the specified key.
  /// 
  /// [key]: The identifier for the stored value
  /// [value]: The string data to store securely
  /// 
  /// Data is encrypted using platform-native security mechanisms:
  /// - Android: AES encryption via EncryptedSharedPreferences
  /// - iOS: Keychain Services with device encryption
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  /// Reads a value from secure storage by key.
  /// 
  /// [key]: The identifier for the stored value
  /// 
  /// Returns the decrypted string value, or null if the key doesn't exist
  /// or cannot be decrypted.
  Future<String?> read({required String key}) => _storage.read(key: key);

  /// Deletes a value from secure storage by key.
  /// 
  /// [key]: The identifier for the value to remove
  /// 
  /// Permanently removes the encrypted data from storage. Useful for
  /// logout operations or data cleanup.
  Future<void> delete({required String key}) => _storage.delete(key: key);
}