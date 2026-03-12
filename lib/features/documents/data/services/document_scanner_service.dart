import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:injectable/injectable.dart';

abstract class DocumentScannerService {
  Future<List<String>?> getPictures();
}

@LazySingleton(as: DocumentScannerService)
class DocumentScannerServiceImpl implements DocumentScannerService {
  @override
  Future<List<String>?> getPictures() => CunningDocumentScanner.getPictures();
}
