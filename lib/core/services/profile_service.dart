
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save user profile
  Future<void> saveProfile({
    required String fullName,
    required String targetRole,
    required String experience,
    required String skills,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set({
      'fullName': fullName,
      'targetRole': targetRole,
      'experience': experience,
      'skills': skills,
      'email': user.email,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveResumePath(String path) async {
  final user = _auth.currentUser;

  if (user == null) {
    throw Exception('User is not logged in');
  }

  await _firestore
      .collection('users')
      .doc(user.uid)
      .set({
    'resumePath': path,
    'updatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}

  // Get user profile
  Future<DocumentSnapshot<Map<String, dynamic>>> getProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    return await _firestore
        .collection('users')
        .doc(user.uid)
        .get();
  }
}
