import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/tenant/settings/tenant_logo_widget.dart';
import 'package:mastermind_together/src/tenant/settings/tenant_settings_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class TenantSettingsScreen extends GetView<TenantSettingsController> {
  const TenantSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenant Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(fontSize * 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Text('Light Logo', style: headingText),
                xSpace,
                Obx(() {
                  return TenantLogoWidget(
                    size: 160,
                    imageUrl: controller.signedLightLogoUrl.value,
                    onEdit: () => controller.pickLogo(true),
                    isLightLogo: true,
                  );
                }),
              ],
            ),
            wXXSpace,
            Column(
              children: [
                const Text('Dark Logo', style: headingText),
                xSpace,
                Obx(() {
                  return TenantLogoWidget(
                    size: 160,
                    imageUrl: controller.signedDarkLogoUrl.value,
                    onEdit: () => controller.pickLogo(false),
                  );
                }),
              ],
            ),
            wXXSpace,
            Column(
              children: [
                const Text('Favicon icon', style: headingText),
                xSpace,
                Obx(() {
                  return TenantLogoWidget(
                    size: 160,
                    imageUrl: controller.signedFaviconUrl.value,
                    onEdit: () => controller.pickFavicon(),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
