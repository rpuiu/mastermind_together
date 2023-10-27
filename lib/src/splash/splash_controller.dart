import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/splash/image_service.dart';
import 'package:mastermind_together/src/splash/img_precache_controller.dart';
import 'package:mastermind_together/src/tenant/tenant_identifier.dart';
import 'package:mastermind_together/src/ui/widgets/logo/logo_controller.dart';

class SplashController extends GetxController {
  final TenantIdentifier tenantIdentifier = Get.find<TenantIdentifier>();
  final ImagePrecacheController imagePrecacheController = Get.find<ImagePrecacheController>();
  final LogoController logoController = Get.find<LogoController>();
  final ImageService _imageService = Get.put(ImageService());
  final AuthService _authService = Get.find<AuthService>();

  final RxBool dataLoaded = false.obs;

  BuildContext? _context;

  Future<void> setContext(BuildContext context) async {
    _context = context;
    await initializeData();
    dataLoaded.value = true;
  }

  Future<void> initializeData() async {
    try {
      if (_context == null) throw Exception('Context is not set');
      await tenantIdentifier.initialize();

      await logoController.setLogo(tenantIdentifier.tenant.value.tenantId);
      await logoController.setFavicon(tenantIdentifier.tenant.value.tenantId);

      await _imageService.cacheImage(_context!, logoController.lightLogoUrl.value);
      await _imageService.cacheImage(_context!, logoController.darkLogoUrl.value);
      await _imageService.cacheImage(_context!, logoController.faviconUrl.value);

      await imagePrecacheController.loadImages(_context!);
      dataLoaded.value = true;
    } catch (e) {
      print('Error during initialization: $e');
    }
  }

  void redirect() {
    final session = _authService.currentSession;
    if (session != null) {
      Get.offNamed(Routes.home);
    } else {
      Get.offNamed(Routes.login);
    }
  }
}
