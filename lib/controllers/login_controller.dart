import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isLogged = false.obs;
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> login(String username, String password) async {
    try {
      final response = await supabase
          .from('users')
          .select('id, username, password')
          .eq('username', username);
      
      print('res: $response');

      final userData = response;
      if (userData[0]['password'] == password) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', username);
        isLogged.value = true;
        Get.offAllNamed('/dashboard');
      } else {
        Get.snackbar('Error', 'Username or password is incorrect.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Username or password is incorrect.');
    }
  }

  // Method to check if the user is already logged in
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    if (isLoggedIn != null && isLoggedIn) {
      // If the user is logged in, set the state to logged in
      isLogged.value = true;
    }
  }

  // Method to log out the user
  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      isLogged.value = false;
      Get.offAllNamed('/login');  // Redirect to login page
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while logging out: $e');
    }
  }
}
