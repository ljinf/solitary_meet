import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

Future<String?> imageCrop(String sourcePath) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: sourcePath,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPresetCustom(),
        ],
      ),
      IOSUiSettings(
        title: 'Cropper',
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPresetCustom(),
          // IMPORTANT: iOS supports only one custom aspect ratio in preset list
        ],
      ),
      /* WebUiSettings(
        context: context,
      ),*/
    ],
  );

  if (croppedFile == null) {
    return "";
  }

  return croppedFile.path;
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
