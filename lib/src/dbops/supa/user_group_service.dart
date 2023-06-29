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
    final response = await _client.from('group_members').insert({
      'user_id': userId,
      'group_id': groupId,
    });

    // if (response.error != null) {
    //   throw Exception('Failed to join group: ${response.error!.message}');
    // }
  }

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
}
