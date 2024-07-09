import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String username;
  String email;
  String bio;
  String pic;
  String followers;
  String following;

  UserModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.bio,
    required this.pic,
    required this.followers,
    required this.following,
  });
  factory UserModel.fromJson(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'],
      name: data['name'],
      username: data['username'],
      email: data['email'],
      bio: data['bio'],
      pic: data['pic'],
      followers: data['followers'],
      following: data['following'],
    );
  }
  Map<String, dynamic> tojson() => {
    'uid': uid,
    'name': name,
    'username': username,
    'email': email,
    'bio': bio,
    'pic': pic,
    'followers': followers,
    'following': following,
  };
}
