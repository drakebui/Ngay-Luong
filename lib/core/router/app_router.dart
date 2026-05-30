import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/features/crush/presentation/screens/crush_calendar_screen.dart';
import 'package:ngay_luong/features/crush/presentation/screens/crush_editor_screen.dart';
import 'package:ngay_luong/features/crush/presentation/screens/still_crushing_screen.dart';
import 'package:ngay_luong/features/income/presentation/screens/onboarding_screen.dart';
import 'package:ngay_luong/features/quick_check/presentation/screens/home_screen.dart';
import 'package:ngay_luong/features/quick_check/presentation/screens/result_screen.dart';
import 'package:ngay_luong/features/save_card/domain/save_card_template.dart';
import 'package:ngay_luong/features/save_card/presentation/screens/save_card_screen.dart';
import 'package:ngay_luong/features/settings/presentation/screens/settings_screen.dart';

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
        pageBuilder: (context, state) {
          final price = state.extra as double?;
          final child = (price == null || price <= 0)
              ? const _InvalidRoute()
              : ResultScreen(price: price);
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: child,
            transitionDuration: const Duration(milliseconds: 380),
            reverseTransitionDuration: const Duration(milliseconds: 280),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final slideTween =
                  Tween(begin: const Offset(0, 1), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeOutCubic));
              final fadeTween =
                  Tween(begin: 0.0, end: 1.0)
                      .chain(CurveTween(curve: const Interval(0, 0.4)));
              return FadeTransition(
                opacity: animation.drive(fadeTween),
                child: SlideTransition(
                  position: animation.drive(slideTween),
                  child: child,
                ),
              );
            },
          );
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
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.saveCard,
        builder: (context, state) {
          final input = state.extra as SaveCardInput?;
          if (input == null) {
            return const _InvalidRoute();
          }
          return SaveCardScreen(input: input);
        },
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
