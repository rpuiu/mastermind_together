import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:mastermind_together/src/services/supa/settings_service.dart';
import 'package:mastermind_together/src/services/supa/subscription_service.dart';
import 'package:mastermind_together/src/services/supa/users_extended_service.dart';
import 'package:mastermind_together/src/services/timezone/timezone_service.dart';
import 'package:mastermind_together/src/tenant/tenant_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TenantService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();
  final TimezoneService _timezoneService = Get.find<TimezoneService>();
  final UsersExtendedService _userExtendedService = Get.find<UsersExtendedService>();
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  final SettingsService _settingsService = Get.find<SettingsService>();
  final SubscriptionService _subscriptionService = Get.find<SubscriptionService>();

  Future<void> registerTenant(String tenantName, String adminEmail, String adminPassword, String hostName) async {
    try {
      final AuthResponse tenant = await _client.auth.signUp(
        email: adminEmail,
        password: adminPassword,
        data: {'role': 'tenant'},
      );

      final userId = tenant.user!.id;
      await _client.from('tenants').insert({
        'tenant_id': userId,
        'name': tenantName,
        'hostname': hostName,
      });

      await _settingsService.createInitialSettings(userId, 'Initial Terms of Service', 'Initial Privacy Policy');

      String timezone = await _timezoneService.getCurrentTimezoneWithOffset();
      String freeTierSubscription = await _subscriptionService.getFreeTierSubscriptionId();
      UserModel userModel = await _userExtendedService.createUserExtended(userId, tenantName, adminEmail, timezone, userId, freeTierSubscription);
      _localStorage.saveUser(userModel);
    } catch (e, s) {
      Log().e('Failed to create tenant: ', e, s);
    }
  }
}
