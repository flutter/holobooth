import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:tensorflow_models_web/src/face-landmarks-detection/face_landmarks_detection_bridge.dart'
    as landmark;
import 'package:tensorflow_models_web/src/face-landmarks-detection/interop/interop.dart'
    as landmark_interop;
import 'package:tensorflow_models_web/src/posenet/interop/interop.dart'
    as interop;
import 'package:tensorflow_models_web/src/posenet/posenet_bridge.dart'
    as posenet;

class TensorflowModelsPlugin extends TensorflowModelsPlatform {
  static void registerWith(Registrar registrar) {
    TensorflowModelsPlatform.instance = TensorflowModelsPlugin();
  }

  @override
  Future<PoseNet> loadPosenet([ModelConfig? config]) {
    return posenet.load(
      interop.ModelConfig(
        architecture: config?.architecture,
        outputStride: config?.outputStride,
        inputResolution: config?.inputResolution,
        multiplier: config?.multiplier,
        quantBytes: config?.quantBytes,
      ),
    );
  }

  @override
  Future<FaceLandmarksDetector> loadFaceLandmark() {
    return landmark.createDetector(
      landmark_interop.MediaPipeFaceMeshMediaPipeModelConfig(
        runtime: 'mediapipe',
        refineLandmarks: true,
        maxFaces: 1,
      ),
    );
  }
}
