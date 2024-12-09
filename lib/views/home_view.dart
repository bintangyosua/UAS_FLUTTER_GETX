import 'package:flutter/material.dart';
import 'package:flutter_getx/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Get.toNamed('/profile');
              })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Obx(() => Text('Welcome ${homeController.userName.value}')),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Get.toNamed('/data');
                },
                child: const Text('Lihat Data Item'))
          ],
        ),
      ),
    );
  }
}
