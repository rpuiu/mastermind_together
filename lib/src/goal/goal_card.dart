import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/goal/actions/actions_controller.dart';
import 'package:mastermind_together/src/goal/actions/actions_modal.dart';
import 'package:mastermind_together/src/goal/actions/add_action_modal_widget.dart';
import 'package:mastermind_together/src/goal/goal_model.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/custom_tooltip.dart';
import 'package:mastermind_together/src/ui/widgets/label_categ_widget.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final int index;

  final ActionController _actionController;

  GoalCard({
    Key? key,
    required this.goal,
    required this.index,
  })  : _actionController = ActionController(goal.id),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(Routes.goalRoute(goal.id)),
      customBorder: customBorder,
      child: Card(
        elevation: 1,
        shape: customBorder,
        child: Container(
          padding: const EdgeInsets.only(
            top: 1.5 * fontSize,
            left: fontSize,
            right: fontSize,
            bottom: fontSize,
          ),
          width: goalCardWidth,
          height: goalCardHeight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LabelCategoryWidget(label: goal.category),
                        // IconButton( TODO MAIN-T-118 - Share goal
                        //     icon: AppIcons.getIcon('share', IconState.hoverState),
                        //     onPressed: () {
                        //       //share goal!
                        //     }),
                      ],
                    ),
                    halfSpace,
                    CustomTooltip(
                      message: goal.goal,
                      child: Text(goal.goal, maxLines: 2, style: bodySemiBold, overflow: TextOverflow.ellipsis),
                    ),
                    xSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          // int allActions = _actionController.actions.length;
                          // int completedActions = _actionController.actions.length;
                          if (_actionController.actions.isNotEmpty) {
                            final firstAction = _actionController.actions.first;
                            return Flexible(
                              child: CustomTooltip(
                                message: firstAction.description,
                                child: Text(
                                  'Priority: ${firstAction.description}',
                                  style: bodyRegular,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }
                          return TextButton(
                            onPressed: () {
                              AddActionModalWidget.show(context, _actionController, goal.id);
                            },
                            child: const Text('Add Action'),
                          );
                        }),
                        wHalfSpace,
                        IconButton(
                          icon: AppIcons.getIcon('note-2', IconState.hoverState),
                          onPressed: () {
                            ActionsModal.show(context, goal.id, _actionController);
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    // const Text('10% Completed'), TODO MAIN-T-119 - Goal progress
                    // halfSpace,
                    // const LinearProgressIndicator(
                    //   value: 10 / 100,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
