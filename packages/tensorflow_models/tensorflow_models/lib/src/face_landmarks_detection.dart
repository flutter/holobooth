import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

/// Loads FaceLandmarksDetector
Future<FaceLandmarksDetector> loadFaceLandmark() async {
  return TensorflowModelsPlatform.instance.loadFaceLandmark();
}
