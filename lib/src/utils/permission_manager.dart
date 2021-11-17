import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static final _instance = PermissionManager._internal();

  PermissionManager._internal();

  static PermissionManager get() {
    return _instance;
  }

  Future<bool> requestStoragePermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage].request();
    if (statuses[Permission.storage] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestLocationPermission() async {
    PermissionStatus statuses = await Permission.location.request();
    if (await Permission.location.request().isGranted) {
      return true;
    }
    return false;
  }
}
