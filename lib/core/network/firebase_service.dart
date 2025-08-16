import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  
  // Auth
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Firestore
  FirebaseFirestore get firestore => _firestore;
  
  // Cloud Functions
  Future<HttpsCallableResult> callFunction(String name, [Map<String, dynamic>? parameters]) {
    return _functions.httpsCallable(name).call(parameters);
  }
  
  // Parse expense using Cloud Function
  Future<Map<String, dynamic>> parseExpense(String naturalLanguageInput) async {
    final result = await callFunction('parseExpense', {
      'input': naturalLanguageInput,
      'userId': currentUser?.uid,
    });
    return Map<String, dynamic>.from(result.data);
  }
  
  // Sync messages using Cloud Function
  Future<List<Map<String, dynamic>>> syncMessages(List<Map<String, dynamic>> messages) async {
    final result = await callFunction('syncMessages', {
      'messages': messages,
      'userId': currentUser?.uid,
    });
    return List<Map<String, dynamic>>.from(result.data);
  }
  
  // Chat with passbook using Cloud Function
  Future<String> chatWithPassbook(String message) async {
    final result = await callFunction('chatWithPassbook', {
      'message': message,
      'userId': currentUser?.uid,
    });
    return result.data['response'];
  }
}