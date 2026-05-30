import 'package:flutter_test/flutter_test.dart';
import 'package:ngay_luong/features/settings/data/app_lock_service.dart';

class _FakeAdapter implements AppLockAuthAdapter {
  _FakeAdapter({this.available = true, this.willAuth = true});

  final bool available;
  bool willAuth;
  String? lastReason;
  int authCalls = 0;

  @override
  Future<bool> canCheckBiometrics() async => available;

  @override
  Future<bool> authenticate({required String reason}) async {
    authCalls++;
    lastReason = reason;
    return willAuth;
  }
}

void main() {
  test('isAvailable forwards to adapter', () async {
    final svc = AppLockService(adapter: _FakeAdapter(available: false));
    expect(await svc.isAvailable(), false);
  });

  test('authenticate succeeds when adapter returns true', () async {
    final adapter = _FakeAdapter();
    final svc = AppLockService(adapter: adapter);
    final ok = await svc.authenticate();
    expect(ok, true);
    expect(adapter.authCalls, 1);
    expect(adapter.lastReason, isNotEmpty);
  });

  test('authenticate fails when adapter refuses', () async {
    final svc = AppLockService(
      adapter: _FakeAdapter(willAuth: false),
    );
    expect(await svc.authenticate(), false);
  });

  test('custom reason flows to adapter', () async {
    final adapter = _FakeAdapter();
    final svc = AppLockService(adapter: adapter);
    await svc.authenticate(reason: 'Mở khóa');
    expect(adapter.lastReason, 'Mở khóa');
  });
}
