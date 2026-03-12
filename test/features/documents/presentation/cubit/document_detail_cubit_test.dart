import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/features/documents/presentation/cubit/document_detail_cubit.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockDocumentRepository documentRepository;

  setUp(() {
    documentRepository = MockDocumentRepository();
  });

  group('DocumentDetailCubit', () {
    final docId = 'doc-1';
    final newName = 'New Name';

    blocTest<DocumentDetailCubit, DocumentDetailState>(
      'emits [loading, success] when renaming succeeds',
      build: () {
        when(() => documentRepository.updateDocumentName(id: docId, name: newName))
            .thenAnswer((_) async {});
        return DocumentDetailCubit(documentRepository);
      },
      act: (cubit) => cubit.renameDocument(id: docId, newName: newName),
      expect: () => [
        const DocumentDetailState.loading(),
        const DocumentDetailState.success(successKey: 'document_renamed'),
      ],
    );

    blocTest<DocumentDetailCubit, DocumentDetailState>(
      'emits [loading, success] when deleting succeeds',
      build: () {
        when(() => documentRepository.deleteDocument(docId))
            .thenAnswer((_) async {});
        return DocumentDetailCubit(documentRepository);
      },
      act: (cubit) => cubit.deleteDocument(docId),
      expect: () => [
        const DocumentDetailState.loading(),
        const DocumentDetailState.success(successKey: 'document_deleted'),
      ],
    );
  });
}
