import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'auth/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/admin/admin_layout.dart';
import 'screens/engineer/engineer_layout.dart';
import 'screens/requester/requester_layout.dart';

GoRouter createRouter(BuildContext context) {
  return GoRouter(
    refreshListenable: context.read<AuthProvider>(),
    initialLocation: '/login',

    redirect: (context, state) {
      final auth = context.read<AuthProvider>();

      if (!auth.isAuthenticated) {
        return '/login';
      }

      if (auth.role == 'admin') return '/admin';
      if (auth.role == 'engineer') return '/engineer';
      if (auth.role == 'requester') return '/requester';
      if (auth.role == 'superadmin') return '/superadmin';

      return '/login';
    },

    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/admin', builder: (_, __) => const AdminLayout()),
      GoRoute(path: '/engineer', builder: (_, __) => const EngineerLayout()),
      GoRoute(path: '/requester', builder: (_, __) => const RequesterLayout()),
      GoRoute(path: '/superadmin', builder: (_, __) => const AdminLayout()),
    ],
  );
}
