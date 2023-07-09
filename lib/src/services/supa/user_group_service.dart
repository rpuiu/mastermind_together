import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
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

  Future<T> _runQuery<T>(Future<T> Function() query) async {
    try {
      return await query();
    } catch (e, s) {
      print('$e $s');
      rethrow;
    }
  }

  Future<List<GroupModel>?> readAllGroups() async {
    return _runQuery(() async {
      final List<dynamic> data = await _client.from(groupsTable).select();
      if (data.isEmpty) {
        print("No groups available");
        return null;
      }
      return data.map((g) => GroupModel.fromJson(g)).toList();
    });
  }

  Future<void> createGroup(GroupModel groupModel) async {
    return _runQuery(() async {
      await _client.from(groupsTable).insert(groupModel.toJson());
    });
  }

  Future<void> joinGroup(String userId, String groupId) async {
    return _runQuery(() async {
      final groupResponse = await _client.from(groupsTable).select().eq(idField, groupId).single();

      if (!groupResponse.isEmpty) {
        final group = GroupModel.fromJson(groupResponse);

        if (isGroupFull(group)) {
          throw Exception('Group is already full.');
        }

        bool isAlreadyInGroup = await isAlreadyMember(userId, groupId);
        if (isAlreadyInGroup) {
          throw Exception('You are already a member of this group.');
        }
        await addUserToGroup(userId, groupId);
        await incrementGroupMembers(group, groupId);
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

  Future<void> addUserToGroup(String userId, String groupId) async {
    return _runQuery(() async {
      await _client.from(groupMembersTable).insert({userIdField: userId, groupIdField: groupId});
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

  Future<List<GroupModel>> getUserGroups(String userId) async {
    return _runQuery(() async {
      final List<dynamic> response = await _client.from(groupMembersTable).select('$groupIdField:$groupIdField (*)').eq(userIdField, userId);
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

  Future<List<GroupModel>> getGroupsByCategory(String category) async {
    return _runQuery(() async {
      List<dynamic> response = await _client.from(groupsTable).select().eq(categoryField, category);
      return response.map((group) => GroupModel.fromJson(group)).toList();
    });
  }

  void subscribeToGroupChanges(Function(String, GroupModel) onGroupChanges) {
    groupSubscription = _client.channel('public:groups').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', schema: 'public', table: groupsTable),
      (payload, [ref]) {
        print('Group change received: ${payload.toString()}');

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
}
