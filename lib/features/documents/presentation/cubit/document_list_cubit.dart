import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../models/document_model.dart';
import '../../data/repositories/document_repository.dart';

part 'document_list_cubit.freezed.dart';

@freezed
sealed class DocumentListState with _$DocumentListState {
  const factory DocumentListState.initial() = Initial;
  const factory DocumentListState.loading() = Loading;
  const factory DocumentListState.success({
    required List<DocumentModel> documents,
  }) = Success;
  const factory DocumentListState.error({
    required String errorKey,
  }) = Error;
}

@injectable
class DocumentListCubit extends Cubit<DocumentListState> {
  DocumentListCubit(this._documentRepository) : super(const DocumentListState.initial());

  final DocumentRepository _documentRepository;
  StreamSubscription? _documentsSubscription;

  void loadDocuments(String userId) {
    emit(const DocumentListState.loading());
    _documentsSubscription?.cancel();
    _documentsSubscription = _documentRepository.watchDocuments(userId).listen(
      (documents) {
        emit(DocumentListState.success(documents: documents));
      },
      onError: (error) {
        emit(const DocumentListState.error(errorKey: 'unknown_error'));
      },
    );
  }

  Future<void> retry(String userId) async {
    loadDocuments(userId);
  }

  @override
  Future<void> close() {
    _documentsSubscription?.cancel();
    return super.close();
  }
}
