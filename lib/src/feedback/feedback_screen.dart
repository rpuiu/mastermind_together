import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/feedback/feedback_controller.dart';
import 'package:mastermind_together/src/ui/drawer.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';

class FeedbackScreen extends GetView<FeedbackController> {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "We would love to hear your thoughts, concerns or problems with anything so we can improve!",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "When you press send, an email window will open. Please send the email manually after checking your message.",
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Form(
                  key: controller.supportFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        controller: controller.issueTextFieldController,
                        decoration: InputDecoration(
                          labelText: "Message",
                          labelStyle: Theme.of(context).textTheme.subtitle1,
                        ),
                        // validator: validator?,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        child: const Text('Send'),
                        onPressed: () => controller.sendEmail(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
