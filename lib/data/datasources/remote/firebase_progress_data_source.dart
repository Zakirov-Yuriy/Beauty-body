import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beauty_body/domain/entities/progress_entity.dart';
import '../../models/progress_model.dart';
import 'progress_data_source.dart';

class FirebaseProgressDataSource implements ProgressDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseProgressDataSource(this._firestore, this._auth);

  String get _userId => _auth.currentUser?.uid ?? '';

  @override
  Future<List<ProgressEntity>> getProgressHistory() async {
    try {
      if (_userId.isEmpty) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('progress')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ProgressModel.fromJson(doc.data()).toEntity())
          .toList();
    } catch (e) {
      print('❌ Ошибка getProgressHistory: $e');
      return [];
    }
  }

  @override
  Future<List<ProgressEntity>> getProgressLast(int days) async {
    try {
      if (_userId.isEmpty) return [];

      final fromDate = DateTime.now().subtract(Duration(days: days));

      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('progress')
          .where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate))
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ProgressModel.fromJson(doc.data()).toEntity())
          .toList();
    } catch (e) {
      print('❌ Ошибка getProgressLast: $e');
      return [];
    }
  }

  @override
  Stream<ProgressEntity?> getTodayProgress() {
    try {
      if (_userId.isEmpty) return Stream.value(null);

      final today = DateTime.now();
      final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      return _firestore
          .collection('users')
          .doc(_userId)
          .collection('progress')
          .doc(dateStr)
          .snapshots()
          .map((doc) {
        if (doc.exists) {
          return ProgressModel.fromJson(doc.data() as Map<String, dynamic>).toEntity();
        }
        return null;
      });
    } catch (e) {
      print('❌ Ошибка getTodayProgress: $e');
      return Stream.value(null);
    }
  }

  @override
  Future<double> getCurrentWeight() async {
    try {
      if (_userId.isEmpty) return 0;

      final today = DateTime.now();
      final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('progress')
          .doc(dateStr)
          .get();

      if (doc.exists) {
        final data = doc.data();
        return (data?['weight'] as num?)?.toDouble() ?? 0;
      }

      return 0;
    } catch (e) {
      print('❌ Ошибка getCurrentWeight: $e');
      return 0;
    }
  }

  @override
  Future<void> addWeightEntry(double weight) async {
    try {
      if (_userId.isEmpty) throw Exception('User not authenticated');

      final today = DateTime.now();
      final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      // Получи текущие данные прогресса для дня
      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('progress')
          .doc(dateStr)
          .get();

      final currentData = doc.data() ?? {};
      final targetWeight = (currentData['targetWeight'] as num?)?.toDouble() ?? 70.0;
      final progress = weight - targetWeight;

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('progress')
          .doc(dateStr)
          .set({
        'date': dateStr,
        'weight': weight,
        'targetWeight': targetWeight,
        'progress': progress,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('✅ Вес добавлен: $weight');
    } catch (e) {
      print('❌ Ошибка addWeightEntry: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateMeasurements(Map<String, double> measurements) async {
    try {
      if (_userId.isEmpty) throw Exception('User not authenticated');

      final today = DateTime.now();
      final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('progress')
          .doc(dateStr)
          .set({
        'measurements': measurements,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('✅ Измерения обновлены');
    } catch (e) {
      print('❌ Ошибка updateMeasurements: $e');
      rethrow;
    }
  }

  @override
  Stream<ProgressEntity> watchProgress() {
    try {
      if (_userId.isEmpty) return Stream.error(Exception('User not authenticated'));

      return _firestore
          .collection('users')
          .doc(_userId)
          .collection('progress')
          .orderBy('date', descending: true)
          .limit(1)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return ProgressModel.fromJson(snapshot.docs.first.data()).toEntity();
        }
        // Если нет данных, вернём дефолтное значение
        return ProgressEntity(
          date: DateTime.now(),
          weight: 0,
          targetWeight: 70,
          progress: 0,
          meals: 0,
          calories: 0,
          calorieGoal: 2000,
        );
      });
    } catch (e) {
      print('❌ Ошибка watchProgress: $e');
      return Stream.error(e);
    }
  }
}
