import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'activity_utils.dart';
import 'permission_manager.dart';

class ImageHandler {
  static final _instance = ImageHandler._internal();

  ImageHandler._internal();

  static ImageHandler get() {
    return _instance;
  }

  Future<File> getImage(BuildContext context, {bool isCamera: false}) async {
    bool isGranted = kIsWeb
        ? true
        : await PermissionManager.get().requestStoragePermission();
    if (isGranted) {
      PickedFile pickedFile = await ImagePicker().getImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      return cropImage(pickedFile.path);
    } else {
      ActivityUtils().showAlertDialog(
          context, "Please grant storage permission to access images.");
      return null;
    }
  }

  /// Crop Image
  Future<File> cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    return croppedImage;
  }

  Future<File> getVideo(BuildContext context, {bool isCamera: false}) async {
    bool isGranted = kIsWeb
        ? true
        : await PermissionManager.get().requestStoragePermission();
    if (isGranted) {
      File videoFile;
      if (isCamera) {
        PickedFile cameraVideo =
            await ImagePicker().getVideo(source: ImageSource.camera);
        videoFile = File(cameraVideo.path);
      } else {
        FilePickerResult result =
            await FilePicker.platform.pickFiles(type: FileType.video);
        videoFile = File(result.files.first.path);
      }
      return videoFile;
    } else {
      ActivityUtils().showAlertDialog(
          context, "Please grant storage permission to access video.");
      return null;
    }
  }
}
