import 'package:flutter/material.dart';
import 'package:flutter_getx/controllers/login_controller.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  loginController.login(
                      usernameController.text, passwordController.text);
                },
                child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}
