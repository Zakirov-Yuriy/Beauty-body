import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beauty_body/services/firebase_storage_service.dart';

/// Провайдер для Firebase Storage Service
final firebaseStorageServiceProvider = Provider((ref) {
  return FirebaseStorageService();
});

/// Загрузить картинку из assets в Firebase Storage
final uploadMealImageProvider = FutureProvider.family<String, ({String assetPath, String mealId})>((ref, params) async {
  final storageService = ref.watch(firebaseStorageServiceProvider);
  final storagePath = 'meals/${params.mealId}.jpg';
  
  return await storageService.uploadAssetImage(
    assetPath: params.assetPath,
    storagePath: storagePath,
  );
});

/// Получить download URL для картинки блюда
final getMealImageUrlProvider = FutureProvider.family<String, String>((ref, storagePath) async {
  if (storagePath.isEmpty) return '';
  
  final storageService = ref.watch(firebaseStorageServiceProvider);
  return await storageService.getDownloadUrl(storagePath);
});
