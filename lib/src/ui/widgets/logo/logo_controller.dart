import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/tenant/settings/logo_service.dart';
import 'package:mastermind_together/src/tenant/tenant_identifier.dart';

class LogoController extends GetxService {
  final TenantIdentifier _tenantIdentifier = Get.find<TenantIdentifier>();
  final LogoService _logoService = Get.find<LogoService>();
  final AuthService _authService = Get.find<AuthService>();

  RxString lightLogoUrl = ''.obs;
  RxString darkLogoUrl = ''.obs;
  RxString faviconUrl = ''.obs;

  RxDouble aspectRatio = 1.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await initializeLogosAndFavicon();
  }

  Future<void> initializeLogosAndFavicon() async {
    final String tenantId = await _getTenantId();
    await setLogo(tenantId);
    await setFavicon(tenantId);
  }

  Future<String> _getTenantId() async {
    if (_authService.getUser() == null) {
      return await _tenantIdentifier.getTenantId();
    } else {
      return _authService.getUser()!.tenantId;
    }
  }

  Future<void> setLogo(String tenantId) async {
    String? cachedLightLogoUrl = _logoService.getLogoUrl(true);
    String? cachedDarkLogoUrl = _logoService.getLogoUrl(false);

    if (cachedLightLogoUrl != null && cachedDarkLogoUrl != null) {
      lightLogoUrl.value = cachedLightLogoUrl;
      darkLogoUrl.value = cachedDarkLogoUrl;
    } else {
      lightLogoUrl.value = await _logoService.initializeLogo(tenantId, true);
      darkLogoUrl.value = await _logoService.initializeLogo(tenantId, false);

      // Cache the URLs for future use
      _logoService.saveLogoUrl(true, lightLogoUrl.value);
      _logoService.saveLogoUrl(false, darkLogoUrl.value);
    }
  }

  Future<void> setFavicon(String tenantId) async {
    faviconUrl.value = await _logoService.initializeFavicon(tenantId);
  }

  Future<void> _updateAspectRatio(String url) async {
    final Size size = await getImageDimension(url);
    aspectRatio.value = size.width / size.height;
  }

  Future<Size> getImageDimension(String url) async {
    final Completer<Size> completer = Completer();
    final Image image = Image.network(url);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          final Size size = Size(image.image.width.toDouble(), image.image.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }
}
