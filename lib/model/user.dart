import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String uid;
  String name;
  String username;
  String email;
  String bio;
  String profilePic;

  UserProfile.UserData({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.bio,
    required this.profilePic,
  });

  factory UserProfile.fromMap(DocumentSnapshot doc) {
    return UserProfile.UserData(
      uid: doc['uid'],
      name: doc['name'],
      username: doc['username'],
      email: doc['email'],
      bio: doc['bio'],
      profilePic: doc['profilePic'],
    );
  }
  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'username': username,
        'email': email,
        'bio': bio,
        'pic': profilePic,
      };
}
