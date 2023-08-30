import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/services/log/logger_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserGroupService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  late RealtimeChannel groupSubscription;

  static const String groupsTable = 'groups';
  static const String groupMembersTable = 'group_members';
  static const String userIdField = 'user_id';
  static const String groupIdField = 'group_id';
  static const String currentMembersField = 'current_members';
  static const String idField = 'id';
  static const String categoryField = 'category';
  static const String tenantIdField = 'tenant_id';
  static const String createdByField = 'created_by';

  Future<T> _runQuery<T>(Future<T> Function() query) async {
    try {
      return await query();
    } catch (e, s) {
      Log().e("Error while executing query: $query:", e, s);
      rethrow;
    }
  }

  Future<List<GroupModel>?> readAllGroups(String tenantId) async {
    return _runQuery(() async {
      final List<dynamic> data = await _client.from(groupsTable).select().eq(tenantIdField, tenantId);
      if (data.isEmpty) {
        Log().d("No groups available for $tenantId");
        return null;
      }
      return data.map((g) => GroupModel.fromJson(g)).toList();
    });
  }

  Future<GroupModel> createGroup(GroupModel groupModel, UserModel user) async {
    return _runQuery(() async {
      List<Map<String, dynamic>> groupResponse = await _client.from(groupsTable).insert(
        {...groupModel.toJson(), tenantIdField: user.tenantId},
      ).select();
      if (groupResponse.isNotEmpty) {
        return GroupModel.fromJson(groupResponse[0]);
      } else {
        throw Exception('Error creating goal');
      }
    });
  }

  Future<GroupModel> joinGroup(UserModel user, String groupId) async {
    return _runQuery(() async {
      final groupResponse = await _client.from(groupsTable).select().eq(idField, groupId).single();

      if (!groupResponse.isEmpty) {
        final group = GroupModel.fromJson(groupResponse);

        if (isGroupFull(group)) {
          throw Exception('Group is already full.');
        }

        bool isAlreadyInGroup = await isAlreadyMember(user.id, groupId);
        if (isAlreadyInGroup) {
          throw Exception('You are already a member of this group.');
        }
        await addUserToGroup(user.id, groupId, user.tenantId);

        /*Race condition between checking if the group is full (isGroupFull(group))
        and incrementing the group members (incrementGroupMembers(group, groupId)). Use DB transactions when possible
         */
        await incrementGroupMembers(group, groupId);
        return group;
      } else {
        throw Exception('Group not found.');
      }
    });
  }

  Future<void> leaveGroup(String userId, String groupId) async {
    return _runQuery(() async {
      final groupResponse = await _client.from(groupsTable).select().eq(idField, groupId).single();

      if (!groupResponse.isEmpty) {
        final group = GroupModel.fromJson(groupResponse);

        bool isAlreadyInGroup = await isAlreadyMember(userId, groupId);
        if (!isAlreadyInGroup) {
          throw Exception('You are not a member of this group.');
        }

        await removeUserFromGroup(userId, groupId);
        await _decrementGroupMembers(group, groupId);
      } else {
        throw Exception('Group not found.');
      }
    });
  }

  Future<void> _decrementGroupMembers(GroupModel group, String groupId) async {
    return _runQuery(() async {
      await _client.from(groupsTable).update({
        currentMembersField: group.currentMembers - 1,
      }).eq(idField, groupId);
    });
  }

  Future<void> removeUserFromGroup(String userId, String groupId) async {
    return _runQuery(() async {
      await _client.from(groupMembersTable).delete().eq(userIdField, userId).eq(groupIdField, groupId);
    });
  }

  Future<void> incrementGroupMembers(GroupModel group, String groupId) async {
    return _runQuery(() async {
      await _client.from(groupsTable).update({
        currentMembersField: group.currentMembers + 1,
      }).eq(idField, groupId);
    });
  }

  Future<void> addUserToGroup(String userId, String groupId, String tenantId) async {
    return _runQuery(() async {
      await _client.from(groupMembersTable).insert({userIdField: userId, groupIdField: groupId, tenantIdField: tenantId});
    });
  }

  Future<bool> isAlreadyMember(String userId, String groupId) async {
    return _runQuery(() async {
      Map<String, dynamic>? membershipCheckResponse =
          await _client.from(groupMembersTable).select().eq(userIdField, userId).eq(groupIdField, groupId).maybeSingle();
      return membershipCheckResponse != null;
    });
  }

  bool isGroupFull(GroupModel group) => group.currentMembers >= group.maxMembers;

  Future<List<GroupModel>> getUserGroups(UserModel user) async {
    return _runQuery(() async {
      final List<dynamic> response =
          await _client.from(groupMembersTable).select('$groupIdField:$groupIdField (*)').eq(userIdField, user.id).eq(tenantIdField, user.tenantId);
      return response.map((group) => GroupModel.fromJson(group[groupIdField])).toList();
    });
  }

  Future<List<UserModel>> getGroupMembers(String groupId) async {
    return _runQuery(() async {
      final List<dynamic> data = await _client.from(groupMembersTable).select('users_extended:users_extended (*)').eq(groupIdField, groupId);
      return data.map((user) => UserModel.fromJson(user['users_extended'])).toList();
    });
  }

  Future<GroupModel> readGroup(String groupId) async {
    return _runQuery(() async {
      final groupResponse = await _client.from(groupsTable).select().eq(idField, groupId).single();
      return GroupModel.fromJson(groupResponse);
    });
  }

  Future<List<GroupModel>> getGroupsByCategory(String category, String tenantId) async {
    return _runQuery(() async {
      List<dynamic> response = await _client.from(groupsTable).select().eq(categoryField, category).eq(tenantIdField, tenantId);
      return response.map((group) => GroupModel.fromJson(group)).toList();
    });
  }

  void subscribeToGroupChanges(String tenantId, Function(String, GroupModel) onGroupChanges) {
    groupSubscription = _client.channel('public:groups:tenant_id=eq.$tenantId').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', schema: 'public', table: groupsTable, filter: 'tenant_id=eq.$tenantId'),
      (payload, [ref]) {
        Log().i('Group change received: ${payload.toString()}');

        GroupModel changedGroup = GroupModel.fromJson(payload['new']);

        switch (payload['eventType']) {
          case 'INSERT':
          case 'UPDATE':
          case 'DELETE':
            onGroupChanges(payload['eventType'], changedGroup);
            break;
          default:
            break;
        }
      },
    );

    groupSubscription.subscribe();
  }

  Future<void> unsubscribeFromGroupChanges() async {
    await _client.removeChannel(groupSubscription);
  }

  Future<int> getUserCreatedGroupCount(String userId) async {
    return _runQuery(() async {
      final res = await _client.from(groupsTable).select(createdByField, const FetchOptions(count: CountOption.exact)).eq(createdByField, userId);

      return res.count ?? 0;
    });
  }

  Future<int> getUserJoinedGroupCount(String userId) async {
    return _runQuery(() async {
      final res = await _client.from(groupMembersTable).select(userIdField, const FetchOptions(count: CountOption.exact)).eq(userIdField, userId);

      return res.count ?? 0;
    });
  }

  Future<void> updateGroupName(String groupId, String newName) async => _updateGroupField(groupId, {'name': newName});

  Future<void> updateGroupLocation(String groupId, String newLocation) async => _updateGroupField(groupId, {'location': newLocation});

  Future<void> updateMeetingUrl(String groupId, String newMeetingUrl) async => _updateGroupField(groupId, {'meeting_url': newMeetingUrl});

  Future<void> updateGroupDescription(String groupId, String newDescription) async => _updateGroupField(groupId, {'description': newDescription});

  Future<void> updateMeetingDetails(String groupId, String newDay, TimeOfDay newTimeUTC) async {
    await _updateGroupField(groupId, {
      'meeting_day': newDay,
      'meeting_time': '${newTimeUTC.hour}:${newTimeUTC.minute}',
    });
  }

  Future<void> _updateGroupField(String groupId, Map<String, dynamic> updateData) async {
    await _client.from(groupsTable).update(updateData).eq(idField, groupId);
  }
}
