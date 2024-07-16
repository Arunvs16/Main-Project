import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  uploadImageToStorage(Uint8List file, String childName, bool isPost) async {
    String id = Uuid().v1();
    Reference ref;
    if (isPost) {
      ref = _storage
          .ref()
          .child(childName)
          .child(_auth.currentUser!.uid)
          .child(id);
    } else {
      ref = _storage.ref().child(childName).child(
            _auth.currentUser!.uid,
          );
    }
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
