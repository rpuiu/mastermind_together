import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/groups/chat/chat_widget.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/groups/shared_group_screen.dart';
import 'package:mastermind_together/src/groups/widgets/group_info_widget.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

import 'widgets/member_list_widget.dart';

class GroupScreen extends GetView<GroupController> {
  final String groupId = Get.parameters['groupId']!;

  GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: FutureBuilder<GroupModel>(
        future: controller.fetchGroup(groupId),
        builder: (context, groupSnapshot) {
          if (groupSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (groupSnapshot.hasError) {
            return Center(child: Text('Error: ${groupSnapshot.error}'));
          } else {
            final group = controller.group.value;
            final bool isMember = controller.isUserMemberOfGroup(groupId);
            if (!isMember) {
              return SharedGroupScreen(group: group);
            } else {
              return FutureBuilder<List<UserModel>>(
                future: controller.fetchGroupMembers(groupId),
                builder: (context, membersSnapshot) {
                  if (membersSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (membersSnapshot.hasError) {
                    return Center(child: Text('Error: ${membersSnapshot.error}'));
                  } else {
                    final members = membersSnapshot.data!;
                    return LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        if (constraints.maxWidth < 600) {
                          return _buildMobileView(context, group, members);
                        } else {
                          return Column(
                            children: [
                              xxSpace,
                              const GroupInfoCard(),
                              xxxSpace,
                              Expanded(
                                child: Row(
                                  children: [
                                    _buildMembersWidget(group, members),
                                    _buildChatWidget(),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    );
                  }
                },
              );
            }
          }
        },
      ),
    );
  }

  DefaultTabController _buildMobileView(BuildContext context, GroupModel group, List<UserModel> members) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const GroupInfoCard(),
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

  Expanded _buildChatWidget() {
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
