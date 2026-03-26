import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DocumentDataSource {
  Stream<List<Map<String, dynamic>>> watchDocuments(String userId);
  Stream<List<Map<String, dynamic>>> watchPages(String documentId);
  Future<Map<String, dynamic>> createDocument(Map<String, dynamic> document);
  Future<void> updateDocument(String id, Map<String, dynamic> document);
  Future<void> deleteDocument(String id);
  Future<void> addPage(Map<String, dynamic> page);
  Future<void> deletePage(String id);
  Future<List<Map<String, dynamic>>> getDocuments(String userId);
  Future<List<Map<String, dynamic>>> getPages(String documentId);
}

@LazySingleton(as: DocumentDataSource)
class SupabaseDocumentDataSource implements DocumentDataSource {
  SupabaseDocumentDataSource(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Stream<List<Map<String, dynamic>>> watchDocuments(String userId) {
    return _supabaseClient
        .from('mobiscan_documents')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }

  @override
  Stream<List<Map<String, dynamic>>> watchPages(String documentId) {
    return _supabaseClient
        .from('mobiscan_pages')
        .stream(primaryKey: ['id'])
        .eq('document_id', documentId)
        .order('page_index', ascending: true);
  }

  @override
  Future<Map<String, dynamic>> createDocument(Map<String, dynamic> document) async {
    final response = await _supabaseClient
        .from('mobiscan_documents')
        .insert(document)
        .select()
        .single();
    return response;
  }

  @override
  Future<void> updateDocument(String id, Map<String, dynamic> document) async {
    await _supabaseClient.from('mobiscan_documents').update(document).eq('id', id);
  }

  @override
  Future<void> deleteDocument(String id) async {
    await _supabaseClient.from('mobiscan_documents').delete().eq('id', id);
  }

  @override
  Future<void> addPage(Map<String, dynamic> page) async {
    await _supabaseClient.from('mobiscan_pages').insert(page);
  }

  @override
  Future<void> deletePage(String id) async {
    await _supabaseClient.from('mobiscan_pages').delete().eq('id', id);
  }

  @override
  Future<List<Map<String, dynamic>>> getDocuments(String userId) async {
    final response = await _supabaseClient
        .from('mobiscan_documents')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getPages(String documentId) async {
    final response = await _supabaseClient
        .from('mobiscan_pages')
        .select()
        .eq('document_id', documentId)
        .order('page_index', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }
}
