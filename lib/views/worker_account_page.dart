import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_pages.dart';

class WorkerAccountSection extends StatelessWidget {
  final dynamic user;
  final auth = Get.find<AuthController>();

  WorkerAccountSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.account_circle)),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                user?.displayName ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black45,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                user?.email ?? '',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 32),
            _buildActionCard(
              title: 'Edit Profile',
              icon: Icons.edit,
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 236, 231, 236),
                  Color.fromARGB(255, 239, 178, 232)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
            ),
            _buildActionCard(
              title: 'Change Password',
              icon: Icons.lock,
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 236, 231, 236),
                  Color.fromARGB(255, 239, 178, 232)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD),
            ),
            _buildActionCard(
              title: 'View History',
              icon: Icons.history,
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 236, 231, 236),
                  Color.fromARGB(255, 239, 178, 232)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => Get.toNamed(Routes.WORKER_HISTORY),
            ),
            _buildActionCard(
              title: 'Logout',
              icon: Icons.logout,
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 236, 231, 236),
                  Color.fromARGB(255, 239, 178, 232)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => auth.logout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(icon, color: Colors.black, size: 36),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                      color: Colors.black38,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
