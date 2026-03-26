// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackupState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BackupState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BackupState()';
}


}

/// @nodoc
class $BackupStateCopyWith<$Res>  {
$BackupStateCopyWith(BackupState _, $Res Function(BackupState) __);
}


/// Adds pattern-matching-related methods to [BackupState].
extension BackupStatePatterns on BackupState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Initial value)?  initial,TResult Function( Loading value)?  loading,TResult Function( BackupSuccess value)?  backupSuccess,TResult Function( RestoreSuccess value)?  restoreSuccess,TResult Function( Failure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case BackupSuccess() when backupSuccess != null:
return backupSuccess(_that);case RestoreSuccess() when restoreSuccess != null:
return restoreSuccess(_that);case Failure() when failure != null:
return failure(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Initial value)  initial,required TResult Function( Loading value)  loading,required TResult Function( BackupSuccess value)  backupSuccess,required TResult Function( RestoreSuccess value)  restoreSuccess,required TResult Function( Failure value)  failure,}){
final _that = this;
switch (_that) {
case Initial():
return initial(_that);case Loading():
return loading(_that);case BackupSuccess():
return backupSuccess(_that);case RestoreSuccess():
return restoreSuccess(_that);case Failure():
return failure(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Initial value)?  initial,TResult? Function( Loading value)?  loading,TResult? Function( BackupSuccess value)?  backupSuccess,TResult? Function( RestoreSuccess value)?  restoreSuccess,TResult? Function( Failure value)?  failure,}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case BackupSuccess() when backupSuccess != null:
return backupSuccess(_that);case RestoreSuccess() when restoreSuccess != null:
return restoreSuccess(_that);case Failure() when failure != null:
return failure(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String zipPath)?  backupSuccess,TResult Function()?  restoreSuccess,TResult Function( String errorKey)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case BackupSuccess() when backupSuccess != null:
return backupSuccess(_that.zipPath);case RestoreSuccess() when restoreSuccess != null:
return restoreSuccess();case Failure() when failure != null:
return failure(_that.errorKey);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String zipPath)  backupSuccess,required TResult Function()  restoreSuccess,required TResult Function( String errorKey)  failure,}) {final _that = this;
switch (_that) {
case Initial():
return initial();case Loading():
return loading();case BackupSuccess():
return backupSuccess(_that.zipPath);case RestoreSuccess():
return restoreSuccess();case Failure():
return failure(_that.errorKey);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String zipPath)?  backupSuccess,TResult? Function()?  restoreSuccess,TResult? Function( String errorKey)?  failure,}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case BackupSuccess() when backupSuccess != null:
return backupSuccess(_that.zipPath);case RestoreSuccess() when restoreSuccess != null:
return restoreSuccess();case Failure() when failure != null:
return failure(_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class Initial with DiagnosticableTreeMixin implements BackupState {
  const Initial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BackupState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BackupState.initial()';
}


}




/// @nodoc


class Loading with DiagnosticableTreeMixin implements BackupState {
  const Loading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BackupState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BackupState.loading()';
}


}




/// @nodoc


class BackupSuccess with DiagnosticableTreeMixin implements BackupState {
  const BackupSuccess({required this.zipPath});
  

 final  String zipPath;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupSuccessCopyWith<BackupSuccess> get copyWith => _$BackupSuccessCopyWithImpl<BackupSuccess>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BackupState.backupSuccess'))
    ..add(DiagnosticsProperty('zipPath', zipPath));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupSuccess&&(identical(other.zipPath, zipPath) || other.zipPath == zipPath));
}


@override
int get hashCode => Object.hash(runtimeType,zipPath);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BackupState.backupSuccess(zipPath: $zipPath)';
}


}

/// @nodoc
abstract mixin class $BackupSuccessCopyWith<$Res> implements $BackupStateCopyWith<$Res> {
  factory $BackupSuccessCopyWith(BackupSuccess value, $Res Function(BackupSuccess) _then) = _$BackupSuccessCopyWithImpl;
@useResult
$Res call({
 String zipPath
});




}
/// @nodoc
class _$BackupSuccessCopyWithImpl<$Res>
    implements $BackupSuccessCopyWith<$Res> {
  _$BackupSuccessCopyWithImpl(this._self, this._then);

  final BackupSuccess _self;
  final $Res Function(BackupSuccess) _then;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? zipPath = null,}) {
  return _then(BackupSuccess(
zipPath: null == zipPath ? _self.zipPath : zipPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RestoreSuccess with DiagnosticableTreeMixin implements BackupState {
  const RestoreSuccess();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BackupState.restoreSuccess'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestoreSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BackupState.restoreSuccess()';
}


}




/// @nodoc


class Failure with DiagnosticableTreeMixin implements BackupState {
  const Failure({required this.errorKey});
  

 final  String errorKey;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailureCopyWith<Failure> get copyWith => _$FailureCopyWithImpl<Failure>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BackupState.failure'))
    ..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BackupState.failure(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $FailureCopyWith<$Res> implements $BackupStateCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) _then) = _$FailureCopyWithImpl;
@useResult
$Res call({
 String errorKey
});




}
/// @nodoc
class _$FailureCopyWithImpl<$Res>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._self, this._then);

  final Failure _self;
  final $Res Function(Failure) _then;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(Failure(
errorKey: null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
