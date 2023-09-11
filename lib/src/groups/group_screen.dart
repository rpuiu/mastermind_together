import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/groups/chat/chat_widget.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/groups/group_screen_controller.dart';
import 'package:mastermind_together/src/groups/members_controller.dart';
import 'package:mastermind_together/src/groups/shared_group_screen.dart';
import 'package:mastermind_together/src/groups/widgets/group_info_widget.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

import 'widgets/member_list_widget.dart';

class GroupScreen extends StatelessWidget {
  final String groupId = Get.parameters['groupId']!;

  GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GroupScreenController controller = Get.find(tag: groupId);
    final MembersController membersController = Get.find<MembersController>();

    return CustomScaffold(
      body: Obx(() {
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
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                return _buildMobileView(context, controller, group, members);
              } else {
                return Column(
                  children: [
                    xxSpace,
                    GroupInfoCard(group: group, controller: controller),
                    xxxSpace,
                    Expanded(
                      child: Row(
                        children: [
                          _buildMembersWidget(group, members),
                          _buildChatWidget(groupId),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          );
        }
      }),
    );
  }

  DefaultTabController _buildMobileView(BuildContext context, GroupScreenController controller, GroupModel group, List<UserModel> members) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          GroupInfoCard(group: group, controller: controller),
          xxSpace,
          const TabBar(
            tabs: [
              Tab(text: 'Members'),
              Tab(text: 'Chat'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                MemberList(members: members, adminId: group.admin),
                ChatWidget(groupId: groupId),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersWidget(GroupModel group, List<UserModel> members) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: fontSize),
            child: Text(
              'Members: ${group.currentMembers} / ${group.maxMembers}',
              style: labelText.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Card(
              color: hoverMenuTextColor,
              shape: customBorder,
              child: Padding(
                padding: const EdgeInsets.all(fontSize),
                child: MemberList(members: members, adminId: group.admin),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildChatWidget(String groupId) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chat',
            style: labelText.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ChatWidget(groupId: groupId),
          ),
        ],
      ),
    );
  }
}
