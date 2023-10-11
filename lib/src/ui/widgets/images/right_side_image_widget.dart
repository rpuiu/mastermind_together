import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/splash/img_precache_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';

class RightSideImage extends StatelessWidget {
  const RightSideImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ImagePrecacheController controller = Get.find();

    return Padding(
      padding: const EdgeInsets.all(2 * fontSize),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(
            image: AssetImage(controller.randomImagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
