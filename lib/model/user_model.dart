import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String username;
  String email;
  String bio;
  String proPic;
  String followers;
  String following;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.bio,
    required this.proPic,
    required this.followers,
    required this.following,
  });
  factory UserModel.fromJson(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'],
      username: data['username'],
      email: data['email'],
      bio: data['bio'],
      proPic: data['pic'],
      followers: data['followers'],
      following: data['following'],
    );
  }
  Map<String, dynamic> tojson() => {
    'uid': uid,
    'username': username,
    'email': email,
    'bio': bio,
    'pic': proPic,
    'followers': followers,
    'following': following,
  };
}
