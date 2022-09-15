import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart';

class SampleLandmark extends StatefulWidget {
  const SampleLandmark({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const SampleLandmark());
  }

  @override
  State<SampleLandmark> createState() => _SampleLandmarkState();
}

class _SampleLandmarkState extends State<SampleLandmark> {
  FaceLandmarksDetector? faceLandmarksDetector;
  @override
  void initState() {
    super.initState();
    _initializeLandmark();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Landmark'),
      ),
    );
  }

  Future<void> _initializeLandmark() async {
    faceLandmarksDetector?.dispose();
    faceLandmarksDetector = await loadFaceLandmark();
    print(faceLandmarksDetector);
  }
}
