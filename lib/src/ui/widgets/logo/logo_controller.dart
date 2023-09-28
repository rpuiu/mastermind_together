import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/tenant/settings/logo_service.dart';
import 'package:mastermind_together/src/tenant/tenant_identifier.dart';

class LogoController extends GetxController {
  final TenantIdentifier _tenantIdentifier = Get.find<TenantIdentifier>();
  final LogoService _logoService = Get.find<LogoService>();
  final AuthService _authService = Get.find<AuthService>();

  RxString lightLogoUrl = ''.obs;
  RxString darkLogoUrl = ''.obs;
  RxString faviconUrl = ''.obs;

  RxDouble aspectRatio = 1.0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchLogo();
    await fetchFavicon();
  }

  Future<void> fetchLogo() async {
    String tenantId;
    if (_authService.getUser() == null) {
      tenantId = await _tenantIdentifier.getTenantId();
    } else {
      tenantId = _authService.getUser()!.tenantId;
    }
    lightLogoUrl.value = await _logoService.initializeLogo(tenantId, true);
    darkLogoUrl.value = await _logoService.initializeLogo(tenantId, false);
    _updateAspectRatio(lightLogoUrl.value);
    _updateAspectRatio(darkLogoUrl.value);
  }

  Future<void> fetchFavicon() async {
    String tenantId;
    if (_authService.getUser() == null) {
      tenantId = await _tenantIdentifier.getTenantId();
    } else {
      tenantId = _authService.getUser()!.tenantId;
    }

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
