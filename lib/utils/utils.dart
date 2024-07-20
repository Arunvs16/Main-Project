import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Utils {
  Utils._();

  // get unique ID
  String getUniqueID() {
    return Uuid().v4().toString();
  }

  // pick image from gallery and return a file
  Future<XFile?> selectImagefromGallery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Future<CroppedFile?> cropSelectImage(
      BuildContext context, String filePath) async {
    return await ImageCropper().cropImage(
      sourcePath: filePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Theme.of(context).colorScheme.inversePrimary,
          toolbarWidgetColor: Theme.of(context).colorScheme.primary,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );
  }

  // upload image to firebase
  Future uploadImage({
    required String imagePathID,
    required File file,
  }) async {
    String fileName = 'post.jpeg';
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('posts/$imagePathID/$fileName');
    await ref.putFile(file);
  }
}
