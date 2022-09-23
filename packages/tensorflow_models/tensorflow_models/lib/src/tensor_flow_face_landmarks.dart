import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

// TODO(oscar): Check if we should use singleton class or load model everytime.
// TODO(oscar): document this class
//Brief sentence explaining what it is
//A url to the official tensorflow face landmark documentation
//A url to the source code from tsjs-models
abstract class TensorFlowFaceLandmarks {
  static Future<FaceLandmarksDetector> load() async =>
      TensorflowModelsPlatform.instance.loadFaceLandmark();
}
