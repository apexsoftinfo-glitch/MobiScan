import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_model.freezed.dart';
part 'page_model.g.dart';

@freezed
abstract class PageModel with _$PageModel {
  const PageModel._();

  const factory PageModel({
    required String id,
    @JsonKey(name: 'document_id')
    required String documentId,
    @JsonKey(name: 'storage_path')
    required String storagePath,
    @JsonKey(name: 'page_index')
    required int pageIndex,
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
  }) = _PageModel;

  factory PageModel.fromJson(Map<String, dynamic> json) =>
      _$PageModelFromJson(json);
}
