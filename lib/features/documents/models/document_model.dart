import 'package:freezed_annotation/freezed_annotation.dart';
import 'page_model.dart';

part 'document_model.freezed.dart';
part 'document_model.g.dart';

@freezed
abstract class DocumentModel with _$DocumentModel {
  const DocumentModel._();

  const factory DocumentModel({
    required String id,
    @JsonKey(name: 'user_id')
    required String userId,
    required String name,
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
    @Default([])
    List<PageModel> pages,
  }) = _DocumentModel;

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  String get firstPageThumbnail => pages.isNotEmpty ? pages.first.storagePath : '';
}
