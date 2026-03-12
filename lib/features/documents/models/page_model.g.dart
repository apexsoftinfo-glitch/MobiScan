// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PageModel _$PageModelFromJson(Map<String, dynamic> json) => _PageModel(
  id: json['id'] as String,
  documentId: json['document_id'] as String,
  storagePath: json['storage_path'] as String,
  pageIndex: (json['page_index'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$PageModelToJson(_PageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'document_id': instance.documentId,
      'storage_path': instance.storagePath,
      'page_index': instance.pageIndex,
      'created_at': instance.createdAt.toIso8601String(),
    };
