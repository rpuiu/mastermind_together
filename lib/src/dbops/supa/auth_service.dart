import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

//TODO handle errors
  User getCurrentUser() {
    final User? user = _client.auth.currentUser; //TODO user null?
    return user!;
  }

  Future<void> signUp(String email, String password) async {
    final AuthResponse response = await _client.auth.signUp(email: email, password: password);

    // if (response.error != null) {
    //   Get.snackbar('Error', response.error!.message);
    // } else if (response.data != null) {
    //   Get.snackbar('Success', 'Registered successfully. Please check your email for verification.');
    // }
  }

  Future<void> signInWithPassword(String email, String password) async {
    final AuthResponse response = await _client.auth.signInWithPassword(email: email, password: password);

    // if (response.error != null) {
    //   Get.snackbar('Error', response.error!.message);
    // } else if (response.data != null) {
    // Get.snackbar('Success', 'Logged in successfully.');
    // You can use Get.offAll() to navigate to a new screen and remove all previous routes.
    // }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
