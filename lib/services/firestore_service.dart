import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseFirestore get db => _db;

  /// Create user document and return UID
  Future<void> createUserDocument(
    String uid,
    String email,
    String role, {
    String? name,
  }) async {
    final docRef = _db.collection('users').doc(uid); // 🔹 use Auth UID
    await docRef.set({
      'email': email,
      'name': name ?? email.split('@').first,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get full user document by uid
  Future<Map<String, dynamic>?> getUserDoc(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  /// Get only role for a given user
  Future<String?> getUserRole(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      final data = doc.data();
      return data?['role']?.toString();
    } catch (e) {
      print("Error fetching user role: $e");
      return null;
    }
  }

  /// Update user document
  Future<void> updateUserDoc(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  /// Add a check-in document
  Future<void> addCheckin(Map<String, dynamic> data) async {
    await _db.collection('checkins').add(data);
  }

  /// Stream check-ins for a specific date
  /// ⚠ Requires a composite index: [timestamp ASC/DESC]
  /// Stream check-ins for a specific date
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCheckinsForDate(
      DateTime date) {
    final start = DateTime(date.year, date.month, date.day).toUtc();
    final end = start.add(const Duration(days: 1));

    try {
      return _db
          .collection('checkins')
          .where('timestamp', isGreaterThanOrEqualTo: start)
          .where('timestamp', isLessThan: end)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (e, st) {
      print("Error in streamCheckinsForDate: $e\n$st");

      // return empty stream instead of crashing
      return const Stream.empty();
    }
  }

  /// Stream check-ins for a specific user
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCheckinsForUser(
      String uid) {
    try {
      return _db
          .collection('checkins')
          .where('userId', isEqualTo: uid)
          .snapshots();
    } catch (e, st) {
      print("Error in streamCheckinsForUser: $e\n$st");

      return const Stream.empty();
    }
  }

  /// Delete a user and their check-ins
  Future<void> deleteUser(String uid) async {
    // Delete the user document
    await _db.collection('users').doc(uid).delete();

    // Delete all check-ins of this user
    final checkins =
        await _db.collection('checkins').where('userId', isEqualTo: uid).get();
    for (var doc in checkins.docs) {
      await doc.reference.delete();
    }
  }

  /// Get a list of workers (users with role=worker)
  Future<List<Map<String, dynamic>>> getWorkersList() async {
    final snap =
        await _db.collection('users').where('role', isEqualTo: 'worker').get();
    return snap.docs.map((d) => {'id': d.id, 'data': d.data()}).toList();
  }
}
