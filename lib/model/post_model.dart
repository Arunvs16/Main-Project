class PostModel {
  String userName;
  String userEmail;
  String userID;
  String caption;
  String postID;
  String imageURL;
  List<String> like;

  PostModel({
    required this.userName,
    required this.userEmail,
    required this.userID,
    required this.caption,
    required this.postID,
    required this.imageURL,
    required this.like,
  });

  factory PostModel.fromJson(Map<String, dynamic> data) {
    return PostModel(
      userName: data['userName'],
      userEmail: data['userEmail'],
      userID: data['userID'],
      caption: data['caption'],
      postID: data['postID'],
      imageURL: data['imageURL'],
      like: data['like'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "userEmail": userEmail,
      "userID": userID,
      "caption": caption,
      "postID": postID,
      "imageURL": imageURL,
      "like": like,
    };
  }
}
