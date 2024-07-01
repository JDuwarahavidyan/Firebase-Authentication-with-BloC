import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auth/models/user_models.dart';

class UserService {
  //firebase collection reference to users collection
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    try {
      String id = _userCollection.doc().id;
      final newUser = UserModel(
        id: id,
        name: user.name,
        email: user.email,
        age: user.age,
        isFirstTime: user.isFirstTime,
        createdAt: DateTime.now().toIso8601String(),
      );

      await _userCollection.doc(id).set(newUser.toJson());
    } catch (e) {
      print('Error creating user: $e');
      throw e;
    }
  }

  // Future<List<User>> readUsers() async {
  //   try {
  //     QuerySnapshot querySnapshot = await _userCollection.get();
  //     return querySnapshot.docs.map((e) => User.fromJson(e.data() as Map<String, dynamic>)).toList();
  //   } catch (e) {
  //     print('Error reading users: $e');
  //     throw e;
  //   }
  // }

//stream of users realtime updates
  Stream<List<UserModel>> getUsersStream() {
    return _userCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _userCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      throw e;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _userCollection.doc(user.id).update(user.toJson());
    } catch (e) {
      print('Error updating user: $e');
      throw e;
    }
  } 

  Future<void> deleteUser(String userId) async {
    try {
      await _userCollection.doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
      throw e;
    }
  }
}