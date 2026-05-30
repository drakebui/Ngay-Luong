import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

/// Adapter to allow tests to inject a fake local_auth implementation.
abstract interface class AppLockAuthAdapter {
  Future<bool> canCheckBiometrics();
  Future<bool> authenticate({required String reason});
}

class LocalAuthAdapter implements AppLockAuthAdapter {
  LocalAuthAdapter({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> canCheckBiometrics() async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return false;
      return await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate({required String reason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      debugPrint('App lock auth failed: $e');
      return false;
    }
  }
}

class AppLockService {
  AppLockService({AppLockAuthAdapter? adapter})
      : _adapter = adapter ?? LocalAuthAdapter();

  final AppLockAuthAdapter _adapter;

  static const _defaultReason = 'Mở khóa Ngày Lương';

  Future<bool> isAvailable() => _adapter.canCheckBiometrics();

  Future<bool> authenticate({String reason = _defaultReason}) {
    return _adapter.authenticate(reason: reason);
  }
}
