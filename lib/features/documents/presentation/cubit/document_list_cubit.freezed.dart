// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentListState implements DiagnosticableTreeMixin {

 String get searchQuery; DocumentSortOrder get sortOrder;
/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentListStateCopyWith<DocumentListState> get copyWith => _$DocumentListStateCopyWithImpl<DocumentListState>(this as DocumentListState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DocumentListState'))
    ..add(DiagnosticsProperty('searchQuery', searchQuery))..add(DiagnosticsProperty('sortOrder', sortOrder));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentListState&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,sortOrder);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DocumentListState(searchQuery: $searchQuery, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $DocumentListStateCopyWith<$Res>  {
  factory $DocumentListStateCopyWith(DocumentListState value, $Res Function(DocumentListState) _then) = _$DocumentListStateCopyWithImpl;
@useResult
$Res call({
 String searchQuery, DocumentSortOrder sortOrder
});




}
/// @nodoc
class _$DocumentListStateCopyWithImpl<$Res>
    implements $DocumentListStateCopyWith<$Res> {
  _$DocumentListStateCopyWithImpl(this._self, this._then);

  final DocumentListState _self;
  final $Res Function(DocumentListState) _then;

/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? searchQuery = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as DocumentSortOrder,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentListState].
extension DocumentListStatePatterns on DocumentListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Initial value)?  initial,TResult Function( Loading value)?  loading,TResult Function( Success value)?  success,TResult Function( Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Success() when success != null:
return success(_that);case Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Initial value)  initial,required TResult Function( Loading value)  loading,required TResult Function( Success value)  success,required TResult Function( Error value)  error,}){
final _that = this;
switch (_that) {
case Initial():
return initial(_that);case Loading():
return loading(_that);case Success():
return success(_that);case Error():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Initial value)?  initial,TResult? Function( Loading value)?  loading,TResult? Function( Success value)?  success,TResult? Function( Error value)?  error,}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Success() when success != null:
return success(_that);case Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String searchQuery,  DocumentSortOrder sortOrder)?  initial,TResult Function( String searchQuery,  DocumentSortOrder sortOrder)?  loading,TResult Function( List<DocumentModel> documents,  String searchQuery,  DocumentSortOrder sortOrder)?  success,TResult Function( String errorKey,  String searchQuery,  DocumentSortOrder sortOrder)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that.searchQuery,_that.sortOrder);case Loading() when loading != null:
return loading(_that.searchQuery,_that.sortOrder);case Success() when success != null:
return success(_that.documents,_that.searchQuery,_that.sortOrder);case Error() when error != null:
return error(_that.errorKey,_that.searchQuery,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String searchQuery,  DocumentSortOrder sortOrder)  initial,required TResult Function( String searchQuery,  DocumentSortOrder sortOrder)  loading,required TResult Function( List<DocumentModel> documents,  String searchQuery,  DocumentSortOrder sortOrder)  success,required TResult Function( String errorKey,  String searchQuery,  DocumentSortOrder sortOrder)  error,}) {final _that = this;
switch (_that) {
case Initial():
return initial(_that.searchQuery,_that.sortOrder);case Loading():
return loading(_that.searchQuery,_that.sortOrder);case Success():
return success(_that.documents,_that.searchQuery,_that.sortOrder);case Error():
return error(_that.errorKey,_that.searchQuery,_that.sortOrder);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String searchQuery,  DocumentSortOrder sortOrder)?  initial,TResult? Function( String searchQuery,  DocumentSortOrder sortOrder)?  loading,TResult? Function( List<DocumentModel> documents,  String searchQuery,  DocumentSortOrder sortOrder)?  success,TResult? Function( String errorKey,  String searchQuery,  DocumentSortOrder sortOrder)?  error,}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that.searchQuery,_that.sortOrder);case Loading() when loading != null:
return loading(_that.searchQuery,_that.sortOrder);case Success() when success != null:
return success(_that.documents,_that.searchQuery,_that.sortOrder);case Error() when error != null:
return error(_that.errorKey,_that.searchQuery,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class Initial with DiagnosticableTreeMixin implements DocumentListState {
  const Initial({this.searchQuery = '', this.sortOrder = DocumentSortOrder.dateDesc});
  

@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  DocumentSortOrder sortOrder;

/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitialCopyWith<Initial> get copyWith => _$InitialCopyWithImpl<Initial>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DocumentListState.initial'))
    ..add(DiagnosticsProperty('searchQuery', searchQuery))..add(DiagnosticsProperty('sortOrder', sortOrder));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Initial&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,sortOrder);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DocumentListState.initial(searchQuery: $searchQuery, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $InitialCopyWith<$Res> implements $DocumentListStateCopyWith<$Res> {
  factory $InitialCopyWith(Initial value, $Res Function(Initial) _then) = _$InitialCopyWithImpl;
@override @useResult
$Res call({
 String searchQuery, DocumentSortOrder sortOrder
});




}
/// @nodoc
class _$InitialCopyWithImpl<$Res>
    implements $InitialCopyWith<$Res> {
  _$InitialCopyWithImpl(this._self, this._then);

  final Initial _self;
  final $Res Function(Initial) _then;

/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searchQuery = null,Object? sortOrder = null,}) {
  return _then(Initial(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as DocumentSortOrder,
  ));
}


}

