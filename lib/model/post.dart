import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  String email;
  String caption;
  String postID;
  String imageURL;
  Timestamp timestamp;
  List<String> like;

  PostData({
    required this.email,
    required this.caption,
    required this.postID,
    required this.imageURL,
    required this.timestamp,
    required this.like,
  });

  factory PostData.fromJson(DocumentSnapshot data) {
    return PostData(
      email: data['email'],
      caption: data['caption'],
      postID: data.id,
      imageURL: data['imageURL'],
      timestamp: data['timestamp'],
      like: data['like'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "caption": caption,
      "postID": postID,
      "imageURL": imageURL,
      "timestamp": timestamp,
      "like": like,
    };
  }
}
