import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/document_repository.dart';

part 'document_detail_cubit.freezed.dart';

@freezed
sealed class DocumentDetailState with _$DocumentDetailState {
  const factory DocumentDetailState.initial() = Initial;
  const factory DocumentDetailState.loading() = Loading;
  const factory DocumentDetailState.success({
    String? successKey,
    String? newName,
  }) = Success;
  const factory DocumentDetailState.error({
    required String errorKey,
  }) = Error;
}

@injectable
class DocumentDetailCubit extends Cubit<DocumentDetailState> {
  DocumentDetailCubit(this._documentRepository) : super(const DocumentDetailState.initial());

  final DocumentRepository _documentRepository;

  Future<void> renameDocument({required String id, required String newName}) async {
    if (newName.trim().isEmpty) return;
    
    emit(const DocumentDetailState.loading());
    try {
      await _documentRepository.updateDocumentName(id: id, name: newName.trim());
      emit(DocumentDetailState.success(successKey: 'document_renamed', newName: newName.trim()));
    } catch (e) {
      emit(const DocumentDetailState.error(errorKey: 'unknown_error'));
    }
  }

  Future<void> deleteDocument(String id) async {
    emit(const DocumentDetailState.loading());
    try {
      await _documentRepository.deleteDocument(id);
      emit(const DocumentDetailState.success(successKey: 'document_deleted'));
    } catch (e) {
      emit(const DocumentDetailState.error(errorKey: 'unknown_error'));
    }
  }

  Future<void> deletePage(String pageId) async {
    emit(const DocumentDetailState.loading());
    try {
      await _documentRepository.deletePage(pageId);
      emit(const DocumentDetailState.success(successKey: 'page_deleted'));
    } catch (e) {
      emit(const DocumentDetailState.error(errorKey: 'unknown_error'));
    }
  }

  void clearFeedback() {
    emit(const DocumentDetailState.initial());
  }
}
