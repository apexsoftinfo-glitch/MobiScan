import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../models/document_model.dart';
import '../../data/repositories/document_repository.dart';

part 'document_list_cubit.freezed.dart';

enum DocumentSortOrder {
  dateDesc,
  dateAsc,
  nameAsc,
  nameDesc,
}

@freezed
sealed class DocumentListState with _$DocumentListState {
  const factory DocumentListState.initial({
    @Default('') String searchQuery,
    @Default(DocumentSortOrder.dateDesc) DocumentSortOrder sortOrder,
  }) = Initial;

  const factory DocumentListState.loading({
    required String searchQuery,
    required DocumentSortOrder sortOrder,
  }) = Loading;

  const factory DocumentListState.success({
    required List<DocumentModel> documents,
    required String searchQuery,
    required DocumentSortOrder sortOrder,
  }) = Success;

  const factory DocumentListState.error({
    required String errorKey,
    required String searchQuery,
    required DocumentSortOrder sortOrder,
  }) = Error;
}

extension DocumentListStateX on DocumentListState {
  List<DocumentModel> get filteredDocuments {
    if (this is! Success) return [];
    final success = this as Success;
    
    var list = List<DocumentModel>.from(success.documents);
    
    // Search
    if (success.searchQuery.isNotEmpty) {
      final query = success.searchQuery.toLowerCase();
      list = list.where((doc) => doc.name.toLowerCase().contains(query)).toList();
    }
    
    // Sort
    switch (success.sortOrder) {
      case DocumentSortOrder.dateDesc:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case DocumentSortOrder.dateAsc:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case DocumentSortOrder.nameAsc:
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      case DocumentSortOrder.nameDesc:
        list.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    }
    
    return list;
  }
}

@injectable
class DocumentListCubit extends Cubit<DocumentListState> {
  DocumentListCubit(this._documentRepository) : super(const DocumentListState.initial());

  final DocumentRepository _documentRepository;
  StreamSubscription? _documentsSubscription;

  void loadDocuments(String userId) {
    emit(DocumentListState.loading(
      searchQuery: state.searchQuery,
      sortOrder: state.sortOrder,
    ));
    _documentsSubscription?.cancel();
    _documentsSubscription = _documentRepository.watchDocuments(userId).listen(
      (documents) {
        emit(DocumentListState.success(
          documents: documents,
          searchQuery: state.searchQuery,
          sortOrder: state.sortOrder,
        ));
      },
      onError: (error) {
        emit(DocumentListState.error(
          errorKey: 'unknown_error',
          searchQuery: state.searchQuery,
          sortOrder: state.sortOrder,
        ));
      },
    );
  }

  void updateSearch(String query) {
    if (state is Success) {
      emit((state as Success).copyWith(searchQuery: query));
    } else if (state is Initial) {
      emit((state as Initial).copyWith(searchQuery: query));
    } else if (state is Loading) {
      emit((state as Loading).copyWith(searchQuery: query));
    } else if (state is Error) {
      emit((state as Error).copyWith(searchQuery: query));
    }
  }

  void updateSort(DocumentSortOrder order) {
    if (state is Success) {
      emit((state as Success).copyWith(sortOrder: order));
    } else if (state is Initial) {
      emit((state as Initial).copyWith(sortOrder: order));
    } else if (state is Loading) {
      emit((state as Loading).copyWith(sortOrder: order));
    } else if (state is Error) {
      emit((state as Error).copyWith(sortOrder: order));
    }
  }

  Future<void> retry(String userId) async {
    loadDocuments(userId);
  }

  Future<void> deleteDocument(String id) async {
    final currentState = state;
    if (currentState is Success) {
      // Optimistically remove the document from the list
      final updatedList = currentState.documents.where((doc) => doc.id != id).toList();
      emit(currentState.copyWith(documents: updatedList));
    }

    try {
      await _documentRepository.deleteDocument(id);
    } catch (e) {
      debugPrint('DocumentListCubit delete error: $e');
      // Revert state on error or at least emit error
      emit(DocumentListState.error(
        errorKey: 'unknown_error',
        searchQuery: state.searchQuery,
        sortOrder: state.sortOrder,
      ));
    }
  }

  @override
  Future<void> close() {
    _documentsSubscription?.cancel();
    return super.close();
  }
}
