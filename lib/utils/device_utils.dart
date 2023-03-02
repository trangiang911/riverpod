import 'package:demo_base_riverpod_1/data/enums/enums.dart';

class DeviceUtils {
  static BuildMode currentBuildMode() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.release;
    }
    var result = BuildMode.profile;

    //Little trick, since assert only runs on DEBUG mode
    assert(() {
      result = BuildMode.debug;

      return true;
    }());

    return result;
  }
}
