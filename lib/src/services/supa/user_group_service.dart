import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserGroupService {
  final SupabaseClient _client = Get.find<SupabaseClient>();
  late RealtimeChannel groupSubscription;

  Future<List<GroupModel>?> readAllGroups() async {
    try {
      final List<dynamic> data = await _client.from('groups').select();

      if (data.isEmpty) {
        print("No groups available");
        return null;
      }
      List<GroupModel> groups = data.map((g) => GroupModel.fromJson(g)).toList();
      return groups;
    } catch (e, s) {
      print('$e $s');;
      rethrow;
    }
  }

  Future<void> createGroup(GroupModel groupModel) async {
    try {
      await _client.from('groups').insert(groupModel.toJson());
    } catch (e, s) {
      print('$e $s');;
      rethrow;
    }
  }

  Future<void> joinGroup(String userId, String groupId) async {
    try {
      final groupResponse = await _client.from('groups').select().eq('id', groupId).single();

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
    } catch (e, s) {
      print('$e $s');;
      rethrow;
    }
  }

  Future<void> leaveGroup(String userId, String groupId) async {
    try {
      final groupResponse = await _client.from('groups').select().eq('id', groupId).single();

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
    } catch (e, s) {
      print('$e $s');;
      rethrow;
    }
  }

  Future<void> _decrementGroupMembers(GroupModel group, String groupId) async {
    try {
      await _client.from('groups').update({
        'current_members': group.currentMembers - 1,
      }).eq('id', groupId);
    } catch (e, s) {
      print('$e $s');;
      rethrow;
    }
  }

  Future<void> removeUserFromGroup(String userId, String groupId) async {
    try {
      await _client.from('group_members').delete().eq('user_id', userId).eq('group_id', groupId);
    } catch (e, s) {
      print('$e $s');;
      rethrow;
    }
  }

  Future<void> incrementGroupMembers(GroupModel group, String groupId) async {
    try {
      await _client.from('groups').update({
        'current_members': group.currentMembers + 1,
      }).eq('id', groupId);
    } catch (e, s) {
      print('$e $s');;
      rethrow;
    }
  }

  Future<void> addUserToGroup(String userId, String groupId) async {
    try {
      await _client.from('group_members').insert({'user_id': userId, 'group_id': groupId});
    } catch (e, s) {
      print('$e $s');;
      rethrow;
    }
  }

  Future<bool> isAlreadyMember(String userId, String groupId) async {
    try {
      Map<String, dynamic>? membershipCheckResponse = await _client.from('group_members').select().eq('user_id', userId).eq('group_id', groupId).maybeSingle();
      return membershipCheckResponse != null;
    } catch (e, s) {
      print('$e $s');;
      rethrow;
    }
  }

  bool isGroupFull(GroupModel group) => group.currentMembers >= group.maxMembers;

  Future<List<GroupModel>> getUserGroups(String userId) async {
    try {
      final List<dynamic> response = await _client.from('group_members').select('group_id:group_id (*)').eq('user_id', userId);
      return response.map((group) => GroupModel.fromJson(group['group_id'])).toList();
    } catch (e, s) {
      print('$e $s');;
      rethrow;
    }
  }

  Future<List<UserModel>> getGroupMembers(String groupId) async {
    try {
      final List<dynamic> data = await _client.from('group_members').select('users_extended:users_extended (*)').eq('group_id', groupId);
      return data.map((user) => UserModel.fromJson(user['users_extended'])).toList();
    } catch (e, s) {
      print('$e $s');;
      rethrow;
    }
  }

  Future<GroupModel> readGroup(String groupId) async {
    try {
      final groupResponse = await _client.from('groups').select().eq('id', groupId).single();
      return GroupModel.fromJson(groupResponse);
    } catch (e, s) {
      print('$e $s');;
      rethrow;
    }
  }

  Future<List<GroupModel>> getGroupsByCategory(String category) async {
    try {
      List<dynamic> response = await _client.from('groups').select().eq('category', category);
      return response.map((group) => GroupModel.fromJson(group)).toList();
    } catch (e, s) {
      print('$e $s');;
      rethrow;
    }
  }

// void subscribeToGroupChanges(Function(GroupModel) onGroupChanges) { //TODO MAIN-T-19
//   groupSubscription = _client.channel('public:groups').on(
//     RealtimeListenTypes.postgresChanges,
//     ChannelFilter(event: '*', schema: 'public', table: 'groups'),
//     (payload, [ref]) {
//       print('Group change received: ${payload.toString()}');
//       onGroupChanges(GroupModel.fromJson(payload["new"]));
//     },
//   );
//
//   groupSubscription.subscribe();
// }
//
// Future<void> unsubscribeFromGroupChanges() async {
//   await _client.removeChannel(groupSubscription);
// }
}
