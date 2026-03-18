import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/features/documents/presentation/cubit/document_scanner_cubit.dart';
import 'package:myapp/features/documents/data/services/document_scanner_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../../../support/mocks.dart';

class MockDocumentScannerService extends Mock implements DocumentScannerService {}

class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.';
}

class MockPermissionHandlerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PermissionHandlerPlatform {
  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async =>
      PermissionStatus.granted;

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) async {
    return {for (var p in permissions) p: PermissionStatus.granted};
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late MockDocumentRepository documentRepository;
  late MockDocumentScannerService scannerService;

  setUp(() {
    documentRepository = MockDocumentRepository();
    scannerService = MockDocumentScannerService();
    PathProviderPlatform.instance = MockPathProviderPlatform();
    PermissionHandlerPlatform.instance = MockPermissionHandlerPlatform();
    
    // Create dummy files for testing
    Directory('path/to').createSync(recursive: true);
    File('path/to/img1.jpg').writeAsStringSync('dummy content');
    File('path/to/img2.jpg').writeAsStringSync('dummy content');
  });

  tearDown(() {
    if (Directory('path').existsSync()) {
      Directory('path').deleteSync(recursive: true);
    }
  });

  group('DocumentScannerCubit', () {
    const userId = 'user-1';
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
