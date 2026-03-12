import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/document_model.dart';
import '../datasources/document_data_source.dart';

abstract class DocumentRepository {
  Stream<List<DocumentModel>> watchDocuments(String userId);
  Future<DocumentModel> createDocument({required String userId, required String name});
  Future<void> updateDocumentName({required String id, required String name});
  Future<void> deleteDocument(String id);
  Future<void> addPage({
    required String documentId,
    required String storagePath,
    required int pageIndex,
  });
  Future<void> deletePage(String id);
}

@LazySingleton(as: DocumentRepository)
class DocumentRepositoryImpl implements DocumentRepository {
  DocumentRepositoryImpl(this._dataSource);

  final DocumentDataSource _dataSource;

  @override
  Stream<List<DocumentModel>> watchDocuments(String userId) {
    return _dataSource.watchDocuments(userId).switchMap((docs) {
      if (docs.isEmpty) return Stream.value([]);

      final docStreams = docs.map((doc) {
        final docId = doc['id'] as String;
        return _dataSource.watchPages(docId).map((pages) {
          return DocumentModel.fromJson({
            ...doc,
            'pages': pages,
          });
        });
      }).toList();

      return CombineLatestStream.list<DocumentModel>(docStreams);
    });
  }

  @override
  Future<DocumentModel> createDocument({required String userId, required String name}) async {
    final raw = await _dataSource.createDocument({
      'user_id': userId,
      'name': name,
    });
    return DocumentModel.fromJson(raw);
  }

  @override
  Future<void> updateDocumentName({required String id, required String name}) async {
    await _dataSource.updateDocument(id, {'name': name});
  }

  @override
  Future<void> deleteDocument(String id) async {
    await _dataSource.deleteDocument(id);
  }

  @override
  Future<void> addPage({
    required String documentId,
    required String storagePath,
    required int pageIndex,
  }) async {
    await _dataSource.addPage({
      'document_id': documentId,
      'storage_path': storagePath,
      'page_index': pageIndex,
    });
  }

  @override
  Future<void> deletePage(String id) async {
    await _dataSource.deletePage(id);
  }
}
