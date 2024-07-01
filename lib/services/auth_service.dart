import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth/models/user_models.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  FirebaseAuthService(
      {FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firestore ?? FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username, String role) async {
    // Check if the username is already taken
    final QuerySnapshot query = await _firebaseFirestore
        .collection('users')
        .where('name', isEqualTo: username)
        .get();
    if (query.docs.isNotEmpty) {
      throw Exception('The Username is already taken.');
    }

    final UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final User? user = userCredential.user;

    if (user != null) {
      final userModel = UserModel(
        id: user.uid,
        name: username,
        email: email,
        createdAt: DateTime.now().toIso8601String(),
        isFirstTime: true,
        role: role,
      );
      await _firebaseFirestore.collection('users').doc(user.uid).set(
            userModel.toJson(),
          );
    }
    return user;
  }


  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserModel> getUserDetails(String userId) async {
    final DocumentSnapshot doc =
        await _firebaseFirestore.collection('users').doc(userId).get();
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<void> updatePassword(String newPassword) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await currentUser.updatePassword(newPassword);
      await _firebaseFirestore.collection('users').doc(currentUser.uid).update({
        'isFirstTime': false,
      });
    }
  }

  Future<void> validateAndUpdatePassword(String currentPassword, String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await updatePassword(newPassword);
    }
  }

  Future<bool> isFirstTimeLogin(User user) async {
    final doc = await _firebaseFirestore.collection('users').doc(user.uid).get();
    return doc.exists && doc['isFirstTime'] == true;
  }

  Future<void> sendPasswordResetEmail(String email) async {
  // Check if the email exists in Firestore
  final QuerySnapshot query = await _firebaseFirestore
      .collection('users')
      .where('email', isEqualTo: email)
      .get();

  if (query.docs.isEmpty) {
    throw Exception('No user found with this email.');
  }

  // Send password reset email
  await _firebaseAuth.sendPasswordResetEmail(email: email);
}


  Future<String> getEmailFromUsername(String username) async {
    final QuerySnapshot query = await _firebaseFirestore
        .collection('users')
        .where('name', isEqualTo: username)
        .get();
    if (query.docs.isEmpty) {
      throw Exception('No user found with this username.');
    }
    return (query.docs.first.data() as Map<String, dynamic>)['email'];
  }
}
