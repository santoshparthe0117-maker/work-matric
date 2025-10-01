import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_pages.dart';

class AccountView extends StatelessWidget {
  final auth = Get.find<AuthController>();
  AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          ListTile(leading: const Icon(Icons.person), title: Text(user?.displayName ?? 'No name'), subtitle: Text(user?.email ?? '')),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(Routes.EDIT_PROFILE),
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(onPressed: () => auth.logout(), icon: const Icon(Icons.logout), label: const Text('Logout')),
        ]),
      ),
    );
  }
}
