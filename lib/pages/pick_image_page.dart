import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:main_project/utils/add_post_page.dart';

class PicImagePage extends StatefulWidget {
  const PicImagePage({super.key});

  @override
  State<PicImagePage> createState() => _PicImagePageState();
}

class _PicImagePageState extends State<PicImagePage> {
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
            builder: (context) => AddPostToFeed(
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
          toolbarColor: Theme.of(context).colorScheme.surface,
          cropStyle: CropStyle.rectangle,
          activeControlsWidgetColor: Theme.of(context).colorScheme.onPrimary,
          toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
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
      backgroundColor: Theme.of(context).colorScheme.surface,
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
