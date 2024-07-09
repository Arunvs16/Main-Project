import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String uid;
  String name;
  String username;
  String pic;
  String description;
  String postID;
  String postImage;
  Timestamp date;
  dynamic like;

  PostModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.pic,
    required this.description,
    required this.postID,
    required this.postImage,
    required this.date,
    required this.like,
  });
  factory PostModel.FromJson(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return PostModel(
      uid: data['uid'],
      name: data['name'],
      username: data['username'],
      pic: data['pic'],
      description: data['description'],
      postID: data['postID'],
      postImage: data['postImage'],
      date: data['date'],
      like: data['like'],
    );
  }
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'username': username,
        'pic': pic,
        'description': description,
        'postID': postID,
        'postImage': postImage,
        'date': date,
        'like': like,
      };
}
