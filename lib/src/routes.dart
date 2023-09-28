import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_middleware.dart';
import 'package:mastermind_together/src/auth/login_screen.dart';
import 'package:mastermind_together/src/auth/register_screen.dart';
import 'package:mastermind_together/src/auth/tos/terms_screen.dart';
import 'package:mastermind_together/src/availability/availability_screen.dart';
import 'package:mastermind_together/src/feedback/feedback_screen.dart';
import 'package:mastermind_together/src/goal/all_goals_screen.dart';
import 'package:mastermind_together/src/goal/goal_screen.dart';
import 'package:mastermind_together/src/groups/all_groups_screen.dart';
import 'package:mastermind_together/src/groups/create_group_screen.dart';
import 'package:mastermind_together/src/groups/group_membership_middleware.dart';
import 'package:mastermind_together/src/groups/group_screen.dart';
import 'package:mastermind_together/src/groups/group_screen_controller.dart';
import 'package:mastermind_together/src/home/home_screen.dart';
import 'package:mastermind_together/src/notif/notif_screen.dart';
import 'package:mastermind_together/src/onboarding/onboarding_screen.dart';
import 'package:mastermind_together/src/profile/user_profile_screen.dart';
import 'package:mastermind_together/src/tenant/categories/categories_screen.dart';
import 'package:mastermind_together/src/tenant/settings/tenant_settings_screen.dart';
import 'package:mastermind_together/src/tenant/tenant_dashboard_screen.dart';
import 'package:mastermind_together/src/tenant/tenant_register_screen.dart';
import 'package:mastermind_together/src/tenant/terms/edit_terms_screen.dart';
import 'package:mastermind_together/src/ui/widgets/images/right_side_image_controller.dart';

class Routes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String availability = '/set-availability';
  static const String createGroup = '/create-group';
  static const String allGroups = '/view-groups';
  static const String group = '/group';
  static const String tenantRegister = '/tenant';
  static const String termsOfService = '/tos';
  static const String privacyPolicy = '/privacy-policy';
  static const String userProfile = '/user-profile';
  static const String feedback = '/feedback';
  static const String tenantDashboard = '/dashboard';
  static const String editTerms = '/edit-terms';
  static const String categories = '/categories';
  static const String onboarding = '/onboarding';
  static const String goal = '/goal';
  static const String goals = '/goals';
  static const String notifications = '/notifications';
  static const String tenantSettings = '/tenant-settings';

  static List<GetPage> routes = [
    GetPage(name: home, page: () => HomeScreen(), middlewares: [AuthMiddleware()]),
    GetPage(name: login, page: () => const LoginScreen(), binding: RightSideImageBinding()),
    GetPage(name: register, page: () => const RegisterScreen(), binding: RightSideImageBinding()),
    GetPage(name: goals, page: () => AllGoalsScreen(), middlewares: [AuthMiddleware()]),
    GetPage(name: availability, page: () => SetAvailabilityScreen(), middlewares: [AuthMiddleware()]),
    GetPage(name: createGroup, page: () => CreateGroupScreen(), middlewares: [AuthMiddleware()]),
    GetPage(name: allGroups, page: () => AllGroupsScreen(), middlewares: [AuthMiddleware()]),
    GetPage(name: tenantRegister, page: () => TenantRegisterScreen()), //TODO secure!
    GetPage(name: termsOfService, page: () => const TermsScreen(documentType: 'TOS')),
    GetPage(name: privacyPolicy, page: () => const TermsScreen(documentType: 'Privacy')),
    GetPage(name: userProfile, page: () => UserProfileScreen()),
    GetPage(name: feedback, page: () => FeedbackScreen()),
    GetPage(name: tenantDashboard, page: () => const TenantDashboardScreen()),
    GetPage(name: editTerms, page: () => EditTermsScreen()),
    GetPage(name: categories, page: () => CategoriesScreen()),
    GetPage(name: onboarding, page: () => OnboardingScreen()),
    GetPage(name: notifications, page: () => const NotificationScreen()),
    GetPage(name: '$goal/:goalId', page: () => GoalScreen(), middlewares: [AuthMiddleware()]),
    GetPage(name: tenantSettings, page: () => const TenantSettingsScreen()),
    GetPage(
      name: '$group/:groupId',
      page: () => GroupScreen(),
      binding: BindingsBuilder(() {
        String groupId = Get.parameters['groupId']!;
        if (!Get.isRegistered<GroupScreenController>(tag: groupId)) {
          Get.put(GroupScreenController(groupId: groupId), tag: groupId);
        }
      }),
      middlewares: [AuthMiddleware(), GroupMembershipMiddleware()],
    ),
  ];

  static String groupRoute(String groupId) => '$group/$groupId';

  static String goalRoute(String goalId) => '$goal/$goalId';
}
