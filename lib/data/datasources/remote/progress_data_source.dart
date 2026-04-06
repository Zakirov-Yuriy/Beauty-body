import 'package:beauty_body/domain/entities/progress_entity.dart';

abstract class ProgressDataSource {
  Future<List<ProgressEntity>> getProgressHistory();
  Future<List<ProgressEntity>> getProgressLast(int days);
  Stream<ProgressEntity?> getTodayProgress();
  Future<double> getCurrentWeight();
  Future<void> addWeightEntry(double weight);
  Future<void> updateMeasurements(Map<String, double> measurements);
  Stream<ProgressEntity> watchProgress();
}
