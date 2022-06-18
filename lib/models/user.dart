
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class User {
  String id;
  String username;
  String email;

  User(this.id, this.username, this.email);

  User.fromFirebaseUser(fb_auth.User fbUser, String username)
      : id = fbUser.uid,
        username = username,
        email = fbUser.email!;

  User.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        username = snapshot['username'],
        email = snapshot['email'];

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'username': username, 'email': email};

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email}';
  }
}
