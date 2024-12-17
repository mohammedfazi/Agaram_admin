import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';


class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  Uint8List? _imageBytes;
  String? _imageName;

  void _pickImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);

      reader.onLoadEnd.listen((e) {
        setState(() {
          _imageBytes = reader.result as Uint8List;
          _imageName = files[0].name;
          print(_imageBytes);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text("Pick an Image"),
          ),
          if (_imageBytes != null)
            Column(
              children: [
                Image.memory(_imageBytes!),
                Text("Image selected: $_imageName"),
              ],
            ),
        ],
      ),
    );
  }
}
