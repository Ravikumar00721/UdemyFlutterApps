import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key, required this.onPickedImage});

  final void Function(File pickedImage) onPickedImage;

  @override
  State<ImagePickerWidget> createState() {
    return _ImagePickerWidgetState();
  }
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _pickedImageFile;

  void _imgPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    if (pickedFile == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedFile.path); // Convert XFile to File
    });
    widget.onPickedImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedImageFile != null
              ? FileImage(_pickedImageFile!) // Set image if available
              : null,
        ),
        TextButton.icon(
          icon: const Icon(Icons.image),
          onPressed: _imgPicker,
          label: Text(
            "Add Image",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
