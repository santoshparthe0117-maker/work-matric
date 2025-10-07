import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'worker_account_page.dart';
import 'worker_home_page.dart';

class WorkerHomeView extends StatefulWidget {
  const WorkerHomeView({super.key});

  @override
  State<WorkerHomeView> createState() => _WorkerHomeViewState();
}

class _WorkerHomeViewState extends State<WorkerHomeView> {
  int _currentIndex = 0;
  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final user = auth.user;
    final tabs = [
      WorkerHomeSection(user: user),
      WorkerAccountSection(user: user),
    ];

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color.fromARGB(255, 159, 24, 227),
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: const Color(0xFF6A11CB),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
