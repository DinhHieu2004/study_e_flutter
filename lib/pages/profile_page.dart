import 'package:flutter/material.dart';
import 'admin_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../network/firebase_auth_service.dart';
import 'flashcard_page.dart';

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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Cá nhân',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150',
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maya',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'maya.learning@email.com',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0066FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trung tâm điều khiển',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Quản lý tài khoản & học tập',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManagementPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0066FF),
                    ),
                    child: const Text('Quản lý'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _buildMenuItem(Icons.history, 'Lịch sử học tập'),
            _buildMenuItem(
              Icons.collections_bookmark,
              'Flash card từ vựng sở hữu',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FlashcardPage(
                      lessonId: 1,
                      title: 'Flash card của tôi',
                    ),
                  ),
                );
              },
            ),

            _buildMenuItem(Icons.card_membership, 'Gói Premium'),
            _buildMenuItem(Icons.workspace_premium, 'Chứng chỉ của tôi'),
            _buildMenuItem(Icons.notifications_none, 'Cài đặt thông báo'),
            _buildMenuItem(Icons.help_outline, 'Hỗ trợ & Trợ giúp'),

            const SizedBox(height: 20),

            TextButton.icon(
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Đăng xuất',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                await firebaseService.logout(); // Firebase
                await authRepo.logout(); // Backend + clear JWT
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
