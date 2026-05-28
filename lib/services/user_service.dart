import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream a user's document for real-time updates
  Stream<AppUser?> userStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? AppUser.fromFirestore(doc) : null);
  }

  /// Update a user's profile information
  Future<void> updateUser(String userId, AppUser user) async {
    await _firestore.collection('users').doc(userId).update(user.toMap());
  }
}
