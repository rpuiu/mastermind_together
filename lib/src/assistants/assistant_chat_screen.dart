import 'package:flutter/material.dart';
import 'package:mastermind_together/src/assistants/ai_guide_chat_ui.dart';
import 'package:mastermind_together/src/ui/theme/layout/custom_layout.dart';

class AssistantChatScreen extends StatelessWidget {
  const AssistantChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      content: AIGuideChatWidget(),
    );
  }
}
