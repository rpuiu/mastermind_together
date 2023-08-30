import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/groups/chat/chat_widget.dart';
import 'package:mastermind_together/src/groups/group_controller.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/groups/join_group_button.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

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
            final group = groupSnapshot.data!;
            final bool isMember = controller.isUserMemberOfGroup(groupId);
            if (!isMember) {
              return _buildSharedGroupView(group);
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
                          return _buildMobileView(group, members);
                        } else {
                          return Column(
                            children: [
                              xxSpace,
                              _buildGroupInfo(group),
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

  Widget _buildSharedGroupView(GroupModel group) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: oneColContentWidth),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGroupInfo(group),
            xSpace,
            JoinGroupButton(groupId: group.id),
          ],
        ),
      ),
    );
  }

  DefaultTabController _buildMobileView(GroupModel group, List<UserModel> members) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _buildGroupInfo(group),
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
                _membersList(members),
                ChatWidget(groupId: groupId),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _membersList(List<UserModel> members) {
    return ListView(
      children: members
          .map((member) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    const Icon(Icons.person, size: 24.0),
                    const SizedBox(width: 2),
                    Text(member.username, style: labelText),
                  ],
                ),
              ))
          .toList(),
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
                child: _membersList(members),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupInfo(GroupModel group) {
    return Card(
      elevation: 1.0,
      shape: customBorder,
      child: Padding(
        padding: const EdgeInsets.all(fontSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(group.name, style: headingText),
            halfSpace,
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: const BoxDecoration(color: categoryBgColor),
                child: Text(group.category, style: labelText),
              ),
            ),
            xSpace,
            Text(
              '${group.meetingDay}: ${group.meetingTimeLocal.hour}:${group.meetingTimeLocal.minute}',
              style: bodyRegular,
            ),
            xSpace,
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: 'Meeting URL: ', style: bodyRegular),
                  TextSpan(
                    text: group.meetingUrl,
                    style: bodyRegular.copyWith(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.launchMeetingUrl(group);
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
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
