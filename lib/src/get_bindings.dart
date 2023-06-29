import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/availability/availability_controller.dart';
import 'package:mastermind_together/src/dbops/supa/auth_service.dart';
import 'package:mastermind_together/src/dbops/supa/goal_service.dart';
import 'package:mastermind_together/src/dbops/supa/user_extended_service.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/timezone/timezone_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dbops/supa/availability_service.dart';

class GetBindings {
  static Future init() async {
    Supabase supabase = await Supabase.initialize(
        url: 'https://qcycfezcqfdivbjzqjzg.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFjeWNmZXpjcWZkaXZianpxanpnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODcyODA5ODIsImV4cCI6MjAwMjg1Njk4Mn0.zczM2v7LQ1RrseTDmiWm26O-vtjRysinJkJIK2GtrGQ');
//TODO extract secrets!!!

    SupabaseClient supaClient = Supabase.instance.client;
    Get.lazyPut(() => supaClient, fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => GoalController(), fenix: true);
    Get.lazyPut(() => AvailabilityController(), fenix: true);
    Get.lazyPut(() => AvailabilityService());
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => TimezoneService());
    Get.lazyPut(() => GoalService());
    Get.lazyPut(() => UserExtendedService());
  }
}
