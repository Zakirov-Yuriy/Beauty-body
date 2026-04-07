import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Загрузить изображение из assets в Firebase Storage
  Future<String> uploadAssetImage({
    required String assetPath,
    required String storagePath,
  }) async {
    try {
      print('📤 Начинаю загрузку: $assetPath → $storagePath');

      // Загружаем картинку из assets
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Загружаем в Firebase Storage
      final Reference ref = _storage.ref(storagePath);
      final UploadTask uploadTask = ref.putData(bytes);

      // Ждём завершения загрузки
      final TaskSnapshot snapshot = await uploadTask;
      
      // Получаем download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      print('✅ Загружено успешно: $downloadUrl');
      
      return downloadUrl;
    } catch (e) {
      print('❌ Ошибка загрузки изображения: $e');
      rethrow;
    }
  }

  /// Загрузить локальный файл в Firebase Storage
  Future<String> uploadFile({
    required File file,
    required String storagePath,
  }) async {
    try {
      print('📤 Начинаю загрузку файла: ${file.path} → $storagePath');

      final Reference ref = _storage.ref(storagePath);
      final UploadTask uploadTask = ref.putFile(file);

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      print('✅ Файл загружен: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('❌ Ошибка загрузки файла: $e');
      rethrow;
    }
  }

  /// Получить download URL по пути
  Future<String> getDownloadUrl(String storagePath) async {
    try {
      final Reference ref = _storage.ref(storagePath);
      final String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('❌ Ошибка получения ссылки: $e');
      return '';
    }
  }

  /// Удалить файл из Storage
  Future<void> deleteFile(String storagePath) async {
    try {
      final Reference ref = _storage.ref(storagePath);
      await ref.delete();
      print('✅ Файл удален: $storagePath');
    } catch (e) {
      print('❌ Ошибка удаления файла: $e');
      rethrow;
    }
  }

  /// Проверить существование файла
  Future<bool> fileExists(String storagePath) async {
    try {
      final Reference ref = _storage.ref(storagePath);
      final ListResult result = await ref.parent!.listAll();
      return result.items.any((item) => item.fullPath == ref.fullPath);
    } catch (e) {
      print('❌ Ошибка проверки файла: $e');
      return false;
    }
  }
}
