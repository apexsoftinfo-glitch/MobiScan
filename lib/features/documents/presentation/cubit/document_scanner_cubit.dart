import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
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
      final images = await _scannerService.getPictures();
      if (images == null || images.isEmpty) {
        emit(const DocumentScannerState.initial());
        return;
      }

      emit(const DocumentScannerState.saving());
      
      // Create document with default name
      final timestamp = DateTime.now().toIso8601String().substring(0, 10);
      final doc = await _documentRepository.createDocument(
        userId: userId,
        name: 'Scan $timestamp',
      );

      // Add pages (in real app we should upload to storage, 
      // but for MVP let's assume storage_path is local or placeholder)
      // Actually, per IDEA.md we should store them.
      for (var i = 0; i < images.length; i++) {
        await _documentRepository.addPage(
          documentId: doc.id,
          storagePath: images[i],
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
