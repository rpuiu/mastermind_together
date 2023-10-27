import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/tenant/tenant_identifier.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/logo/logo_controller.dart';
import 'package:mastermind_together/src/ui/widgets/logo/tenant_logo.dart';

class CommonAuthLayout extends GetView<LogoController> {
  final TenantIdentifier _tenantIdentifier = Get.find<TenantIdentifier>();

  final Widget form;

  CommonAuthLayout({required this.form, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        SizedBox topPadding = (controller.aspectRatio.value > 1.2) ? xxxSpace : const SizedBox(height: 0);

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(2 * fontSize),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          topPadding,
                          const TenantLogo(width: 308, height: 30, squareHeight: 160, isLight: false),
                          xxxSpace,
                          form,
                          xSpace,
                          Obx(() {
                            return Text(
                              '© 2023 ALL RIGHTS RESERVED ${_tenantIdentifier.tenant.value.name.toUpperCase()}',
                              textAlign: TextAlign.center,
                              style: copyrightTextStyle,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
