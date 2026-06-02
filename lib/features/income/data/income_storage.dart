import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ngay_luong/features/income/domain/income_profile.dart';

abstract interface class SecureStringStorage {
  Future<String?> read({required String key});

  Future<void> write({required String key, required String value});

  Future<void> delete({required String key});
}

class FlutterSecureStringStorage implements SecureStringStorage {
  const FlutterSecureStringStorage();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  @override
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }
}

/// Wraps flutter_secure_storage for IncomeProfile.
///
/// Income is sensitive data: this class never logs raw values and stores only
/// the JSON payload under [key] in the platform secure store.
class IncomeStorage {
  const IncomeStorage({
    SecureStringStorage storage = const FlutterSecureStringStorage(),
  }) : _storage = storage;

  static const key = 'income_profile';

  final SecureStringStorage _storage;

  Future<IncomeProfile?> read() async {
    final raw = await _storage.read(key: key);
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      return IncomeProfile.fromJson(decoded);
    } catch (_) {
      // Corrupted secure-storage payload should not block app startup.
      return null;
    }
  }

  Future<void> write(IncomeProfile profile) async {
    await _storage.write(key: key, value: jsonEncode(profile.toJson()));
  }

  Future<void> clear() async {
    await _storage.delete(key: key);
  }
}
