import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackController extends GetxController {
  final GlobalKey supportFormKey = GlobalKey<FormState>();
  final TextEditingController issueTextFieldController = TextEditingController();
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();

  sendEmail() {
    String userEmail = _localStorage.getUser()!.email;
    String toEmail = dotenv.env['FEEDBACK_EMAIL']!;
    _launchURL(toEmail, 'Feedback from: $userEmail', issueTextFieldController.value.text);
  }

  _launchURL(String toMailId, String subject, String body) async {
    Uri url = Uri(scheme: 'mailto', path: toMailId, queryParameters: {'subject': subject, 'body': body});
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
