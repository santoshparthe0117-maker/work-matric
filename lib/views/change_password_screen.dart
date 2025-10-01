import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordC = TextEditingController();
  final _newPasswordC = TextEditingController();
  final _confirmPasswordC = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _loading = false;

  Future<void> _changePassword() async {
    final user = _auth.currentUser;

    if (user == null) {
      Get.snackbar('Error', 'No user logged in');
      return;
    }

    if (_formKey.currentState?.validate() != true) return;

    setState(() => _loading = true);

    try {
      // Re-authenticate user with old password
      final cred = EmailAuthProvider.credential(
          email: user.email!, password: _oldPasswordC.text.trim());
      await user.reauthenticateWithCredential(cred);

      // Update password
      await user.updatePassword(_newPasswordC.text.trim());
      Get.snackbar('Success', 'Password updated successfully');
      Get.back();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Old password is incorrect');
      } else if (e.code == 'weak-password') {
        Get.snackbar('Error', 'Password is too weak');
      } else {
        Get.snackbar('Error', e.message ?? 'Failed to update password');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Secure your account by updating your password',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildGradientTextField(
                          controller: _oldPasswordC,
                          hintText: 'Old Password',
                          icon: Icons.lock_outline),
                      const SizedBox(height: 16),
                      _buildGradientTextField(
                          controller: _newPasswordC,
                          hintText: 'New Password',
                          icon: Icons.lock),
                      const SizedBox(height: 16),
                      _buildGradientTextField(
                          controller: _confirmPasswordC,
                          hintText: 'Confirm New Password',
                          icon: Icons.lock),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _changePassword,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(0)),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFC5C7D), Color(0xFF6A82FB)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: _loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      'Update Password',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (val) {
          if (val == null || val.isEmpty) return 'Required';
          if (hintText == 'Confirm New Password' &&
              val != _newPasswordC.text.trim()) return 'Passwords do not match';
          if (hintText == 'New Password' && val.length < 6)
            return 'Password must be 6+ chars';
          return null;
        },
      ),
    );
  }
}
