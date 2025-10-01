import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';

class AddEmployeeView extends StatelessWidget {
  final emailC = TextEditingController();
  final nameC = TextEditingController();
  final passC = TextEditingController();
  final auth = Get.find<AuthController>();
  final userCtrl = Get.find<UserController>();

  AddEmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),

            // 🔹 Custom AppBar Row with Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Get.back(), // ⬅ back to previous page
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Add New Employee",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // to balance the row alignment
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Header Icon
            const Icon(
              Icons.group_add_rounded,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),

            // 🔹 Form Section (white container)
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CustomTextField(
                        controller: nameC,
                        label: "Full Name",
                        icon: Icons.person,
                        inputType: TextInputType.name,
                      ),
                      const SizedBox(height: 20),

                      _CustomTextField(
                        controller: emailC,
                        label: "Email",
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      _CustomTextField(
                        controller: passC,
                        label: "Temporary Password",
                        icon: Icons.lock,
                        obscure: true,
                      ),
                      const SizedBox(height: 40),

                      // 🔹 Gradient Button
                      _GradientButton(
                        text: "Add Employee",
                        onPressed: () async {
                          final name = nameC.text.trim();
                          final email = emailC.text.trim();
                          final pass = passC.text.trim();

                          if (name.isEmpty || email.isEmpty || pass.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "All fields are required",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          await userCtrl.addWorker(email, name, pass);
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Reusable TextField Widget
class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType inputType;
  final bool obscure;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.inputType = TextInputType.text,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// 🔹 Reusable Gradient Button
class _GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _GradientButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
