
import 'package:ababydaycare/authentication/admin/admin_page.dart';
import 'package:ababydaycare/authentication/home_page.dart';
import 'package:ababydaycare/caregiver/caregiver_profile.dart';
import 'package:ababydaycare/caregiver/caregiver_registration.dart';
import 'package:ababydaycare/parent/parent_profile.dart';
import 'package:ababydaycare/service/auth_service.dart';
import 'package:ababydaycare/service/caregiver_service.dart';
import 'package:ababydaycare/service/parent_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final storage = const FlutterSecureStorage();
  final AuthService authService = AuthService();
  final CaregiverService caregiverService = CaregiverService();
  final ParentService parentService = ParentService();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff06292),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // FIX: Corrected navigation to return to HomePage using MaterialPageRoute.
            // Using pushReplacement in case HomePage is intended to be the root on back.
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage())
            );
          },
        ),
        title: Text(
          "Login",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfffff0f5), Color(0xffffc1e3)], // Soft baby-pink gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.child_care, size: 70, color: Color(0xfff06292)),
                    const SizedBox(height: 15),

                    Text(
                      "Welcome Back",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Login to continue",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Email Field
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          loginUser(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xfff06292),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Registration Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Registration(),
                              ),
                            );
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: Color(0xfff06292),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
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

  // Login function with role-based navigation
  Future<void> loginUser(BuildContext context) async {
    try {
      final response = await authService.login(email.text, password.text);
      final role = await authService.getUserRole();

      if (!context.mounted) return;

      if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else if (role == 'CAREGIVER') {
        final profile = await caregiverService.getCaregiverProfile();
        if (profile != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CaregiverProfile(profile: profile),
            ),
          );
        }
      }
      else if (role == 'PARENT') {
        final profile = await parentService.getParentProfile();
        if (profile != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ParentProfile(profile: profile),
            ),
          );
        }
      }else {
        // Handle case where user is logged in but role is unknown/unhandled
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful, but role "$role" is not handled.')),
        );
        print('Unknown role: $role');
      }
    } catch (error) {
      if (context.mounted) {
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please check your credentials.')),
        );
      }
      print('Login failed: $error');
    }
  }
}