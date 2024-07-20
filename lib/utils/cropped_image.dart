import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CroppedImage extends StatefulWidget {
  final CroppedFile image;

  const CroppedImage({
    super.key,
    required this.image,
  });

  @override
  State<CroppedImage> createState() => _CroppedImageState();
}

class _CroppedImageState extends State<CroppedImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Cropped Image"),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image(
            image: FileImage(
              File(widget.image.path),
            ),
          ),
        ),
      ),
    );
  }
}
