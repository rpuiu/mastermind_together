import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';

class TenantLogoWidget extends StatelessWidget {
  final double size;
  final String? imageUrl;
  final VoidCallback onEdit;
  final bool isLightLogo;

  const TenantLogoWidget({
    Key? key,
    this.size = 100.0,
    this.imageUrl,
    required this.onEdit,
    this.isLightLogo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String logoPath = imageUrl ?? '';

    return Column(
      children: [
        Card(
          color: isLightLogo ? drawerBgColor : whiteColor,
          shape: customBorder,
          child: logoPath.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(fontSize / 2),
                  child: CachedNetworkImage(
                    imageUrl: logoPath,
                    width: size,
                    height: size,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                )
              : Icon(Icons.image, size: size, color: isLightLogo ? whiteColor : drawerBgColor),
        ),
        xxSpace,
        SizedBox(
          width: size,
          child: CustomButton(
            label: 'Upload',
            labelTextStyle: buttonTextStyle,
            backgroundColor: buttonBackgroundColor,
            onPressed: onEdit,
          ),
        ),
      ],
    );
  }
}
