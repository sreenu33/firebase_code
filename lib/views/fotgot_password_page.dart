import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/app_text_form_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  const Text(
                    "Reset your password",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Enter your email and we’ll send you reset instructions.",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  /// Email Field
                  AppTextFormField(
                    controller: _usernameController,
                    label: "Email",
                    icon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  /// Submit Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Send Reset Link"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    final email = _usernameController.text.trim();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      debugPrint("Password reset email sent to $email");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset link sent. Check your email."),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase error: ${e.code} - ${e.message}");

      String message;
      switch (e.code) {
        case 'invalid-email':
          message = "Invalid email address";
          break;
        case 'user-not-found':
          message = "No user found with this email";
          break;
        case 'too-many-requests':
          message = "Too many requests. Try again later";
          break;
        default:
          message = e.message ?? "Password reset failed";
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      debugPrint("Unknown error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
