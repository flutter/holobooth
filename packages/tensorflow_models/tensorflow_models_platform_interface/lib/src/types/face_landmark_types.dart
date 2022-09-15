class Keypoint {
  Keypoint(this.x, this.y, this.z, this.score, this.name);

  final num x;
  final num y;
  final num? z;
  final num? score;
  final String? name;
}

class Face {
  Face(this.keypoints);
  final List<Keypoint> keypoints;
}

abstract class FaceLandmarksDetector {
  Future<List<Face>> estimateFaces();
  void dispose();
}
