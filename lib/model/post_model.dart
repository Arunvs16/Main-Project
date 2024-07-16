import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final DocumentReference reference;
  final String? id;
  final String? title;
  final String? creatorId;
  final String? creatorImageId;
  final String? imagePathId;
  final List<String>? likedBy;
  final int? totalLikes;
  final int? totalComments;
  final int? timestamp;

  Post({
    required this.reference,
    required this.id,
    required this.title,
    required this.creatorId,
    required this.creatorImageId,
    required this.imagePathId,
    required this.likedBy,
    required this.totalLikes,
    required this.totalComments,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "creatorId": creatorId,
      "": creatorImageId,
      "imagePathId": imagePathId,
      "likedBy": likedBy,
      "totalLikes": totalLikes,
      "totalComments": totalComments,
      "timestamp": timestamp,
    };
  }

  @override
  String toString() {
    return "Post - id: $id, title:$title, creatorId: $creatorId";
  }
}
