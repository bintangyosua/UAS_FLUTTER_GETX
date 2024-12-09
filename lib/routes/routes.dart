import 'package:flutter_getx/views/dashboard_view.dart';
import 'package:flutter_getx/views/login_view.dart';
import 'package:flutter_getx/views/transaction_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => LoginView()),
    GetPage(name: '/dashboard', page: () => DashboardView()),
    GetPage(name: '/kasir', page: () => TransactionView()),
  ];
}
