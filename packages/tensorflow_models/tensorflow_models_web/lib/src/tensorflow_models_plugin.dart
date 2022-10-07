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
        runtime: 'mediapipe',
        refineLandmarks: false,
        maxFaces: 1,
        // This is *required* by the model to download additional resources...
        //
        // Docs here: https://google.github.io/mediapipe/solutions/face_mesh.html
        // (Search for 'new FaceMesh')
        //
        // Since we don't create the new faceMesh.FaceMesh, we can't pass our
        // own `locateFile` function, BUT, we can override the behavior of the
        // function with this undocumented parameter :)
        //
        // Source: https://github.com/tensorflow/tfjs-models/blob/master/face-landmarks-detection/src/mediapipe/detector.ts#L47-L53
        //
        // See that the config type is subtly different:
        //   MediaPipeFaceMeshMediaPipeModelConfig   -   correct
        //   MediaPipeFaceMeshModelConfig            -   wrong
        solutionPath: 'https://cdn.jsdelivr.net/npm/@mediapipe/face_mesh',
      ),
    );
  }
}
