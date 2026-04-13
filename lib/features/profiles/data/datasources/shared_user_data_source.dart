import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SharedUserDataSource {
  Stream<Map<String, dynamic>?> watchSharedUser(String userId);

  Future<Map<String, dynamic>?> getSharedUser(String userId);

  Future<void> upsertSharedUser(Map<String, dynamic> sharedUser);

  Future<Map<String, dynamic>> ensureSharedUser(String userId);
}

@LazySingleton(as: SharedUserDataSource)
class SupabaseSharedUserDataSource implements SharedUserDataSource {
  SupabaseSharedUserDataSource(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Stream<Map<String, dynamic>?> watchSharedUser(String userId) {
    debugPrint(
      'ℹ️ [SharedUserDataSource] watchSharedUser subscribed userId=$userId',
    );
    int emptyRetryCount = 0;

    return _supabaseClient
        .from('shared_users')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .asyncExpand((rows) async* {
          debugPrint(
            'ℹ️ [SharedUserDataSource] watchSharedUser rows userId=$userId count=${rows.length}',
          );
          if (rows.isEmpty) {
            emptyRetryCount++;
            if (emptyRetryCount > 3) {
              debugPrint(
                '❌ [SharedUserDataSource] watchSharedUser empty too many times, possible RLS issue. Giving up on ensuring row.',
              );
              yield null;
              return;
            }

            debugPrint(
              '⚠️ [SharedUserDataSource] shared user missing (attempt $emptyRetryCount); ensuring shell row userId=$userId',
            );
            
            try {
              final ensuredSharedUser = await ensureSharedUser(userId);
              debugPrint(
                '✅ [SharedUserDataSource] ensured shared user userId=$userId firstName=${ensuredSharedUser['first_name'] ?? "-"}',
              );
              yield ensuredSharedUser;
            } catch (e) {
              debugPrint('❌ [SharedUserDataSource] failed to ensure shared user: $e');
              // Propagate error to trigger retry at repository level
              rethrow;
            }
            return;
          }

          emptyRetryCount = 0; // Reset on success
          final sharedUser = Map<String, dynamic>.from(rows.first);
          debugPrint(
            'ℹ️ [SharedUserDataSource] shared user received userId=$userId firstName=${sharedUser['first_name'] ?? "-"}',
          );
          yield sharedUser;
        });
  }

  @override
  Future<Map<String, dynamic>?> getSharedUser(String userId) async {
    debugPrint(
      'ℹ️ [SharedUserDataSource] getSharedUser started userId=$userId',
    );
    final response = await _supabaseClient
        .from('shared_users')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      debugPrint(
        '⚠️ [SharedUserDataSource] getSharedUser userId=$userId not found',
      );
      return null;
    }
    debugPrint('✅ [SharedUserDataSource] getSharedUser userId=$userId found');
    return Map<String, dynamic>.from(response);
  }

  @override
  Future<void> upsertSharedUser(Map<String, dynamic> sharedUser) async {
    debugPrint(
      'ℹ️ [SharedUserDataSource] upsertSharedUser started userId=${sharedUser['id']}',
    );
    await _supabaseClient.from('shared_users').upsert(sharedUser);
    debugPrint(
      '✅ [SharedUserDataSource] upsertSharedUser succeeded userId=${sharedUser['id']}',
    );
  }

  @override
  Future<Map<String, dynamic>> ensureSharedUser(String userId) async {
    debugPrint(
      'ℹ️ [SharedUserDataSource] ensureSharedUser started userId=$userId',
    );
    final existingSharedUser = await getSharedUser(userId);
    if (existingSharedUser != null) {
      debugPrint(
        'ℹ️ [SharedUserDataSource] ensureSharedUser existing row reused userId=$userId',
      );
      return existingSharedUser;
    }

    final shellSharedUser = <String, dynamic>{'id': userId, 'first_name': null};

    await upsertSharedUser(shellSharedUser);
    debugPrint(
      '✅ [SharedUserDataSource] ensureSharedUser created shell row userId=$userId',
    );
    return shellSharedUser;
  }
}
