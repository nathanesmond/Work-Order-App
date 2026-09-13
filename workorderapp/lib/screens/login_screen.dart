import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  String? _validate() {
    if (usernameCtrl.text.trim().isEmpty) return 'Username is required.';
    if (passwordCtrl.text.isEmpty) return 'Password is required.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.engineering_rounded,
                    size: 56,
                    color: Color.fromRGBO(159, 125, 76, 1),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Work Order Application",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Log in to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 28),

                  // username field
                  TextField(
                    controller: usernameCtrl,

                    decoration: InputDecoration(
                      hintText: 'Username',
                      prefixIcon: const Icon(Icons.alternate_email, size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(159, 125, 76, 1),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // password field
                  TextField(
                    controller: passwordCtrl,
                    obscureText: _obscurePassword,
                    onChanged: (_) {
                      if (_errorMessage != null) {
                        setState(() => _errorMessage = null);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(159, 125, 76, 1),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              final validationError = _validate();
                              if (validationError != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(validationError),
                                    backgroundColor: Colors.red.shade700,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.all(12),
                                  ),
                                );
                                return;
                              }

                              try {
                                final success = await auth.login(
                                  usernameCtrl.text.trim(),
                                  passwordCtrl.text,
                                );
                                if (!success) {
                                  scaffoldMessengerKey.currentState
                                      ?.showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            'Incorrect username or password.',
                                          ),
                                          backgroundColor: Colors.red.shade700,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          margin: const EdgeInsets.all(12),
                                        ),
                                      );
                                }
                              } catch (e) {
                                scaffoldMessengerKey.currentState?.showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Incorrect username or password.',
                                    ),
                                    backgroundColor: Colors.red.shade700,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.all(12),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(159, 125, 76, 1),
                        disabledBackgroundColor: const Color.fromRGBO(
                          159,
                          125,
                          76,
                          .5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: auth.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
