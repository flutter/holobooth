import 'package:camera/camera.dart';

extension PhotboothCameraController on CameraController {
  dynamic get videoElement {
    throw UnsupportedError('videoElement is only available on the web');
  }
}
