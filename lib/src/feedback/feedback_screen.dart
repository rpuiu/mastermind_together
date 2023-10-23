import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/feedback/feedback_controller.dart';
import 'package:mastermind_together/src/notif/email/email_notif_controller.dart';
import 'package:mastermind_together/src/ui/theme/layout/scrollable_layout.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';

class FeedbackScreen extends GetView<FeedbackController> {
  FeedbackScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> supportFormKey = GlobalKey<FormState>();
  final EmailController emailController = Get.find<EmailController>();

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 600;
    return ScrollableCustomLayout(
      content: Obx(() {
        if (emailController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return isDesktop
              ? Row(
                  children: [
                    Expanded(
                      child: buildAllContent(context),
                    ),
                    wXSpace,
                    Expanded(
                      child: Image.asset('assets/images/contact/contact-1.png', fit: BoxFit.cover),
                    ),
                  ],
                )
              : buildAllContent(context);
        }
      }),
    );
  }

  Widget buildAllContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        xHalfSpace,
        const Text(
          "We would love to hear your thoughts, so we can improve!",
          style: headingText,
        ),
        xxSpace,
        buildContent(context),
        xxSpace,
        buildFeatureSection(context),
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    return Card(
      elevation: 1,
      shape: customBorder,
      child: Container(
        padding: const EdgeInsets.only(
          top: 1.5 * fontSize,
          left: fontSize,
          right: fontSize,
          bottom: fontSize,
        ),
        width: goalCardWidth,
        child: Form(
          key: supportFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Talk to a member of our team",
                style: headingText,
              ),
              xSpace,
              CustomTextFormField(
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                controller: controller.issueTextFieldController,
                hintText: 'We\'ll email you back shortly',
                label: 'Message',
                // validator: validator?,
              ),
              xSpace,
              CustomButton(
                onPressed: () {
                  controller.sendEmail().then((_) {
                    _showFeedbackSentDialog(context);
                    controller.issueTextFieldController.clear();
                  });
                },
                label: 'Contact Us',
                labelTextStyle: buttonTextStyle,
                backgroundColor: buttonBackgroundColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeatureSection(BuildContext context) {
    return Card(
      elevation: 1,
      shape: customBorder,
      child: Container(
        padding: const EdgeInsets.only(
          top: 1.5 * fontSize,
          left: fontSize,
          right: fontSize,
          bottom: fontSize,
        ),
        width: goalCardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Have an idea that can improve our app?",
              style: headingText,
            ),
            xxSpace,
            CustomButton(
              onPressed: () => controller.requestFeature(),
              label: 'Go to Feature Board',
              labelTextStyle: buttonTextStyle,
              backgroundColor: buttonBackgroundColor,
            )
          ],
        ),
      ),
    );
  }

  void _showFeedbackSentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Message Sent!'),
        content: const Text('Your message has been successfully sent. We will get back to you shortly.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
