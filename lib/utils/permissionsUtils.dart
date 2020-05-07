import 'package:permission_handler/permission_handler.dart';

class PermissionsUtils {
  static Future<bool> requestPermission(PermissionHandler permissionHandler,
      PermissionGroup permissionGroup) async {
    var result = await permissionHandler.requestPermissions([permissionGroup]);

    if (result[permissionGroup] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<PermissionStatus> checkPermission(
      PermissionGroup permissionGroup) async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(permissionGroup);
    return permission;
  }
}
