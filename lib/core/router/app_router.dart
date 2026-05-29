import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngay_luong/core/router/routes.dart';

final appRouter = GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const _PlaceholderScreen(title: 'Home'),
    ),
    GoRoute(
      path: Routes.result,
      builder: (context, state) => const _PlaceholderScreen(title: 'Result'),
    ),
    GoRoute(
      path: Routes.crushNew,
      builder: (context, state) => const _PlaceholderScreen(title: 'Crush Card'),
    ),
    GoRoute(
      path: Routes.calendar,
      builder: (context, state) => const _PlaceholderScreen(title: 'Calendar'),
    ),
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => const _PlaceholderScreen(title: 'Onboarding'),
    ),
    GoRoute(
      path: Routes.settings,
      builder: (context, state) => const _PlaceholderScreen(title: 'Settings'),
    ),
    GoRoute(
      path: Routes.saveCard,
      builder: (context, state) => const _PlaceholderScreen(title: 'Save Card'),
    ),
    GoRoute(
      path: '/crush/:id',
      builder: (context, state) => _PlaceholderScreen(
        title: 'Crush Detail ${state.pathParameters['id']}',
      ),
      routes: [
        GoRoute(
          path: 'still',
          builder: (context, state) => _PlaceholderScreen(
            title: 'Còn mê không? ${state.pathParameters['id']}',
          ),
        ),
      ],
    ),
  ],
);

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
