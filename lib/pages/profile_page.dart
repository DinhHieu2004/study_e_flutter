import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../network/firebase_auth_service.dart';

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>(
  (ref) => FirebaseAuthService(),
);
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.read(authRepositoryProvider);
    final firebaseService = ref.read(firebaseAuthServiceProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Trang cá nhân", style: TextStyle(fontSize: 22)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            onPressed: () async {
              // 1️⃣ Logout trên Firebase
              await firebaseService.logout();

              // 2️⃣ Logout trên backend + clear JWT
              await authRepo.logout();

              // AuthGate sẽ detect Firebase user null → show AuthPage
            },
          ),
        ],
      ),
    );
  }
}
