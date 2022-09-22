import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

// TODO(oscar): check if we should use singleton class or load model everytime
abstract class TensorFlowFaceLandmarks {
  static Future<FaceLandmarksDetector> load() async =>
      TensorflowModelsPlatform.instance.loadFaceLandmark();
}
