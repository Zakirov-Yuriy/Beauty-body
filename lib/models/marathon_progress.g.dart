// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marathon_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarathonProgressImpl _$$MarathonProgressImplFromJson(
  Map<String, dynamic> json,
) => _$MarathonProgressImpl(
  startDate: DateTime.parse(json['startDate'] as String),
  startWeekday: (json['startWeekday'] as num).toInt(),
  lastCheckedDate: DateTime.parse(json['lastCheckedDate'] as String),
);

Map<String, dynamic> _$$MarathonProgressImplToJson(
  _$MarathonProgressImpl instance,
) => <String, dynamic>{
  'startDate': instance.startDate.toIso8601String(),
  'startWeekday': instance.startWeekday,
  'lastCheckedDate': instance.lastCheckedDate.toIso8601String(),
};
