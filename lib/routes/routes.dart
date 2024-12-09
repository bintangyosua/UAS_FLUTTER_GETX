import 'package:flutter_getx/views/data_view.dart';
import 'package:flutter_getx/views/home_view.dart';
import 'package:flutter_getx/views/login_view.dart';
import 'package:flutter_getx/views/mulan_view.dart';
import 'package:flutter_getx/views/profile_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => LoginView()),
    GetPage(name: '/home', page: () => HomeView()),
    GetPage(name: '/mulan', page: () => MulanView()),
    GetPage(name: '/add', page: () => MulanView()),
    GetPage(name: '/profile', page: () => ProfileView()),
    GetPage(name: '/data', page: () => DataView()),
  ];
}
