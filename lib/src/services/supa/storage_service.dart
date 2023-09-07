import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService extends GetxService {
  final SupabaseClient _client = Get.find<SupabaseClient>();

  Future<String> upsertAvatar(UserModel user, Uint8List avatarFile) async {
    final String path = await _client.storage.from('avatars').uploadBinary(
          '${user.tenantId}/${user.id}-avatar.png',
          avatarFile,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: true,
          ),
        );
    return path;
  }

  Future<String> createSignedUrl(String path, {int expiryTime = 60}) async {
    final signedUrlResponse = await _client.storage.from('avatars').createSignedUrl(
          path,
          expiryTime,
        );

    return signedUrlResponse;
  }
}
