import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import './auth_provider.dart';

/// Провайдер для получения локального пути к профильной картинке
final profilePictureProvider = FutureProvider<File?>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return null;

  try {
    final appDir = await getApplicationDocumentsDirectory();
    final profilePictureFile = File('${appDir.path}/profile_picture_${user.uid}.jpg');
    
    if (profilePictureFile.existsSync()) {
      print('✅ Profile picture found locally: ${profilePictureFile.path}');
      return profilePictureFile;
    }
    
    return null;
  } catch (e) {
    print('❌ Error loading profile picture: $e');
    return null;
  }
});

/// Провайдер для выбора картинки (фото или галерея)
final pickProfilePictureProvider =
    FutureProvider.family<File?, ImageSource>((ref, source) async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  } catch (e) {
    print('❌ Error picking image: $e');
    return null;
  }
});

/// Провайдер для сохранения профильной картинки локально
final saveProfilePictureProvider = 
    FutureProvider.family<File, File>((ref, imageFile) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) throw Exception('User not authenticated');

  try {
    print('📤 Saving profile picture locally...');
    
    final appDir = await getApplicationDocumentsDirectory();
    final profilePictureFile = File('${appDir.path}/profile_picture_${user.uid}.jpg');
    
    // Копируем файл в локальное хранилище
    final savedFile = await imageFile.copy(profilePictureFile.path);
    
    print('✅ Profile picture saved: ${savedFile.path}');
    
    // Инвалидируем кеш чтобы обновить UI
    ref.invalidate(profilePictureProvider);
    
    return savedFile;
  } catch (e) {
    print('❌ Error saving profile picture: $e');
    rethrow;
  }
});

/// Провайдер для удаления профильной картинки
final deleteProfilePictureProvider = FutureProvider<void>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) throw Exception('User not authenticated');

  try {
    print('🗑️ Deleting profile picture...');
    
    final appDir = await getApplicationDocumentsDirectory();
    final profilePictureFile = File('${appDir.path}/profile_picture_${user.uid}.jpg');
    
    if (profilePictureFile.existsSync()) {
      await profilePictureFile.delete();
      print('✅ Profile picture deleted');
    }
    
    // Инвалидируем кеш
    ref.invalidate(profilePictureProvider);
  } catch (e) {
    print('❌ Error deleting profile picture: $e');
    rethrow;
  }
});
