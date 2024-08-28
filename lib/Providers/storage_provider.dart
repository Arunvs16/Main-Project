import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageProvider with ChangeNotifier {
  // firebase storage
  final firebaseStorage = FirebaseStorage.instance;

  // images are stored in firebase as download Urls
  List<String> _imageUrls = [];

  // is loading
  bool _isLoading = false;

  // is uploading
  bool _isUploading = false;

  // getters
  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  // read-----------------------------------------------------------------------
  Future<void> fetchPostImage() async {
    // start loading
    _isLoading = true;

    // grt the list under the directory: Uploaded_images/
    final ListResult result =
        await firebaseStorage.ref("uploaded_images/").listAll();

    // get download urls for each iamges
    final urls = await Future.wait(
      result.items.map(
        (ref) => ref.getDownloadURL(),
      ),
    );

    // update urls
    _imageUrls = urls;

    // loading finished
    _isLoading = false;

    // update UI
    notifyListeners();
  }

  // delete---------------------------------------------------------------------
  Future<void> deletePostImage(String imageUrl) async {
    try {
      // remove from local list
      _imageUrls.remove(imageUrl);

      // get path name and delete from firestore
      final String path = extractPathFromUrl(imageUrl);
      await firebaseStorage.ref(path).delete();
    } catch (e) {
      print('Error deleting image: $e');
    }

    // update ui
    notifyListeners();
  }

  String extractPathFromUrl(String url) {
    Uri uri = Uri.parse(url);

    // extract the part of the url we need
    String encodedPath = uri.pathSegments.last;

    // uri decoding the path
    return Uri.decodeComponent(encodedPath);
  }

  // upload---------------------------------------------------------------------
  Future<void> uploadImage(File file) async {
    // start upload
    _isUploading = true;

    // update UI
    notifyListeners();

    try {
      // define the path in storage
      String filePath = 'images/${DateTime.now()}.jpg';

      // upload the file to firebase storage
      await firebaseStorage.ref(filePath).putFile(file);

      // after uploading, fetch the download Url
      String downlaodUrl = await firebaseStorage.ref(filePath).getDownloadURL();

      // upload the image urls list
      _imageUrls.add(downlaodUrl);

      // update UI
      notifyListeners();
    } catch (e) {
      print("Error Uploading: $e ");
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
