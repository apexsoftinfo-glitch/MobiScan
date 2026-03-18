import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/features/documents/presentation/cubit/document_list_cubit.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockDocumentRepository documentRepository;

  setUp(() {
    documentRepository = MockDocumentRepository();
  });

  group('DocumentListCubit', () {
    const userId = 'user-1';
    final docs = [
      buildDocumentModel(id: 'doc-1', userId: userId, name: 'Scan 1'),
    ];

    blocTest<DocumentListCubit, DocumentListState>(
      'emits [loading, success] when watchDocuments succeeds',
      build: () {
        when(() => documentRepository.watchDocuments(userId))
            .thenAnswer((_) => Stream.value(docs));
        return DocumentListCubit(documentRepository);
      },
      act: (cubit) => cubit.loadDocuments(userId),
      expect: () => [
        const DocumentListState.loading(
          searchQuery: '',
          sortOrder: DocumentSortOrder.dateDesc,
        ),
        DocumentListState.success(
          documents: docs,
          searchQuery: '',
          sortOrder: DocumentSortOrder.dateDesc,
        ),
      ],
    );

    blocTest<DocumentListCubit, DocumentListState>(
      'emits [loading, error] when watchDocuments fails',
      build: () {
        when(() => documentRepository.watchDocuments(userId))
            .thenAnswer((_) => Stream.error(Exception('error')));
        return DocumentListCubit(documentRepository);
      },
      act: (cubit) => cubit.loadDocuments(userId),
      expect: () => [
        const DocumentListState.loading(
          searchQuery: '',
          sortOrder: DocumentSortOrder.dateDesc,
        ),
        const DocumentListState.error(
          errorKey: 'unknown_error',
          searchQuery: '',
          sortOrder: DocumentSortOrder.dateDesc,
        ),
      ],
    );
  });
}
