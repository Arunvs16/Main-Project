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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Upload',
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 1 / 3,
                  width: MediaQuery.of(context).size.height * 1 / 3,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Image(
                    image: FileImage(
                      File(widget.image.path),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: MediaQuery.of(context).size.height * 1 / 4,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: TextField(
                    maxLines: 6,
                    maxLength: 250,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.secondary,
                      hintText: 'Add caption',
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
