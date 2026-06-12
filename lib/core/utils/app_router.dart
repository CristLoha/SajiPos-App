import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saji_pos_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:saji_pos_app/features/auth/presentation/pages/login_page.dart';
import 'package:saji_pos_app/features/home/presentation/home_page.dart';
import 'package:saji_pos_app/injection.dart' as di;

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',

    redirect: (BuildContext context, GoRouterState state) {
      final authBloc = di.locator<AuthBloc>();
      final authState = authBloc.state;
      final isLoggingIn = state.matchedLocation == '/login';

      if (authState is AuthInitial) {
        return null;
      }

      if (authState is! AuthAuthenticated) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
    ],
  );
}
