import 'package:flutter_getx/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class Sidemenu extends StatelessWidget {
  const Sidemenu({super.key});

  // Future<String?> getUsername(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? username = prefs.getString('username');
  //   return username ??
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => LoginView()));
  // }

  void signout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginView()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        // FutureBuilder<String?>(
        //   future: getUsername(context),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return DrawerHeader(
        //         decoration: const BoxDecoration(
        //             image: DecorationImage(
        //                 image: AssetImage('assets/images/bookshelf.png'),
        //                 fit: BoxFit.cover)),
        //         child: Text(
        //           snapshot.data!,
        //           style: const TextStyle(
        //               color: Colors.white,
        //               fontSize: 22,
        //               fontWeight: FontWeight.w400),
        //         ),
        //       );
        //     } else {
        //       return const CircularProgressIndicator();
        //     }
        //   },
        // ),
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
            }),
        ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Products'),
            onTap: () {
            Get.toNamed('/products');
            }),
        ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: const Text('Logout'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('username');
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginView()),
                  (Route<dynamic> route) => false);
            }),
      ]),
    );
  }
}