import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // optional - open mail app

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtr = TextEditingController();
  bool _loading = false;
  bool _autoValidate = false;

  @override
  void dispose() {
    _emailCtr.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter your email';
    final email = v.trim();
    // Simple email regex
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$");
    if (!regex.hasMatch(email)) return 'Please enter a valid email address';
    return null;
  }

  Future<void> _sendReset() async {
    setState(() => _autoValidate = true);

    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtr.text.trim();
    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Success popup
      Get.snackbar(
        'Email Sent',
        'A password reset link has been sent to $email. Check your inbox or spam.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );

      // Optionally guide user to open mail app
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reset Link Sent'),
          content: Text(
              'We\'ve sent a password reset link to\n\n$email\n\nOpen your mail app to reset your password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openMailApp();
              },
              child: const Text('Open Mail App'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      final message = _mapFirebaseAuthError(e);
      Get.snackbar(
        'Reset Failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    // Friendly error messages
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Failed to send password reset email.';
    }
  }

  Future<void> _openMailApp() async {
    // This tries to open the default mail app on the device.
    // url_launcher will open a mailto: which usually opens the mail app.
    final uri = Uri(scheme: 'mailto', path: '');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'Cannot Open Mail',
        'No email app found or cannot open.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colors: a green-blue gradient — you can adjust
    const gradientStart = Color(0xFF00C6A7);
    const gradientEnd = Color(0xFF2575FC);

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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Card(
              elevation: 18,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.white, Colors.white70],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.lock_reset,
                        size: 48,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Forgot Password',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter the email associated with your account and we\'ll send a password reset link.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 18),

                    // Form
                    Form(
                      key: _formKey,
                      autovalidateMode: _autoValidate
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailCtr,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            validator: _validateEmail,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'you@example.com',
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onFieldSubmitted: (_) => _sendReset(),
                          ),
                          const SizedBox(height: 18),

                          // Send button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 6,
                                textStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              onPressed: _loading ? null : _sendReset,
                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Send Reset Link'),
                            ),
                          ),

                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              // go back to login screen
                              Get.back();
                            },
                            child: const Text('Back to Sign in'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
