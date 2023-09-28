import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/ui/widgets/logo/logo_controller.dart';

class TenantLogo extends GetView<LogoController> {
  final double width;
  final double height;
  final double squareHeight;
  final bool isLight;

  const TenantLogo({
    super.key,
    required this.width,
    required this.height,
    required this.squareHeight,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final logoUrl = isLight ? controller.lightLogoUrl.value : controller.darkLogoUrl.value;
      if (logoUrl.isEmpty) {
        return const CircularProgressIndicator();
      }
      return FutureBuilder(
        future: controller.getImageDimension(logoUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Icon(Icons.error);
          }

          final Size size = snapshot.data as Size;
          final double aspectRatio = size.width / size.height;

          double width, height;

          if (aspectRatio > 1.2) {
            // Likely a rectangular logo (image + text)
            width = this.width;
            height = this.height;
          } else {
            // Likely a square logo (just image)
            width = squareHeight;
            height = squareHeight;
          }

          return CachedNetworkImage(
            imageUrl: logoUrl,
            width: width,
            height: height,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
        },
      );
    });
  }
}
