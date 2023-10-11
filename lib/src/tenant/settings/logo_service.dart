import 'package:get/get.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';
import 'package:mastermind_together/src/services/supa/settings_service.dart';
import 'package:mastermind_together/src/services/supa/storage_service.dart';

class LogoService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  final SettingsService _settingsService = Get.find<SettingsService>();
  final LocalStorageService _localStorageService = Get.find<LocalStorageService>();

  Future<String> updateSignedUrl(String logoPath) async {
    try {
      if (logoPath.isEmpty) {
        return '';
      }
      String trimmedPath = logoPath.substring('/logos'.length);
      String signedUrl =  _storageService.getPublicUrl('logos', trimmedPath);
      return signedUrl;
    } catch (e, s) {
      Log().e("Unable to update logo", e, s);
      rethrow;
    }
  }

  Future<String> getPublicUrl(String logoPath) async {
    try {
      if (logoPath.isEmpty) {
        return '';
      }
      String trimmedPath = logoPath.substring('/logos'.length);
      String signedUrl = await _storageService.getPublicUrl('logos', trimmedPath);
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

  Future<void> saveLogoUrl(bool isLight, String url) async {
    await _localStorageService.setLogoUrl(url, isLight);
  }

  String? getLogoUrl(bool isLight) {
    return _localStorageService.getLogoUrl(isLight);
  }
}