/// @nodoc


class Loading with DiagnosticableTreeMixin implements DocumentListState {
  const Loading({required this.searchQuery, required this.sortOrder});
  

@override final  String searchQuery;
@override final  DocumentSortOrder sortOrder;

/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadingCopyWith<Loading> get copyWith => _$LoadingCopyWithImpl<Loading>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DocumentListState.loading'))
    ..add(DiagnosticsProperty('searchQuery', searchQuery))..add(DiagnosticsProperty('sortOrder', sortOrder));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,sortOrder);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DocumentListState.loading(searchQuery: $searchQuery, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $LoadingCopyWith<$Res> implements $DocumentListStateCopyWith<$Res> {
  factory $LoadingCopyWith(Loading value, $Res Function(Loading) _then) = _$LoadingCopyWithImpl;
@override @useResult
$Res call({
 String searchQuery, DocumentSortOrder sortOrder
});




}
/// @nodoc
class _$LoadingCopyWithImpl<$Res>
    implements $LoadingCopyWith<$Res> {
  _$LoadingCopyWithImpl(this._self, this._then);

  final Loading _self;
  final $Res Function(Loading) _then;

/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searchQuery = null,Object? sortOrder = null,}) {
  return _then(Loading(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as DocumentSortOrder,
  ));
}


}

/// @nodoc


class Success with DiagnosticableTreeMixin implements DocumentListState {
  const Success({required final  List<DocumentModel> documents, required this.searchQuery, required this.sortOrder}): _documents = documents;
  

 final  List<DocumentModel> _documents;
 List<DocumentModel> get documents {
  if (_documents is EqualUnmodifiableListView) return _documents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_documents);
}

@override final  String searchQuery;
@override final  DocumentSortOrder sortOrder;

/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessCopyWith<Success> get copyWith => _$SuccessCopyWithImpl<Success>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DocumentListState.success'))
    ..add(DiagnosticsProperty('documents', documents))..add(DiagnosticsProperty('searchQuery', searchQuery))..add(DiagnosticsProperty('sortOrder', sortOrder));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Success&&const DeepCollectionEquality().equals(other._documents, _documents)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_documents),searchQuery,sortOrder);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DocumentListState.success(documents: $documents, searchQuery: $searchQuery, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $SuccessCopyWith<$Res> implements $DocumentListStateCopyWith<$Res> {
  factory $SuccessCopyWith(Success value, $Res Function(Success) _then) = _$SuccessCopyWithImpl;
@override @useResult
$Res call({
 List<DocumentModel> documents, String searchQuery, DocumentSortOrder sortOrder
});




}
/// @nodoc
class _$SuccessCopyWithImpl<$Res>
    implements $SuccessCopyWith<$Res> {
  _$SuccessCopyWithImpl(this._self, this._then);

  final Success _self;
  final $Res Function(Success) _then;

/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documents = null,Object? searchQuery = null,Object? sortOrder = null,}) {
  return _then(Success(
documents: null == documents ? _self._documents : documents // ignore: cast_nullable_to_non_nullable
as List<DocumentModel>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as DocumentSortOrder,
  ));
}


}

/// @nodoc


class Error with DiagnosticableTreeMixin implements DocumentListState {
  const Error({required this.errorKey, required this.searchQuery, required this.sortOrder});
  

 final  String errorKey;
@override final  String searchQuery;
@override final  DocumentSortOrder sortOrder;

/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorCopyWith<Error> get copyWith => _$ErrorCopyWithImpl<Error>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DocumentListState.error'))
    ..add(DiagnosticsProperty('errorKey', errorKey))..add(DiagnosticsProperty('searchQuery', searchQuery))..add(DiagnosticsProperty('sortOrder', sortOrder));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Error&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey,searchQuery,sortOrder);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DocumentListState.error(errorKey: $errorKey, searchQuery: $searchQuery, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $ErrorCopyWith<$Res> implements $DocumentListStateCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) _then) = _$ErrorCopyWithImpl;
@override @useResult
$Res call({
 String errorKey, String searchQuery, DocumentSortOrder sortOrder
});




}
/// @nodoc
class _$ErrorCopyWithImpl<$Res>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._self, this._then);

  final Error _self;
  final $Res Function(Error) _then;

/// Create a copy of DocumentListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? errorKey = null,Object? searchQuery = null,Object? sortOrder = null,}) {
  return _then(Error(
errorKey: null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as DocumentSortOrder,
  ));
}


}

// dart format on
