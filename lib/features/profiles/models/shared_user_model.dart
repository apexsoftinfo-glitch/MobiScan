import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_user_model.freezed.dart';
part 'shared_user_model.g.dart';

@freezed
abstract class SharedUserModel with _$SharedUserModel {
  const SharedUserModel._();

  const factory SharedUserModel({
    required String id,
    @JsonKey(name: 'first_name')
    String? firstName,
  }) = _SharedUserModel;

  factory SharedUserModel.fromJson(Map<String, dynamic> json) =>
      _$SharedUserModelFromJson(json);
}
