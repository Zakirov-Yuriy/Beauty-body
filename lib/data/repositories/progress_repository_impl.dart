import 'package:beauty_body/domain/entities/progress_entity.dart';
import 'package:beauty_body/domain/repositories/progress_repository.dart';
import '../datasources/remote/progress_data_source.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressDataSource _dataSource;

  ProgressRepositoryImpl(this._dataSource);

  @override
  Future<List<ProgressEntity>> getProgressHistory() =>
      _dataSource.getProgressHistory();

  @override
  Future<List<ProgressEntity>> getProgressLast(int days) =>
      _dataSource.getProgressLast(days);

  @override
  Stream<ProgressEntity?> getTodayProgress() => _dataSource.getTodayProgress();

  @override
  Future<double> getCurrentWeight() => _dataSource.getCurrentWeight();

  @override
  Future<void> addWeightEntry(double weight) =>
      _dataSource.addWeightEntry(weight);

  @override
  Future<void> updateMeasurements(Map<String, double> measurements) =>
      _dataSource.updateMeasurements(measurements);

  @override
  Stream<ProgressEntity> watchProgress() => _dataSource.watchProgress();
}
