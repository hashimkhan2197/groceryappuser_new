import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  final _imagePicker = ImagePicker();

  Future _pickImage() async {
    final pickedImageFile = await _imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0,bottom: 4),
      child: Column(
        children: <Widget>[
          FittedBox(
            child: Container(

              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey,width: 1)
              ),

              width: 120,
              height: 120,
              child: ClipRRect(
                child: _pickedImage != null?Image(
                  fit: BoxFit.contain,
                  alignment: Alignment.topRight,
                  image: FileImage(_pickedImage)): Container(),
              ),
            ),
          ),
//
          FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text("Add Image"),
          ),
        ],
      ),
    );
  }
}
