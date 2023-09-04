import 'package:get/get.dart';
import 'package:mastermind_together/src/services/mailgun/mailgun_service.dart';

class EmailController extends GetxController {
  final MailgunService _mailgunService = Get.find<MailgunService>();
  final isLoading = false.obs;
  final error = ''.obs;

  Future<void> sendEmail(Map<String, dynamic> emailData) async {
    try {
      isLoading(true);

      final bool success = await _mailgunService.sendMail(emailData);

      if (success) {
        // Do something on success, maybe navigate to another screen or show a success message
      } else {
        error('Failed to send email');
      }
    } catch (e, s) {
      print(e);
      print(s);
      error('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
