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
  Future<List<DocumentModel>> getDocuments(String userId);
}

@LazySingleton(as: DocumentRepository)
class DocumentRepositoryImpl implements DocumentRepository {
  DocumentRepositoryImpl(this._dataSource);

  final DocumentDataSource _dataSource;
  final BehaviorSubject<List<DocumentModel>> _documentsSubject = BehaviorSubject();
  List<DocumentModel> _lastDocuments = [];

  @override
  Stream<List<DocumentModel>> watchDocuments(String userId) {
    // Optimized stream join: One stream for all documents, one for all pages.
    final rawStream = CombineLatestStream.combine2<List<Map<String, dynamic>>,
        List<Map<String, dynamic>>, List<DocumentModel>>(
      _dataSource.watchDocuments(userId),
      _dataSource.watchAllPages(),
      (docs, allPages) {
        return docs.map((doc) {
          final docId = doc['id'] as String;
          final pages = allPages
              .where((p) => p['document_id'] == docId)
              .toList();
          
          return DocumentModel.fromJson({
            ...doc,
            'pages': pages,
          });
        }).toList();
      },
    );

    // Pipe results to our subject for repository-wide state
    rawStream.listen((docs) {
      _lastDocuments = docs;
      _documentsSubject.add(docs);
    });

    return _documentsSubject.stream;
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
    final trimmedName = name.trim();
    // 1. Optimistic update at repository level: change local cache and emit immediately
    _lastDocuments = _lastDocuments.map((doc) {
      if (doc.id == id) return doc.copyWith(name: trimmedName);
      return doc;
    }).toList();
    _documentsSubject.add(_lastDocuments);

    // 2. Perform the actual update on the server
    await _dataSource.updateDocument(id, {'name': trimmedName});
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

  @override
  Future<List<DocumentModel>> getDocuments(String userId) async {
    final rawDocs = await _dataSource.getDocuments(userId);
    final documents = <DocumentModel>[];

    for (final rawDoc in rawDocs) {
      final docId = rawDoc['id'] as String;
      final rawPages = await _dataSource.getPages(docId);
      documents.add(DocumentModel.fromJson({
        ...rawDoc,
        'pages': rawPages,
      }));
    }

    return documents;
  }
}
