import 'package:get/get.dart';
import 'package:mastermind_together/src/services/supa/settings_service.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class TermsController extends GetxController {
  final SettingsService _settingsService = Get.find<SettingsService>();

  final RxString termsOfService = ''.obs;
  final RxString privacyPolicy = ''.obs;

  String? tenantIdParam = Get.parameters['tenantId'];

  @override
  onInit() async {
    super.onInit();
    await _loadTenantTerms();
  }

  Future<void> _loadTenantTerms() async {
    try {
      final settings = await _settingsService.fetchSettings(tenantIdParam!);
      termsOfService.value = settings['terms_of_service'] as String;
      privacyPolicy.value = settings['privacy_policy'] as String;
    } catch (e) {
      showErrorSnackBar(message: 'Failed to load tenant terms');
    }
  }
}
