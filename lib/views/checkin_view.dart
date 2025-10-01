// worker_home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/auth_controller.dart';
import '../controllers/checkin_controller.dart';
import '../routes/app_pages.dart';

class WorkerHomeView extends StatefulWidget {
  const WorkerHomeView({super.key});

  @override
  _WorkerHomeViewState createState() => _WorkerHomeViewState();
}

class _WorkerHomeViewState extends State<WorkerHomeView> {
  final authCtrl = Get.find<AuthController>();
  final checkinCtrl = Get.find<CheckinController>();

  int _currentIndex = 0;
  String? _loadedUid; // to ensure we load history only once per user

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        // while Firebase determines the auth state show a full-screen loader
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // if no user, show a friendly message + button to go to login
        final firebaseUser = snap.data;
        if (firebaseUser == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Not logged in', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Get.offAllNamed(Routes.LOGIN),
                    child: const Text('Go to Login'),
                  )
                ],
              ),
            ),
          );
        }

        // user exists: make sure personal history is loaded once per user
        if (_loadedUid != firebaseUser.uid) {
          _loadedUid = firebaseUser.uid;
          // load history once (controller should handle caching)
          checkinCtrl.loadPersonalHistory(firebaseUser.uid);
        }

        // now show the main scaffold with bottom nav and tabs
        final tabs = [
          WorkerHomeTabHome(user: firebaseUser),
          WorkerHomeTabAccount(user: firebaseUser),
        ];

        return Scaffold(
          body: tabs[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Account'),
            ],
          ),
        );
      },
    );
  }
}

/// -------------------------
/// Home tab: check-in / check-out
/// -------------------------
class WorkerHomeTabHome extends StatelessWidget {
  final User user;
  WorkerHomeTabHome({super.key, required this.user});

  final checkinCtrl = Get.find<CheckinController>();

  String _todayStr() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    // layout + static parts outside Obx
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Slide to Check-in or Check-out',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.9), fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // ONLY the reactive part is inside Obx
              Obx(() {
                final history = checkinCtrl.personalHistory;
                final today = _todayStr();

                bool checkedIn = false;
                bool checkedOut = false;

                // safe iteration in case list is null/empty
                if (history != null && history.isNotEmpty) {
                  for (var c in history) {
                    final cDateStr =
                        DateFormat('yyyy-MM-dd').format(c.timestamp);
                    if (cDateStr == today) {
                      if (c.type == 'checkin') checkedIn = true;
                      if (c.type == 'checkout') checkedOut = true;
                    }
                  }
                }

                return Column(
                  children: [
                    if (checkinCtrl.loading.value)
                      const LinearProgressIndicator(
                        backgroundColor: Colors.white30,
                        color: Colors.white,
                      ),
                    const SizedBox(height: 30),

                    // Slide to Check-in
                    SlideAction(
                      borderRadius: 35,
                      innerColor: Colors.white,
                      outerColor: checkedIn ? Colors.grey : Colors.green,
                      sliderButtonIcon: Icon(
                        Icons.login,
                        color: checkedIn ? Colors.grey : Colors.green,
                      ),
                      text: checkedIn
                          ? 'Already Checked-in'
                          : 'Slide to Check-in',
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      onSubmit: checkedIn
                          ? null
                          : () => checkinCtrl.performCheck(
                              user.uid, user.email ?? '', 'checkin'),
                    ),
                    const SizedBox(height: 30),

                    // Slide to Check-out
                    SlideAction(
                      borderRadius: 35,
                      innerColor: Colors.white,
                      outerColor: checkedOut ? Colors.grey : Colors.red,
                      sliderButtonIcon: Icon(
                        Icons.logout,
                        color: checkedOut ? Colors.grey : Colors.red,
                      ),
                      text: checkedOut
                          ? 'Already Checked-out'
                          : 'Slide to Check-out',
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      onSubmit: checkedOut
                          ? null
                          : () => checkinCtrl.performCheck(
                              user.uid, user.email ?? '', 'checkout'),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// -------------------------
/// Account tab: profile + actions
/// -------------------------
class WorkerHomeTabAccount extends StatelessWidget {
  final User user;
  final auth = Get.find<AuthController>();

  WorkerHomeTabAccount({super.key, required this.user});

  String _initial(String? name) {
    if (name == null || name.trim().isEmpty) return 'W';
    return name.trim()[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final displayName = user.displayName;
    final email = user.email ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Text(
                _initial(displayName),
                style: const TextStyle(fontSize: 36, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              displayName != null && displayName.trim().isNotEmpty
                  ? displayName
                  : 'Worker',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              email,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
          const SizedBox(height: 32),
          _buildActionCard(
            title: 'Edit Profile',
            icon: Icons.edit,
            gradient: const LinearGradient(
              colors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
            ),
            onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
          ),
          _buildActionCard(
            title: 'Change Password',
            icon: Icons.lock,
            gradient: const LinearGradient(
              colors: [Color(0xFFf44336), Color(0xFFb71c1c)],
            ),
            onTap: () => Get.toNamed(Routes.ACCOUNT),
          ),
          _buildActionCard(
            title: 'View History',
            icon: Icons.history,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF9800), Color(0xFFEF6C00)],
            ),
            onTap: () => Get.toNamed(Routes.WORKER_HISTORY),
          ),
          _buildActionCard(
            title: 'Logout',
            icon: Icons.logout,
            gradient: const LinearGradient(
              colors: [Color(0xFF607D8B), Color(0xFF455A64)],
            ),
            onTap: () => auth.logout(),
          ),
        ],
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
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(icon, color: Colors.white, size: 36),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
