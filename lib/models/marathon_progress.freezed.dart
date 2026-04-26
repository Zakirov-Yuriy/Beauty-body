// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marathon_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MarathonProgress _$MarathonProgressFromJson(Map<String, dynamic> json) {
  return _MarathonProgress.fromJson(json);
}

/// @nodoc
mixin _$MarathonProgress {
  DateTime get startDate => throw _privateConstructorUsedError;
  int get startWeekday =>
      throw _privateConstructorUsedError; // 1 = Пн, 7 = Вс (DateTime.weekday format)
  DateTime get lastCheckedDate => throw _privateConstructorUsedError;

  /// Serializes this MarathonProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarathonProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarathonProgressCopyWith<MarathonProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarathonProgressCopyWith<$Res> {
  factory $MarathonProgressCopyWith(
    MarathonProgress value,
    $Res Function(MarathonProgress) then,
  ) = _$MarathonProgressCopyWithImpl<$Res, MarathonProgress>;
  @useResult
  $Res call({DateTime startDate, int startWeekday, DateTime lastCheckedDate});
}

/// @nodoc
class _$MarathonProgressCopyWithImpl<$Res, $Val extends MarathonProgress>
    implements $MarathonProgressCopyWith<$Res> {
  _$MarathonProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarathonProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? startWeekday = null,
    Object? lastCheckedDate = null,
  }) {
    return _then(
      _value.copyWith(
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            startWeekday: null == startWeekday
                ? _value.startWeekday
                : startWeekday // ignore: cast_nullable_to_non_nullable
                      as int,
            lastCheckedDate: null == lastCheckedDate
                ? _value.lastCheckedDate
                : lastCheckedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarathonProgressImplCopyWith<$Res>
    implements $MarathonProgressCopyWith<$Res> {
  factory _$$MarathonProgressImplCopyWith(
    _$MarathonProgressImpl value,
    $Res Function(_$MarathonProgressImpl) then,
  ) = __$$MarathonProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime startDate, int startWeekday, DateTime lastCheckedDate});
}

/// @nodoc
class __$$MarathonProgressImplCopyWithImpl<$Res>
    extends _$MarathonProgressCopyWithImpl<$Res, _$MarathonProgressImpl>
    implements _$$MarathonProgressImplCopyWith<$Res> {
  __$$MarathonProgressImplCopyWithImpl(
    _$MarathonProgressImpl _value,
    $Res Function(_$MarathonProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarathonProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? startWeekday = null,
    Object? lastCheckedDate = null,
  }) {
    return _then(
      _$MarathonProgressImpl(
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startWeekday: null == startWeekday
            ? _value.startWeekday
            : startWeekday // ignore: cast_nullable_to_non_nullable
                  as int,
        lastCheckedDate: null == lastCheckedDate
            ? _value.lastCheckedDate
            : lastCheckedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarathonProgressImpl implements _MarathonProgress {
  const _$MarathonProgressImpl({
    required this.startDate,
    required this.startWeekday,
    required this.lastCheckedDate,
  });

  factory _$MarathonProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarathonProgressImplFromJson(json);

  @override
  final DateTime startDate;
  @override
  final int startWeekday;
  // 1 = Пн, 7 = Вс (DateTime.weekday format)
  @override
  final DateTime lastCheckedDate;

  @override
  String toString() {
    return 'MarathonProgress(startDate: $startDate, startWeekday: $startWeekday, lastCheckedDate: $lastCheckedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarathonProgressImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.startWeekday, startWeekday) ||
                other.startWeekday == startWeekday) &&
            (identical(other.lastCheckedDate, lastCheckedDate) ||
                other.lastCheckedDate == lastCheckedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, startDate, startWeekday, lastCheckedDate);

  /// Create a copy of MarathonProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarathonProgressImplCopyWith<_$MarathonProgressImpl> get copyWith =>
      __$$MarathonProgressImplCopyWithImpl<_$MarathonProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MarathonProgressImplToJson(this);
  }
}

abstract class _MarathonProgress implements MarathonProgress {
  const factory _MarathonProgress({
    required final DateTime startDate,
    required final int startWeekday,
    required final DateTime lastCheckedDate,
  }) = _$MarathonProgressImpl;

  factory _MarathonProgress.fromJson(Map<String, dynamic> json) =
      _$MarathonProgressImpl.fromJson;

  @override
  DateTime get startDate;
  @override
  int get startWeekday; // 1 = Пн, 7 = Вс (DateTime.weekday format)
  @override
  DateTime get lastCheckedDate;

  /// Create a copy of MarathonProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarathonProgressImplCopyWith<_$MarathonProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
