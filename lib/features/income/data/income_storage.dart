import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ngay_luong/features/income/domain/income_profile.dart';

/// Wraps flutter_secure_storage for IncomeProfile.
/// Never log income values.
class IncomeStorage {
  const IncomeStorage();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const _key = 'income_profile';

  /// Returns null if there is no data or parsing fails.
  Future<IncomeProfile?> read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) {
      return null;
    }
    try {
      return IncomeProfile.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> write(IncomeProfile profile) async {
    await _storage.write(key: _key, value: jsonEncode(profile.toJson()));
  }

  Future<void> clear() async {
    await _storage.delete(key: _key);
  }
}
