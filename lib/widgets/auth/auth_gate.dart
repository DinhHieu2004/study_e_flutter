import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../pages/auth_page.dart';
import '../../main.dart';
import '../../providers/auth_provider.dart';

final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isBEAuth = ref.watch(authProvider.select((a) => a.isAuthenticated));

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => const AuthPage(),
      data: (user) {
        if (user == null || !isBEAuth) {
          return const AuthPage();
        }
        return const MainLayout();
      },
    );
  }
}
