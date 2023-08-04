import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_middleware.dart';
import 'package:mastermind_together/src/auth/login_screen.dart';
import 'package:mastermind_together/src/auth/register_screen.dart';
import 'package:mastermind_together/src/auth/tos/terms_screen.dart';
import 'package:mastermind_together/src/availability/availability_screen.dart';
import 'package:mastermind_together/src/feedback/feedback_screen.dart';
import 'package:mastermind_together/src/goal/add_goal_screen.dart';
import 'package:mastermind_together/src/groups/all_groups_screen.dart';
import 'package:mastermind_together/src/groups/create_group_screen.dart';
import 'package:mastermind_together/src/groups/group_screen.dart';
import 'package:mastermind_together/src/home/home_screen.dart';
import 'package:mastermind_together/src/onboarding/onboard_screen.dart';
import 'package:mastermind_together/src/profile/user_profile_screen.dart';
import 'package:mastermind_together/src/tenant/categories/categories_screen.dart';
import 'package:mastermind_together/src/tenant/tenant_dashboard_screen.dart';
import 'package:mastermind_together/src/tenant/tenant_register_screen.dart';
import 'package:mastermind_together/src/tenant/terms/edit_terms_screen.dart';

class Routes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/:tenantId/register';
  static const String createGoal = '/create-goal';
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

  static List<GetPage> routes = [
    GetPage(name: home, page: () => HomeScreen(), middlewares: [AuthMiddleware()]),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: createGoal, page: () => AddGoalScreen(), middlewares: [AuthMiddleware()]),
    GetPage(name: availability, page: () => SetAvailabilityScreen(), middlewares: [AuthMiddleware()]),
    GetPage(name: createGroup, page: () => CreateGroupScreen(), middlewares: [AuthMiddleware()]),
    GetPage(name: allGroups, page: () => AllGroupsScreen(), middlewares: [AuthMiddleware()]),
    GetPage(name: '$group/:groupId', page: () => GroupScreen(), middlewares: [AuthMiddleware()]),
    GetPage(name: tenantRegister, page: () => TenantRegisterScreen()), //TODO secure!
    GetPage(name: '/:tenantId/$termsOfService', page: () => TermsScreen(documentType: 'TOS')),
    GetPage(name: '/:tenantId/$privacyPolicy', page: () => TermsScreen(documentType: 'Privacy')),
    GetPage(name: userProfile, page: () => UserProfileScreen()),
    GetPage(name: feedback, page: () => const FeedbackScreen()),
    GetPage(name: tenantDashboard, page: () => const TenantDashboardScreen()),
    GetPage(name: editTerms, page: () => EditTermsScreen()),
    GetPage(name: categories, page: () => CategoriesScreen()),
    GetPage(name: onboarding, page: () => OnBoardScreen()),
  ];

  static String groupRoute(String groupId) => '$group/$groupId';

  static String termsOfServiceRoute(String tenantId) => '/$tenantId$termsOfService';

  static String privacyPolicyRoute(String tenantId) => '/$tenantId$privacyPolicy';
}
