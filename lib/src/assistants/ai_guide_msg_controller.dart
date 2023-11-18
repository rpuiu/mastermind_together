import 'package:get/get.dart';
import 'package:mastermind_together/src/assistants/user_thread_model.dart';
import 'package:mastermind_together/src/services/ai/ai_service.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/user_thread_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class AIThreadMessageController extends GetxController {
  UserThreadService userThreadService = Get.find<UserThreadService>();
  AuthService authService = Get.find<AuthService>();
  AIService aiService = Get.find<AIService>();

  RxBool isLoading = false.obs;

  Future<String?> createNewThread() async {
    isLoading.value = true;
    String? thread;
    try {
      String userId = authService.getUser()!.id;
      UserThreadModel? userThread = await userThreadService.getUserThread(userId);

      if (userThread == null) {
        String? threadId = await aiService.createNewThread();
        if (threadId != null) {
          UserThreadModel userThreadModel = await userThreadService.addUserThread(userId, threadId);
          thread = userThreadModel.aiThreadId;
        }
      } else {
        thread = userThread.aiThreadId;
      }
    } catch (e) {
      Log().e('Error: $e');
      showErrorSnackBar(message: "Unable to start conversation. Please try again");
    } finally {
      isLoading.value = false;
    }
    return thread;
  }
}
