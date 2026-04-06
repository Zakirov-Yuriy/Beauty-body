import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _usersCollection = 'users';

  // Создать профиль пользователя в Firestore
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String name,
  }) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'photoUrl': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Получить профиль пользователя
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Обновить профиль пользователя
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? photoUrl,
  }) async {
    try {
      final data = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (name != null) data['name'] = name;
      if (photoUrl != null) data['photoUrl'] = photoUrl;

      await _firestore.collection(_usersCollection).doc(uid).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // Удалить профиль пользователя
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Получить поток профиля пользователя (real-time)
  Stream<UserProfile?> getUserProfileStream(String uid) {
    return _firestore
        .collection(_usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserProfile.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Проверить существует ли профиль
  Future<bool> profileExists(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }
}
