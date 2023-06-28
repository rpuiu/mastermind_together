import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends GetxService {
  final SupabaseClient client = Get.find();

  User getCurrentUser() {
    final User? user = client.auth.currentUser; //TODO user null?
    return user!;
  }
}
