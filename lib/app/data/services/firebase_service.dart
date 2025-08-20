import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore logging
  Future<void> logInteraction({
    required String userQuestion,
    required String aiResponse,
    String? imageUrl,
    bool hasImage = false,
  }) async {
    try {
      await _firestore.collection('interactions').add({
        'userQuestion': userQuestion,
        'aiResponse': aiResponse,
        'hasImage': hasImage,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error logging interaction: $e');
    }
  }

  Future<void> logError({
    required String error,
    required String context,
  }) async {
    try {
      await _firestore.collection('errors').add({
        'error': error,
        'context': context,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error logging error: $e');
    }
  }

  // Get interactions (without user filtering)
  Stream<QuerySnapshot> getInteractions() {
    return _firestore
        .collection('interactions')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }
}
