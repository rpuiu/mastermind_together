import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/notif/email/email_notif_controller.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:mastermind_together/src/util/url_launcher.dart';

class FeedbackController extends GetxController {
  final TextEditingController issueTextFieldController = TextEditingController();
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  final EmailController _emailController = Get.find<EmailController>();

  @override
  onClose() {
    issueTextFieldController.dispose();
  }

  sendEmail() async {
    String userEmail = _localStorage.getUser()!.email;
    String subject = 'Feedback from: $userEmail';

    final emailData = {
      'to': 'mastermindtogether@gmail.com',
      'from': 'no-reply@apeacefultomorrow.us',
      'subject': subject,
      'body': issueTextFieldController.value.text,
      // add other fields as needed
    };

    await _emailController.sendEmail(emailData);
  }

  requestFeature() {
    launchURL('https://feature.mastermindtogether.com/');
  }
}
