import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/features/crush/presentation/screens/crush_calendar_screen.dart';
import 'package:ngay_luong/features/crush/presentation/screens/crush_editor_screen.dart';
import 'package:ngay_luong/features/crush/presentation/screens/still_crushing_screen.dart';
import 'package:ngay_luong/features/income/presentation/screens/onboarding_screen.dart';
import 'package:ngay_luong/features/quick_check/presentation/screens/home_screen.dart';
import 'package:ngay_luong/features/quick_check/presentation/screens/result_screen.dart';
import 'package:ngay_luong/features/save_card/domain/save_card_template.dart';
import 'package:ngay_luong/features/save_card/presentation/screens/save_card_screen.dart';
import 'package:ngay_luong/features/settings/presentation/screens/settings_screen.dart';
import 'package:ngay_luong/features/settings/presentation/widgets/app_lock_gate.dart';

GoRouter makeAppRouter(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppLockGate(
          child: _AppShell(location: state.uri.path, child: child),
        ),
        routes: [
          GoRoute(
            path: Routes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: Routes.crush,
            builder: (context, state) => const CrushCalendarScreen(),
          ),
          // /calendar is inside the shell so the bottom nav stays visible
          // (used by HomeScreen shortcut and StillCrushingScreen after action)
          GoRoute(
            path: Routes.calendar,
            builder: (context, state) => const CrushCalendarScreen(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.result,
        pageBuilder: (context, state) {
          final args = state.extra as ResultScreenArgs;
          return CustomTransitionPage(
            child: ResultScreen(price: args.price, itemName: args.itemName),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.4, end: 1.0).animate(
                  animation,
                ),
                child: child,
              ),
            ),
            transitionDuration: const Duration(milliseconds: 380),
          );
        },
      ),
      GoRoute(
        path: Routes.saveCard,
        builder: (context, state) {
          final input = state.extra as SaveCardInput;
          return SaveCardScreen(input: input);
        },
      ),
      // /crush/new must come before /crush/:id so 'new' is not treated as an id
      GoRoute(
        path: Routes.crushNew,
        builder: (context, state) {
          final args = state.extra as CrushEditorArgs?;
          return CrushEditorScreen(args: args);
        },
      ),
      GoRoute(
        path: '/crush/:id',
        builder: (context, state) {
          final cardId = state.pathParameters['id']!;
          final args = state.extra is CrushEditorArgs
              ? state.extra as CrushEditorArgs
              : CrushEditorArgs.forEdit(cardId: cardId);
          return CrushEditorScreen(args: args);
        },
        routes: [
          GoRoute(
            path: 'still',
            builder: (context, state) {
              final cardId = state.pathParameters['id']!;
              return StillCrushingScreen(cardId: cardId);
            },
          ),
        ],
      ),
    ],
  );
}

class _AppShell extends StatelessWidget {
  const _AppShell({required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(location),
        backgroundColor: surface.withValues(alpha: 0.9),
        indicatorColor: theme.colorScheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Symbols.calculate),
            selectedIcon: Icon(Symbols.calculate, fill: 1),
            label: 'Tính toán',
          ),
          NavigationDestination(
            icon: Icon(Symbols.favorite),
            selectedIcon: Icon(Symbols.favorite, fill: 1),
            label: 'Crush',
          ),
        ],
        onDestinationSelected: (index) {
          context.go(index == 0 ? Routes.home : Routes.crush);
        },
      ),
    );
  }

  int _selectedIndex(String location) {
    if (location == Routes.crush || location == Routes.calendar) return 1;
    return 0;
  }
}
