import 'package:flutter/material.dart';
import 'package:flutter_getx/controllers/login_controller.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController loginController = Get.put(LoginController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Flag to check if the form has been submitted
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background for the entire page
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or title at the top (use black icon)
              const Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.black, // Black accent for the icon
              ),
              const SizedBox(height: 20),
              const Text(
                'Point of Sale (POS)',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black), // Black text for the title
              ),
              const SizedBox(height: 20),

              // Username TextField with icon
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.black), // Black label
                  hintText: 'Enter your username',
                  hintStyle: const TextStyle(color: Colors.grey), // Grey hint text
                  prefixIcon: const Icon(Icons.person, color: Colors.black), // Black icon
                  errorText: _isSubmitted && _validateUsername() != null
                      ? _validateUsername()
                      : null,
                  filled: true,
                  fillColor: Colors.white, // White background for input
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black), // Black border
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password TextField with icon
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.black), // Black label
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(color: Colors.grey), // Grey hint text
                  prefixIcon: const Icon(Icons.lock, color: Colors.black), // Black icon
                  errorText: _isSubmitted && _validatePassword() != null
                      ? _validatePassword()
                      : null,
                  filled: true,
                  fillColor: Colors.white, // White background for input
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black), // Black border
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button with black accent
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isSubmitted = true; // Set the flag to true when button is pressed
                  });

                  // Only proceed with login if validation is successful
                  if (_validateUsername() == null && _validatePassword() == null) {
                    loginController.login(
                      usernameController.text,
                      passwordController.text,
                    );
                  } else {
                    // Show snackbar if validation fails
                    Get.snackbar(
                      'Error',
                      'Username and password cannot be empty.',
                      snackPosition: SnackPosition.TOP,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Black button color
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Username validation
  String? _validateUsername() {
    if (usernameController.text.isEmpty) {
      return 'Username cannot be empty.';
    }
    return null;
  }

  // Password validation
  String? _validatePassword() {
    if (passwordController.text.isEmpty) {
      return 'Password cannot be empty.';
    }
    return null;
  }
}
