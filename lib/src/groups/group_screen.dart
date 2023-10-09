import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/groups/chat/chat_widget.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/groups/group_screen_controller.dart';
import 'package:mastermind_together/src/groups/members_controller.dart';
import 'package:mastermind_together/src/groups/shared_group_screen.dart';
import 'package:mastermind_together/src/groups/widgets/group_info_widget.dart';
import 'package:mastermind_together/src/ui/theme/layout/custom_layout.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/tabs/custom_tab.dart';
import 'package:mastermind_together/src/ui/widgets/tabs/tab_controller.dart';

import 'widgets/member_list_widget.dart';

class GroupScreen extends StatelessWidget {
  final String groupId = Get.parameters['groupId']!;

  GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GroupScreenController controller = Get.find(tag: groupId);
    final MembersController membersController = Get.find<MembersController>();
    final TabsController tabController = Get.put(TabsController());

    return CustomLayout(
      content: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final group = controller.group.value;
        final members = controller.members.value;

        if (group == GroupModel.empty() || members == List<UserModel>.empty()) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool isMember = membersController.isUserMemberOfGroup(group.id);
        if (!isMember) {
          return SharedGroupScreen(group: group);
        } else {
          return Column(
            children: [
              GroupInfoCard(group: group, controller: controller),
              xxSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTab(0, 'Members: (${group.currentMembers} / ${group.maxMembers})'),
                  wHalfSpace,
                  const CustomTab(1, 'Chat'),
                ],
              ),
              Expanded(
                child: Obx(() {
                  return IndexedStack(
                    index: tabController.tabIndex.value,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(fontSize),
                        child: MemberList(members: members, adminId: group.admin),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(fontSize),
                        child: ChatWidget(groupId: groupId),
                      ),
                    ],
                  );
                }),
              ),
            ],
          );
        }
      }),
    );
  }
}
