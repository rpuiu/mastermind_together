import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/availability/availability_controller.dart';
import 'package:mastermind_together/src/availability/set_availability_widget.dart';
import 'package:mastermind_together/src/ui/theme/layout/custom_layout.dart';
import 'package:mastermind_together/src/ui/theme/layout/scrollable_layout.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class SetAvailabilityScreen extends GetView<AvailabilityController> {
  const SetAvailabilityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? CustomLayout(content: _buildColumnWithContent(_buildLoadingState(context)))
          : ScrollableCustomLayout(content: _buildColumnWithContent(const SetAvailabilityWidget())),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Column _buildColumnWithContent(Widget content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        xHalfSpace,
        const Text("Set Your Availability", style: headingText),
        halfSpace,
        const Text("We'll find groups that match your goal and fit your schedule.", style: bodyRegular),
        xxSpace,
        content,
      ],
    );
  }
}
