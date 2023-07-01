import 'package:get/get.dart';
import 'package:mastermind_together/src/groups/group_model.dart';
import 'package:mastermind_together/src/user/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserGroupService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  Future<List<GroupModel>?> readAllGroups() async {
    final List<dynamic> data = await _client.from('groups').select();

    if (data.isEmpty) {
      print("No groups available");
      return null;
    }
    List<GroupModel> groups = data.map((g) => GroupModel.fromJson(g)).toList();
    return groups;
  }

  Future<void> createGroup(GroupModel groupModel) async {
    final response = await _client.from('groups').insert(groupModel.toJson());

    // if (response.error != null) {
    //   print('Error creating group: ${response.error!.message}');
    // }
  }

  Future<void> joinGroup(String userId, String groupId) async {
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
  }

  Future<void> incrementGroupMembers(GroupModel group, String groupId) async {
    await _client.from('groups').update({
      'current_members': group.currentMembers + 1,
    }).eq('id', groupId);
  }

  Future<void> addUserToGroup(String userId, String groupId) async {
    final response = await _client.from('group_members').insert({
      'user_id': userId,
      'group_id': groupId,
    });
  }

  Future<bool> isAlreadyMember(String userId, String groupId) async {
    Map<String, dynamic>? membershipCheckResponse = await _client.from('group_members').select().eq('user_id', userId).eq('group_id', groupId).maybeSingle();
    return membershipCheckResponse != null;
  }

  bool isGroupFull(GroupModel group) => group.currentMembers >= group.maxMembers;

  Future<void> leaveGroup(String userId, String groupId) async {
    final response = await _client.from('group_members').delete().eq('user_id', userId).eq('group_id', groupId);

    // if (response.error != null) {
    //   throw Exception('Failed to leave group: ${response.error!.message}');
    // }
  }

  Future<List<GroupModel>> getUserGroups(String userId) async {
    final response = await _client.from('group_members').select('group_id').eq('user_id', userId).execute();

    // if (response.error != null) {
    //   throw Exception('Failed to get user groups: ${response.error!.message}');
    // }

    return (response.data as List).map((group) => GroupModel.fromJson(group)).toList();
  }

  Future<List<UserModel>> getGroupMembers(String groupId) async {
    final response = await _client.from('group_members').select('user_id').eq('group_id', groupId);

    // if (response.error != null) {
    //   throw Exception('Failed to get group members: ${response.error!.message}');
    // }

    return (response.data as List).map((user) => UserModel.fromJson(user)).toList();
  }

  Future<GroupModel> readGroup(String groupId) async {
    final groupResponse = await _client.from('groups').select().eq('id', groupId).single();
    return GroupModel.fromJson(groupResponse);
  }
}
