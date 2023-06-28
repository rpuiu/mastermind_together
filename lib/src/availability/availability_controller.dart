import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mastermind_together/src/availability/day_model.dart';
import 'package:mastermind_together/src/dbops/supa/auth_service.dart';
import 'package:mastermind_together/src/dbops/supa/availability_service.dart';

class AvailabilityController extends GetxController {
  final AvailabilityService _availabilityService = Get.find();
  final AuthService _authService = Get.find();
  final RxList<DayModel> days = List.generate(
    7,
    (index) => DayModel(
      dayName: DateFormat.E().format(DateTime(2022, 1, index + 1)), // Get weekday names
    ),
  ).obs;

  void saveAvailability() async {
    String userId = _authService.getCurrentUser().id;

    for (var day in days) {
      try {
        await _availabilityService.createAvailability(userId, day);
      } catch (e) {
        Get.snackbar(
          'Error saving availability',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
