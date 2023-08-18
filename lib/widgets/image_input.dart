// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPaths;
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  var isDiableWidget = false;
  final Function(bool) checkPicClicked;
  final Function onSelectImage;

  ImageInput(this.isDiableWidget, this.checkPicClicked, this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  var imgPicBtnStr = 'Take Pic';
  bool _isPicTaken = false;
  late File _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 80);

    if (imageFile == null) {
      return;
    }

    setState(() {
      _storedImage = File(imageFile.path);
      _isPicTaken = true;
      widget.checkPicClicked(true);
      imgPicBtnStr = 'Re-Take Pic';
    });

    final appDir = await sysPaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImageFile =
        await File(imageFile.path).copy('${appDir.path}/${fileName}');

    widget.onSelectImage(savedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 5,
      child: Container(
        height: screenHeight * 0.42,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: screenHeight * 0.005),
              child: Text(
                'Take the Pic of Classroom',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: (screenWidth * 0.9),
              height: (screenHeight * 0.40) * 0.7,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              child: _isPicTaken == true
                  ? Image.file(
                      _storedImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Text(
                      'No Image \nTaken!',
                      textAlign: TextAlign.center,
                    ),
            ),
            SizedBox(
              height: (screenHeight * 0.40) * 0.03,
            ),
            Container(
              height: (screenHeight * 0.40) * 0.15,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  primary: Colors.blue.shade800,
                ),
                icon: Icon(Icons.camera),
                label: Text(
                  '$imgPicBtnStr',
                  textAlign: TextAlign.center,
                ),
                onPressed: widget.isDiableWidget ? null : _takePicture,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
