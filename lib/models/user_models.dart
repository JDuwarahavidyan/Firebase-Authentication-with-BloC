// the two diffrent instances of same class cannot be equal in dart.
// so we need to override the == operator to compare the instances of the class.
// or else we can extends the class with Equatable class.
// Equatable class is a utility class that helps to implement value based equality without explicitly overriding == and hashCode methods.

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String name;
  final String email;
  final int? age;
  final String? id;
  final bool isFirstTime;
  final String createdAt;
  final String? role;

  const UserModel({
    required this.name,
    required this.email,
    this.age,
    this.id,
    this.isFirstTime = true,
    required this.createdAt,
    this.role,
  });

  // Factory constructor for creating a User instance from JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int?,
      isFirstTime: json['isFirstTime'] ?? true,
      createdAt: json['createdAt'],
      role: json['role'] as String?,
    );
  }

  // Method for converting a User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'isFirstTime': isFirstTime,
      'createdAt': createdAt,
      'role': role,
    };
  }

  @override
  List<Object?> get props => [name, email, age, id, isFirstTime, createdAt, role];
}



// Future<void> createData(User user) async {
//   final userCollection = FirebaseFirestore.instance.collection('users');
//   String id = userCollection.doc().id;
//   final newUser = User(
//     name: user.name,
//     email: user.email,
//     age: user.age,
//     id: id,
//   );

//   // this fetch the info to firebase
//   await userCollection.doc(id).set({
//     'name': newUser.name,
//     'email': newUser.email,
//     'age': newUser.age,
//     'id': newUser.id, // this will store id as well
//   });
// }
