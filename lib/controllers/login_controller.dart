import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isLogged = false.obs;
  final SupabaseClient supabase = Supabase.instance.client;

  // Method to login using custom query to users table
  Future<void> login(String username, String password) async {
    try {
      // Query the 'users' table to check if the username exists
      final response = await supabase
          .from('users')
          .select('id, username, password')  // Assuming the users table has columns id, username, password
          .eq('username', username);
      
      print('res: $response');

      // Check if the password matches (assuming plaintext password here, ideally use hashing)
      final userData = response;
      if (userData[0]['password'] == password) {
        // Save user login state to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', username);

        // Update login state
        isLogged.value = true;

        // Navigate to the dashboard
        Get.offAllNamed('/dashboard');
      } else {
        // If password doesn't match
        Get.snackbar('Error', 'Username or password is incorrect.');
      }
    } catch (e) {
      // Handle unexpected error
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
