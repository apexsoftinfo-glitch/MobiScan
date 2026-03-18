import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/document_repository.dart';
import '../../data/services/document_scanner_service.dart';

part 'document_scanner_cubit.freezed.dart';

@freezed
sealed class DocumentScannerState with _$DocumentScannerState {
  const factory DocumentScannerState.initial() = Initial;
  const factory DocumentScannerState.scanning() = Scanning;
  const factory DocumentScannerState.saving() = Saving;
  const factory DocumentScannerState.success({
    required String documentId,
  }) = Success;
  const factory DocumentScannerState.error({
    required String errorKey,
  }) = Error;
}

@injectable
class DocumentScannerCubit extends Cubit<DocumentScannerState> {
  DocumentScannerCubit(this._documentRepository, this._scannerService) 
      : super(const DocumentScannerState.initial());

  final DocumentRepository _documentRepository;
  final DocumentScannerService _scannerService;

  Future<void> startScan(String userId) async {
    emit(const DocumentScannerState.scanning());
    try {
      // Explicitly check for camera permission
      final status = await Permission.camera.request();
      if (status.isPermanentlyDenied) {
        openAppSettings();
        emit(const DocumentScannerState.error(errorKey: 'permission_denied'));
        return;
      }
      
      if (!status.isGranted) {
        emit(const DocumentScannerState.error(errorKey: 'permission_denied'));
        return;
      }

      final images = await _scannerService.getPictures();
      if (images == null || images.isEmpty) {
        emit(const DocumentScannerState.initial());
        return;
      }

      emit(const DocumentScannerState.saving());
      
      final appDocDir = await getApplicationDocumentsDirectory();
      const uuid = Uuid();

      // Create document with default name
      final timestamp = DateTime.now().toIso8601String().substring(0, 10);
      final doc = await _documentRepository.createDocument(
        userId: userId,
        name: 'Scan $timestamp',
      );

      // Add pages
      for (var i = 0; i < images.length; i++) {
        final sourceFile = File(images[i]);
        final extension = p.extension(images[i]);
        final fileName = '${uuid.v4()}$extension';
        final targetPath = p.join(appDocDir.path, fileName);
        
        await sourceFile.copy(targetPath);

        await _documentRepository.addPage(
          documentId: doc.id,
          storagePath: fileName, // Store only filename
          pageIndex: i,
        );
      }

      emit(DocumentScannerState.success(documentId: doc.id));
    } catch (e) {
      debugPrint('❌ [DocumentScannerCubit] scan error: $e');
      emit(const DocumentScannerState.error(errorKey: 'unknown_error'));
    }
  }
}
