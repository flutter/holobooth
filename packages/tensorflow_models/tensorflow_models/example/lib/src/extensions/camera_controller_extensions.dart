import 'package:camera/camera.dart';

extension CameraControllerX on CameraController? {
  bool get isCameraAvailable => (this?.value.isInitialized) ?? false;
}
