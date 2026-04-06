import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  String firebaseStatus = 'Проверка Firebase...';
  bool isFirebaseConnected = false;

  @override
  void initState() {
    super.initState();
    checkFirebaseConnection();
  }

  Future<void> checkFirebaseConnection() async {
    try {
      // Firebase уже инициализирован в main.dart
      final app = Firebase.app();
      
      setState(() {
        firebaseStatus = '''
✅ Firebase подключен!

Проект: ${app.options.projectId}
API Key: ${app.options.apiKey.substring(0, 20)}...
App ID: ${app.options.appId}
Messaging Sender ID: ${app.options.messagingSenderId}
Storage Bucket: ${app.options.storageBucket}
''';
        isFirebaseConnected = true;
      });
    } catch (e) {
      setState(() {
        firebaseStatus = '❌ Ошибка Firebase: $e';
        isFirebaseConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Проверка Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isFirebaseConnected ? Colors.green[100] : Colors.red[100],
                    border: Border.all(
                      color: isFirebaseConnected ? Colors.green : Colors.red,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isFirebaseConnected ? 'Firebase статус: ✅ Подключен' : 'Firebase статус: ❌ Ошибка',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isFirebaseConnected ? Colors.green[900] : Colors.red[900],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        firebaseStatus,
                        style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
