import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/features/income/presentation/screens/onboarding_screen.dart';

GoRouter makeAppRouter(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => _AppShell(
          location: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: Routes.home,
            builder: (context, state) => const _BlankRouteBody(),
          ),
          GoRoute(
            path: Routes.crush,
            builder: (context, state) => const _BlankRouteBody(),
          ),
          GoRoute(
            path: Routes.settings,
            builder: (context, state) => const _BlankRouteBody(),
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
    final outline = isDark ? AppColors.outlineVariantDark : AppColors.neutral;
    final onSurface = isDark ? AppColors.onSurfaceDark : AppColors.onSurface;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: surface.withValues(alpha: 0.9),
        foregroundColor: onSurface,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            child: const Text('N'),
          ),
        ),
        title: const Text('Ngày Lương'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: IconButton(
              tooltip: 'Cài đặt',
              onPressed: () => context.go(Routes.settings),
              icon: const Icon(Symbols.settings),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: outline.withValues(alpha: 0.3)),
        ),
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: location == Routes.crush ? 1 : 0,
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
}

class _BlankRouteBody extends StatelessWidget {
  const _BlankRouteBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.bgDark : AppColors.bg;

    return ColoredBox(
      color: bg,
      child: const SizedBox.expand(),
    );
  }
}
