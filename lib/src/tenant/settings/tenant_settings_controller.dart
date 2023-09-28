import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/services/supa/settings_service.dart';
import 'package:mastermind_together/src/services/supa/storage_service.dart';
import 'package:mastermind_together/src/tenant/settings/logo_service.dart';

class TenantSettingsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final AuthService _authService = Get.find<AuthService>();
  final SettingsService _settingsService = Get.find<SettingsService>();
  final LogoService _logoService = Get.find<LogoService>();

  RxString signedLightLogoUrl = ''.obs;
  RxString signedDarkLogoUrl = ''.obs;
  RxString signedFaviconUrl = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeLogoForTenant();
    await _initializeFaviconForTenant();
  }

  Future<void> pickLogo(bool isLight) async {
    final XFile? image = await _getImageFromGallery();
    if (image != null) {
      _uploadLogo(image, isLight);
    }
  }

  Future<void> _uploadLogo(XFile image, bool isLight) async {
    try {
      final Uint8List data = await image.readAsBytes();
      String tenantId = _authService.getUser()!.id;
      String newLogoUrl = await _storageService.upsertLogo(tenantId, data, isLight);
      await _settingsService.updateLogoUrl(tenantId, newLogoUrl, isLight);
      String signedUrl = await _logoService.updateSignedUrl(newLogoUrl);
      if (isLight) {
        signedLightLogoUrl.value = signedUrl;
      } else {
        signedDarkLogoUrl.value = signedUrl;
      }
    } catch (e, s) {
      Log().e("Failed to upload logo", e, s);
    }
  }
  Future<XFile?> _getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }


  Future<void> _initializeLogoForTenant() async {
    String tenantId = _authService.getUser()!.id;
    signedLightLogoUrl.value = await _logoService.initializeLogo(tenantId, true);
    signedDarkLogoUrl.value = await _logoService.initializeLogo(tenantId, false);
  }

  Future<void> pickFavicon() async {
    final XFile? image = await _getImageFromGallery();
    if (image != null) {
      _uploadFavicon(image);
    }
  }

  Future<void> _uploadFavicon(XFile image) async {
    try {
      final Uint8List data = await image.readAsBytes();
      String tenantId = _authService.getUser()!.id;
      String newFaviconUrl = await _storageService.upsertFavicon(tenantId, data);
      await _settingsService.updateFaviconUrl(tenantId, newFaviconUrl);

      String signedUrl = await _logoService.updateSignedUrl(newFaviconUrl);
      signedFaviconUrl.value = signedUrl;
    } catch (e, s) {
      Log().e("Failed to upload favicon", e, s);
    }
  }

  Future<void> _initializeFaviconForTenant() async {
    String tenantId = _authService.getUser()!.id;
    signedFaviconUrl.value = await _logoService.initializeFavicon(tenantId);
  }

}
