import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../services/firestore_service.dart';

class SplashScreen extends StatefulWidget {
  static const String splashRoute = '/splashScreen';
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _user = Rxn<User>();
  User? get user => _user.value;
  final firestore = Get.find<FirestoreService>();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animation
    _animationController.forward();

    // Handle navigation after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _auth.authStateChanges().listen((u) async {
        _user.value = u;
        if (u != null) {
          final role = await firestore.getUserRole(u.uid);
          if (role == 'manager') {
            Get.offAllNamed(Routes.MANAGER_HOME);
          } else {
            Get.offAllNamed(Routes.WORKER_HOME);
          }
        } else {
          Get.offAllNamed(Routes.LOGIN);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or splash image
                Image.network(
                  "https://cdn-icons-png.flaticon.com/512/906/906343.png",
                  height: 120,
                ),
                const SizedBox(height: 20),
                const Text(
                  "WorkMetric",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Smart Check-in & Workforce Tracking",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
