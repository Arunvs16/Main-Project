import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main_project/model/post_model.dart';
import 'package:main_project/services/storage.dart';
import 'package:uuid/uuid.dart';

class CloudMethods {
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  uploadPost({
    required String uid,
    required String name,
    required String username,
    String? pic,
    required String description,
    required Uint8List file,
  }) async {
    String res = 'waiting';
    try {
      String postId = Uuid().v1();
      String postImage =
          await StorageMethods().uploadImageToStorage(file, 'posts', true);
      PostModel postModel = PostModel(
        uid: uid,
        name: name,
        username: username,
        pic: pic ?? '',
        description: description,
        postID: postId,
        postImage: postImage,
        date: Timestamp.now(),
        like: [],
      );
      posts.doc(postId).set(postModel.toJson());
      res = 'Success';
    } on Exception catch (e) {
      res = e.toString();
    }
    return res;
  }

  editProfile({
    required String uid,
    required String name,
    required String username,
    String bio = '',
    Uint8List? file,
  }) async {
    String res = 'error';
    try {
      // Check conditions before performing operations
      if (file != null) {
        String pic =
            await StorageMethods().uploadImageToStorage(file, 'users', false);
        if (name.isNotEmpty && username.isNotEmpty) {
          await users.doc(uid).update(
              {'name': name, 'username': username, 'pic': pic, 'bio': bio});
          // Query documents where 'uid' field is equal to the specified UID
          QuerySnapshot querySnapshot =
              await posts.where('uid', isEqualTo: uid).get();

          // Create a batch to perform multiple writes atomically
          WriteBatch batch = FirebaseFirestore.instance.batch();

          // Iterate through the documents and update each one
          querySnapshot.docs.forEach((doc) {
            // Get a reference to the document
            DocumentReference docRef = posts.doc(doc.id);

            // Update the document with the new data
            batch.update(
                docRef, {'name': name, 'username': username, 'pic': pic});
          });

          // Commit the batch to update all documents atomically
          await batch.commit();
        }
      } else {
        if (name.isNotEmpty && username.isNotEmpty) {
          await users
              .doc(uid)
              .update({'name': name, 'username': username, 'bio': bio});
          // Query documents where 'uid' field is equal to the specified UID
          QuerySnapshot querySnapshot =
              await posts.where('uid', isEqualTo: uid).get();

          // Create a batch to perform multiple writes atomically
          WriteBatch batch = FirebaseFirestore.instance.batch();

          // Iterate through the documents and update each one
          querySnapshot.docs.forEach((doc) {
            // Get a reference to the document
            DocumentReference docRef = posts.doc(doc.id);

            // Update the document with the new data
            batch.update(docRef, {'name': name, 'username': username});
          });

          // Commit the batch to update all documents atomically
          await batch.commit();
        }
      }
      // Return a success message
      res = 'Success';
    } catch (e) {
      // Handle exceptions
      return e.toString();
    }
    return res;
  }

  commentToPost(
      {required String postId,
      required String uid,
      required String comment,
      required String pic,
      required String name,
      required String username}) async {
    String res = 'error';
    try {
      if (comment.isNotEmpty) {
        String commentId = Uuid().v1();
        await posts.doc(postId).collection('comments').doc(commentId).set({
          'uid': uid,
          'postId': postId,
          'commentId': commentId,
          'pic': pic,
          'name': name,
          'username': username,
          'comment': comment,
          'date': DateTime.now()
        });
      }
      res = 'Success';
    } on Exception catch (e) {
      return e.toString();
    }
    return res;
  }

  likePost(String postId, String uid, List like) {
    String res = 'Error';

    try {
      if (like.contains(uid)) {
        posts.doc(postId).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        posts.doc(postId).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
      res = 'Success';
    } on Exception catch (e) {
      return e.toString();
    }
    return res;
  }

  followUser(String uid, String followUserId) async {
    String res = 'Error';
    DocumentSnapshot documentSnapshot = await users.doc(uid).get();
    List following = (documentSnapshot.data() as dynamic)['following'];
    try {
      if (following.contains(followUserId)) {
        users.doc(uid).update({
          'following': FieldValue.arrayRemove([followUserId])
        });
        users.doc(followUserId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
      } else {
        users.doc(uid).update({
          'following': FieldValue.arrayUnion([followUserId])
        });
        users.doc(followUserId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
      }
      res = 'Success';
    } on Exception catch (e) {
      return e.toString();
    }
    return res;
  }

  deletePost(String postId) async {
    String res = 'error';
    try {
      await posts.doc(postId).delete();
      res = 'Success';
    } catch (e) {
      return e.toString();
    }
    return res;
  }
}
