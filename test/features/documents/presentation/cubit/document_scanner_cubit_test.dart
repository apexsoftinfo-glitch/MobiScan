import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/features/documents/presentation/cubit/document_scanner_cubit.dart';
import 'package:myapp/features/documents/data/services/document_scanner_service.dart';

import '../../../../support/mocks.dart';

class MockDocumentScannerService extends Mock implements DocumentScannerService {}

void main() {
  late MockDocumentRepository documentRepository;
  late MockDocumentScannerService scannerService;

  setUp(() {
    documentRepository = MockDocumentRepository();
    scannerService = MockDocumentScannerService();
  });

  group('DocumentScannerCubit', () {
    final userId = 'user-1';
    final images = ['path/to/img1.jpg', 'path/to/img2.jpg'];
    final doc = buildDocumentModel(id: 'doc-1', userId: userId, name: 'Scan 2026-03-12');

    blocTest<DocumentScannerCubit, DocumentScannerState>(
      'emits [scanning, saving, success] when scanning and saving succeeds',
      build: () {
        when(() => scannerService.getPictures()).thenAnswer((_) async => images);
        when(() => documentRepository.createDocument(
              userId: any(named: 'userId'),
              name: any(named: 'name'),
            )).thenAnswer((_) async => doc);
        when(() => documentRepository.addPage(
              documentId: any(named: 'documentId'),
              storagePath: any(named: 'storagePath'),
              pageIndex: any(named: 'pageIndex'),
            )).thenAnswer((_) async {});
        return DocumentScannerCubit(documentRepository, scannerService);
      },
      act: (cubit) => cubit.startScan(userId),
      expect: () => [
        const DocumentScannerState.scanning(),
        const DocumentScannerState.saving(),
        DocumentScannerState.success(documentId: doc.id),
      ],
    );

    blocTest<DocumentScannerCubit, DocumentScannerState>(
      'emits [scanning, initial] when user cancels scanning',
      build: () {
        when(() => scannerService.getPictures()).thenAnswer((_) async => null);
        return DocumentScannerCubit(documentRepository, scannerService);
      },
      act: (cubit) => cubit.startScan(userId),
      expect: () => [
        const DocumentScannerState.scanning(),
        const DocumentScannerState.initial(),
      ],
    );
  });
}
