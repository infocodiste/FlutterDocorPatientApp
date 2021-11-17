import 'dart:async';
import 'dart:io';

import 'package:book_my_doctor/src/config/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'activity_utils.dart';
import 'firebase_uploader.dart';

class FileHandler {
  static final _instance = FileHandler._internal();

  FileHandler._internal();

  static FileHandler get() {
    return _instance;
  }

  static Future<String> getAppDirectory() async {
    Directory extDir;
    if (Platform.isIOS) {
      extDir = await getApplicationDocumentsDirectory();
    } else {
      extDir =
          await new Directory('/storage/emulated/0').create(recursive: true);
    }
    final String dirPath = '${extDir.path}/$APP_NAME';
    await Directory(dirPath).create(recursive: true);
    return dirPath;
  }

  static Future<String> createFile(String fileName) async {
    File file = File("${await getAppDirectory()}/$fileName");
    if (!file.existsSync()) {
      print("$fileName Created Successfully");
      file.createSync(recursive: true);
    }
    return file.path;
  }

  static Future<String> getThumbnailDirectory() async {
    final String extDirectoryPath = await getAppDirectory();
    final String dirPath = '$extDirectoryPath/thumb';
    await Directory(dirPath).create(recursive: true);
    return dirPath;
  }

  static Future<String> createImageFile({String imageName}) async {
    final String extDirectoryPath = await getAppDirectory();
    final String dirPath = '$extDirectoryPath/Images';
    await Directory(dirPath).create(recursive: true);
    if (imageName == null || imageName.isEmpty) {
      imageName = "image_${ActivityUtils().timestamp()}";
    }
    String filePath = "$dirPath/$imageName.jpg";
    return filePath;
  }

  static Future<String> createVideoFile({String videoName}) async {
    final String extDirectoryPath = await getAppDirectory();
    final String dirPath = '$extDirectoryPath/Videos';
    await Directory(dirPath).create(recursive: true);
    if (videoName == null || videoName.isEmpty) {
      videoName = "video_${ActivityUtils().timestamp()}";
    }
    String filePath = "$dirPath/$videoName.mp4";
    return filePath;
  }

  static Future<String> createAudioFile({String audioName}) async {
    final String extDirectoryPath = await getAppDirectory();
    final String dirPath = '$extDirectoryPath/Audios';
    await Directory(dirPath).create(recursive: true);
    if (audioName == null || audioName.isEmpty) {
      audioName = "Audio_${ActivityUtils().timestamp()}";
    }
    String filePath = "$dirPath/$audioName.mp3";
    return filePath;
  }

  Future<String> getValidFilePath(String filePath) async {
    if (Platform.isIOS) {
      String appFolderPath = filePath.substring(filePath.indexOf("/$APP_NAME"));
      Directory directory = await getApplicationDocumentsDirectory();
      String iosFilePath = "${directory.path}$appFolderPath";
      return iosFilePath;
    } else {
      return filePath;
    }
  }

  static bool deleteFile(String filePath) {
    File file = File("$filePath");
    if (!file.existsSync()) {
      print("File not found");
      return false;
    } else {
      file.deleteSync();
      return true;
    }
  }

  Future<String> uploadFileToFirebase(File file, {Function onData}) async {
    return await FirebaseUploader.get()
        .uploadFileToFBBucket(file, onData: onData);
  }

  Future<File> filePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'txt'],
    );
    return File(result.files.first.path);
  }
}
