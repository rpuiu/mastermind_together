import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/login_screen.dart';
import 'package:mastermind_together/src/auth/register_screen.dart';
import 'package:mastermind_together/src/availability/availability_screen.dart';
import 'package:mastermind_together/src/goal/add_goal_screen.dart';
import 'package:mastermind_together/src/home/home_screen.dart';

class Routes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String goal = '/add-goal';
  static const String availability = '/set-availability';

  static List<GetPage> routes = [
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: goal, page: () => AddGoalScreen()),
    GetPage(name: availability, page: () => SetAvailabilityScreen()),
  ];
}
