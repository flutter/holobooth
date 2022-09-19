import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

abstract class TensorFlowFaceLandmarks {
  static Future<FaceLandmarksDetector> load() async =>
      TensorflowModelsPlatform.instance.loadFaceLandmark();
}
