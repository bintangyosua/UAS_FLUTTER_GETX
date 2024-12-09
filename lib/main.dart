import 'package:flutter/material.dart';
import 'package:flutter_getx/routes/routes.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://slagbwlovzbkzelytgxz.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNsYWdid2xvdnpia3plbHl0Z3h6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3MTE5ODksImV4cCI6MjA0OTI4Nzk4OX0.BCcfw7w85elFlmptmBuqpgsBizfaZT_DqiWvD1BgzAU');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GetX App',
      initialRoute: '/',
      getPages: AppRoutes.routes,
    );
  }
}
