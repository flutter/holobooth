import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:tensorflow_models_web/src/face_landmarks_detection/face_landmarks_detection.dart'
    as landmark;

class TensorflowModelsPlugin extends TensorflowModelsPlatform {
  static void registerWith(Registrar registrar) {
    TensorflowModelsPlatform.instance = TensorflowModelsPlugin();
  }

  @override
  Future<FaceLandmarksDetector> loadFaceLandmark() {
    return landmark.FaceLandmarksDetectorWeb.load(
      landmark.MediaPipeFaceMeshMediaPipeModelConfig(
        // TODO(oscar): not working because of missing constructor Mesh
        // https://github.com/google/mediapipe/issues/1976
        // runtime: 'mediapipe',
        runtime: 'tfjs',
        refineLandmarks: true,
        maxFaces: 1,
      ),
    );
  }
}
