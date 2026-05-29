import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/features/crush/presentation/screens/crush_calendar_screen.dart';
import 'package:ngay_luong/features/crush/presentation/screens/crush_editor_screen.dart';
import 'package:ngay_luong/features/crush/presentation/screens/still_crushing_screen.dart';
import 'package:ngay_luong/features/income/presentation/screens/onboarding_screen.dart';
import 'package:ngay_luong/features/quick_check/presentation/screens/home_screen.dart';
import 'package:ngay_luong/features/quick_check/presentation/screens/result_screen.dart';

GoRouter makeAppRouter(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.result,
        builder: (context, state) {
          final price = state.extra as double?;
          if (price == null || price <= 0) {
            return const _InvalidRoute();
          }
          return ResultScreen(price: price);
        },
      ),
      GoRoute(
        path: Routes.crushNew,
        builder: (context, state) {
          final args = state.extra as CrushEditorArgs?;
          return CrushEditorScreen(args: args);
        },
      ),
      GoRoute(
        path: Routes.calendar,
        builder: (context, state) => const CrushCalendarScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Settings'),
      ),
      GoRoute(
        path: Routes.saveCard,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Save Card'),
      ),
      GoRoute(
        path: '/crush/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CrushEditorScreen(args: CrushEditorArgs.forEdit(cardId: id));
        },
        routes: [
          GoRoute(
            path: 'still',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return StillCrushingScreen(cardId: id);
            },
          ),
        ],
      ),
    ],
  );
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

class _InvalidRoute extends StatelessWidget {
  const _InvalidRoute();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lỗi')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Giá không hợp lệ.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.pop(),
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}
