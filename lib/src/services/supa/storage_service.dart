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

  Future<String> createSignedUrl(String bucket, String path, {int expiryTime = 60}) async {
    final signedUrlResponse = await _client.storage.from(bucket).createSignedUrl(
          path,
          expiryTime,
        );

    return signedUrlResponse;
  }

  Future<String> upsertLogo(String tenantId, Uint8List logoFile, bool isLight) async {
    final String suffix = isLight ? 'light' : 'dark';
    final String path = await _client.storage.from('logos').uploadBinary(
          '$tenantId-logo-$suffix.png',
          logoFile,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: true,
          ),
        );
    return path;
  }

  Future<String> upsertFavicon(String tenantId, Uint8List faviconFile) async {
    final String path = await _client.storage.from('logos').uploadBinary(
      '$tenantId-favicon.ico',
      faviconFile,
      fileOptions: const FileOptions(
        cacheControl: '3600',
        upsert: true,
      ),
    );
    return path;
  }

  String getPublicUrl(String bucket, String trimmedPath) {
    return _client.storage.from(bucket).getPublicUrl(trimmedPath);
  }
}
