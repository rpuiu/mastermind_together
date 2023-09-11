import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/availability/availability_controller.dart';
import 'package:mastermind_together/src/categories/category_controller.dart';
import 'package:mastermind_together/src/feedback/feedback_controller.dart';
import 'package:mastermind_together/src/goal/actions/actions_editing_controller.dart';
import 'package:mastermind_together/src/goal/goal_controller.dart';
import 'package:mastermind_together/src/groups/all_groups_controller.dart';
import 'package:mastermind_together/src/groups/group_operations_controller.dart';
import 'package:mastermind_together/src/groups/members_controller.dart';
import 'package:mastermind_together/src/notif/email/email_notif_controller.dart';
import 'package:mastermind_together/src/notif/notif_controller.dart';
import 'package:mastermind_together/src/onboarding/onboard_controller.dart';
import 'package:mastermind_together/src/profile/user_profile_controller.dart';
import 'package:mastermind_together/src/services/mailgun/mailgun_service.dart';
import 'package:mastermind_together/src/services/mixpanel/analytics_service.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:mastermind_together/src/services/supa/action_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/category_service.dart';
import 'package:mastermind_together/src/services/supa/goal_service.dart';
import 'package:mastermind_together/src/services/supa/message_service.dart';
import 'package:mastermind_together/src/services/supa/notif_service.dart';
import 'package:mastermind_together/src/services/supa/settings_service.dart';
import 'package:mastermind_together/src/services/supa/storage_service.dart';
import 'package:mastermind_together/src/services/supa/subscription_service.dart';
import 'package:mastermind_together/src/services/supa/tenant_service.dart';
import 'package:mastermind_together/src/services/supa/user_group_service.dart';
import 'package:mastermind_together/src/services/supa/users_extended_service.dart';
import 'package:mastermind_together/src/services/timezone/timezone_service.dart';
import 'package:mastermind_together/src/subscription/subscription_controller.dart';
import 'package:mastermind_together/src/tenant/tenant_controller.dart';
import 'package:mastermind_together/src/tenant/terms/terms_controller.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/drawer_state_controller.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'services/supa/availability_service.dart';

class GetBindings {
  static Future init() async {
    Supabase supabase = await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    SupabaseClient supaClient = Supabase.instance.client;
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Mixpanel mixpanel = await Mixpanel.init(
      dotenv.env['MIXPANEL_PROJECT_TOKEN']!,
      trackAutomaticEvents: true,
    );

    Get.lazyPut(() => mixpanel, fenix: true);
    Get.lazyPut(() => supaClient, fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => GoalController(), fenix: true);
    Get.lazyPut(() => AvailabilityController(), fenix: true);
    Get.lazyPut(() => AvailabilityService(), fenix: true);
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => TimezoneService(), fenix: true);
    Get.lazyPut(() => GoalService(), fenix: true);
    Get.lazyPut(() => UsersExtendedService(), fenix: true);
    Get.lazyPut(() => AllGroupsController(), fenix: true);
    Get.lazyPut(() => UserGroupService(), fenix: true);
    Get.lazyPut(() => CategoryService(), fenix: true);
    Get.lazyPut(() => MessageService(), fenix: true);
    Get.lazyPut(() => sharedPreferences, fenix: true);
    Get.lazyPut(() => LocalStorageService(), fenix: true);
    Get.lazyPut(() => CategoryController(), fenix: true);
    Get.lazyPut(() => TenantService(), fenix: true);
    Get.lazyPut(() => TenantController(), fenix: true);
    Get.lazyPut(() => Logger(), fenix: true);
    Get.lazyPut(() => AnalyticsService(), fenix: true);
    Get.lazyPut(() => UserProfileController(), fenix: true);
    Get.lazyPut(() => FeedbackController(), fenix: true);
    Get.lazyPut(() => SettingsService(), fenix: true);
    Get.lazyPut(() => TermsController(), fenix: true);
    Get.lazyPut(() => CategoryController(), fenix: true);
    Get.lazyPut(() => OnBoardController(), fenix: true);
    Get.lazyPut(() => ActionService(), fenix: true);
    Get.lazyPut(() => SubscriptionService(), fenix: true);
    Get.lazyPut(() => SubscriptionController(), fenix: true);
    Get.lazyPut(() => ActionEditController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => NotificationService(), fenix: true);
    Get.lazyPut(() => MailgunService(), fenix: true);
    Get.lazyPut(() => EmailController(), fenix: true);
    Get.lazyPut(() => DrawerStateController(), fenix: true);
    Get.lazyPut(() => StorageService(), fenix: true);
    Get.lazyPut(() => MembersController(), fenix: true);
    Get.lazyPut(() => GroupOperationsController(), fenix: true);
  }
}
