import 'package:flutter/material.dart';
import 'package:flutter_getx/controllers/profile_controller.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Obx(() => Text('Email: ${profileController.email.value}')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Kembali'),
              ),
            ],
          ),
        ));
  }
}
