import 'package:beauty_body/domain/entities/meal_entity.dart';
import 'package:beauty_body/domain/repositories/meal_repository.dart';
import '../datasources/remote/meal_data_source.dart';

class MealRepositoryImpl implements MealRepository {
  final MealDataSource _dataSource;

  MealRepositoryImpl(this._dataSource);

  @override
  Future<List<MealEntity>> getAllMeals() => _dataSource.getAllMeals();

  @override
  Future<MealEntity?> getMealById(String id) => _dataSource.getMealById(id);

  @override
  Future<List<MealEntity>> getMealsByType(String type) =>
      _dataSource.getMealsByType(type);

  @override
  Stream<List<MealEntity>> getTodayMeals() => _dataSource.getTodayMeals();

  @override
  Future<List<MealEntity>> getMealsByDate(DateTime date) =>
      _dataSource.getMealsByDate(date);
}
