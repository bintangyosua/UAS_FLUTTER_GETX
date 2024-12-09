import 'package:flutter_getx/views/dashboard_view.dart';
import 'package:flutter_getx/views/login_view.dart';
import 'package:flutter_getx/views/cashier_view.dart';
import 'package:flutter_getx/views/product_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => LoginView()),
    GetPage(name: '/dashboard', page: () => DashboardView()),
    GetPage(name: '/cashier', page: () => CashierView()),
    GetPage(name: '/products', page: () => ProductView()),
  ];
}
