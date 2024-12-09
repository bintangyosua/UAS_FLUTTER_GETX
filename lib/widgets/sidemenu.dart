import 'package:flutter_getx/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class Sidemenu extends StatelessWidget {
  const Sidemenu({super.key});

  // Method to get the username from SharedPreferences
  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    return username;
  }

  void signout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginView()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(children: [
        // Using FutureBuilder to display the username in the DrawerHeader
        FutureBuilder<String?>(
          future: getUsername(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DrawerHeader(
                child: Text('Welcome, ${snapshot.data}'),
              );
            } else {
              return const DrawerHeader(child: Text('Unknown User'));
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Dashboard'),
          onTap: () {
            Get.toNamed('/dashboard');
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Cashier'),
          onTap: () {
            Get.toNamed('/cashier');
          },
        ),
        ListTile(
          leading: const Icon(Icons.shopping_basket),
          title: const Text('Products'),
          onTap: () {
            Get.toNamed('/products');
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app_rounded),
          title: const Text('Logout'),
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('username');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginView()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ]),
    );
  }
}
