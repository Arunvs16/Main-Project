import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:main_project/utils/cropped_image.dart';
import 'package:main_project/utils/utils.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  void pickImage(bool pickGalleryImage) async {
    XFile? image;
    final picker = ImagePicker();

    // For pick from gallery
    if (pickGalleryImage == true) {
      image = await picker.pickImage(source: ImageSource.gallery);
    } else {
      image = await picker.pickImage(source: ImageSource.camera);
    }

    if (image != null) {
      final croppedImage = await cropImages(image);

      if (croppedImage != null) {
        if (!mounted) return;
        print("Cropping was successful.");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CroppedImage(
              image: croppedImage,
            ),
          ),
        );
      } else {
        // Handle the case where cropping was not successful
        print("Cropping was not successful.");
      }
    } else {
      // Handle the case where picking an image was not successful
      print("Picking image was not successful.");
    }
  }

  Future<CroppedFile?> cropImages(XFile image) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
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

    if (croppedFile == null) {
      // Handle the case where cropping was not successful
      print("Cropping was not successful.");
    }

    return croppedFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Add Post"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    pickImage(false);
                  },
                  child: Text(
                    "Camera",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    pickImage(true);
                  },
                  child: Text(
                    "Gallery",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
