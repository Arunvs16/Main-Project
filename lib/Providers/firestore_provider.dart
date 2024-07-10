import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataProvider {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // stream of data from firestore document
  Stream<DocumentSnapshot> get documentStream {
    return _firestore.collection("Users").doc(currentUser.email).snapshots();
  }
}

class CommentDataProvider {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // stream of ordered data from firestore collection
  Stream<QuerySnapshot> get oderedDataStream {
    return _firestore
        .collection("comments")
        .orderBy("Timestamp", descending: true)
        .snapshots();
  }

  // stream of data from firestore document
  Stream<DocumentSnapshot> get documentStream {
    return _firestore.collection("comments").doc().snapshots();
  }
}
