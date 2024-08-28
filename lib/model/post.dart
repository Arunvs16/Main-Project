import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  String email;
  String username;
  String caption;
  String postID;
  String imageURL;
  Timestamp timestamp;
  List<String> likes;

  PostData({
    required this.email,
    required this.username,
    required this.caption,
    required this.postID,
    required this.imageURL,
    required this.timestamp,
    required this.likes,
  });

  factory PostData.fromJson(DocumentSnapshot data) {
    return PostData(
      email: data['email'],
      username: data['username'],
      caption: data['caption'],
      postID: data.id,
      imageURL: data['imageURL'],
      timestamp: data['timestamp'],
      likes: data['likes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "username": username,
      "caption": caption,
      "postID": postID,
      "imageURL": imageURL,
      "timestamp": timestamp,
      "likes": likes,
    };
  }
}
