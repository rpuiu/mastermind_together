import 'package:get/get.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/supa/settings_service.dart';
import 'package:mastermind_together/src/services/supa/storage_service.dart';

class LogoService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  final SettingsService _settingsService = Get.find<SettingsService>();

  Future<String> updateSignedUrl(String logoPath) async {
    try {
      if (logoPath.isEmpty) {
        return '';
      }
      String trimmedPath = logoPath.substring('/logos'.length);
      String signedUrl = await _storageService.createSignedUrl('logos', trimmedPath);
      return signedUrl;
    } catch (e, s) {
      Log().e("Unable to update logo", e, s);
      rethrow;
    }
  }

  Future<String> initializeLogo(String tenantId, bool isLight) async {
    String? logoUrl = await _settingsService.fetchLogoUrl(tenantId, isLight);

    String signedLogoUrl = '';

    if (logoUrl != null) {
      signedLogoUrl = await updateSignedUrl(logoUrl);
    }

    return signedLogoUrl;
  }

  Future<String> initializeFavicon(String tenantId) async {
    String? faviconUrl = await _settingsService.fetchFaviconUrl(tenantId);

    String signedFaviconUrl = '';

    if (faviconUrl != null) {
      signedFaviconUrl = await updateSignedUrl(faviconUrl);
    }

    return signedFaviconUrl;
  }
}
