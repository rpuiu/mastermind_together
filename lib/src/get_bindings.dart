import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetBindings {
  static Future init() async {
    Supabase supabase = await Supabase.initialize(
        url: 'https://qcycfezcqfdivbjzqjzg.supabase.co',
        anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFjeWNmZXpjcWZkaXZianpxanpnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODcyODA5ODIsImV4cCI6MjAwMjg1Njk4Mn0.zczM2v7LQ1RrseTDmiWm26O-vtjRysinJkJIK2GtrGQ');
//TODO extract secrets!!!

    SupabaseClient supaClient = Supabase.instance.client;
    Get.lazyPut(() => supaClient);
    Get.lazyPut(() => AuthController(supaClient), fenix: true);
  }
}
