import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_pages.dart';

class LoginView extends StatelessWidget {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final auth = Get.find<AuthController>();

  LoginView({super.key});

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hero Image (use your own asset or a network image)
                Image.network(
                  "https://cdn-icons-png.flaticon.com/512/295/295128.png",
                  height: 120,
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Login to continue using WorkMetric",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Email
                TextField(
                  controller: emailC,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    prefixIcon: const Icon(Icons.email, color: Colors.white70),
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: passC,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => auth.login(
                      emailC.text.trim(),
                      passC.text.trim(),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2575FC),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text("Login"),
                  ),
                ),

                const SizedBox(height: 16),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    // TODO: password reset

                    Get.toNamed(
                      Routes.FORGOT_PASSWORD,
                    );
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
