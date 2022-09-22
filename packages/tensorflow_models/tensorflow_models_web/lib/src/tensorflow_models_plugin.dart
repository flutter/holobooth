import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:tensorflow_models_web/src/face_landmarks_detection/face_landmarks_detection_bridge.dart'
    as landmark;
import 'package:tensorflow_models_web/src/face_landmarks_detection/interop/interop.dart'
    as landmark_interop;

class TensorflowModelsPlugin extends TensorflowModelsPlatform {
  static void registerWith(Registrar registrar) {
    TensorflowModelsPlatform.instance = TensorflowModelsPlugin();
  }

  @override
  Future<FaceLandmarksDetector> loadFaceLandmark() {
    return landmark.FaceLandmarksDetectorWeb.load(
      landmark_interop.MediaPipeFaceMeshMediaPipeModelConfig(
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
