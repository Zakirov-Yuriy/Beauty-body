import 'package:beauty_body/data/datasources/remote/firebase_marathon_progress_data_source.dart';
import 'package:beauty_body/domain/entities/marathon_progress_entity.dart';
import 'package:beauty_body/domain/repositories/marathon_progress_repository.dart';

class MarathonProgressRepositoryImpl implements MarathonProgressRepository {
  final FirebaseMarathonProgressDataSource _dataSource;

  MarathonProgressRepositoryImpl(this._dataSource);

  @override
  Future<MarathonProgressEntity?> getMarathonProgress(String userId) {
    return _dataSource.getMarathonProgress(userId);
  }

  @override
  Stream<MarathonProgressEntity?> watchMarathonProgress(String userId) {
    return _dataSource.watchMarathonProgress(userId);
  }

  @override
  Future<void> updateProgress({
    required String userId,
    required int stage,
    required int week,
    required int day,
  }) {
    return _dataSource.updateProgress(
      userId: userId,
      stage: stage,
      week: week,
      day: day,
    );
  }

  @override
  Future<void> nextDay(String userId) {
    return _dataSource.nextDay(userId);
  }

  @override
  Future<void> initializeMarathonProgress(String userId) {
    return _dataSource.initializeMarathonProgress(userId);
  }

  @override
  Future<void> resetMarathonProgress(String userId) {
    return _dataSource.resetMarathonProgress(userId);
  }

  @override
  Future<void> updateProgressBasedOnElapsedDays(String userId) {
    return _dataSource.updateProgressBasedOnElapsedDays(userId);
  }
}
