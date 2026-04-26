import 'package:freezed_annotation/freezed_annotation.dart';

part 'marathon_progress.freezed.dart';
part 'marathon_progress.g.dart';

@freezed
class MarathonProgress with _$MarathonProgress {
  const factory MarathonProgress({
    required DateTime startDate,
    required int startWeekday, // 1 = Пн, 7 = Вс (DateTime.weekday format)
    required DateTime lastCheckedDate,
  }) = _MarathonProgress;

  factory MarathonProgress.fromJson(Map<String, dynamic> json) =>
      _$MarathonProgressFromJson(json);
}
