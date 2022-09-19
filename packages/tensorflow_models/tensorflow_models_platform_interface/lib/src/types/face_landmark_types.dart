typedef Faces = List<Face>;

class Keypoint {
  Keypoint(this.x, this.y, this.z, this.score, this.name);

  final num x;
  final num y;
  final num? z;
  final num? score;
  final String? name;
}

class Face {
  const Face(this.keypoints);

  factory Face.fromJs(List<dynamic> keyPointsJs) {
    return Face(
      keyPointsJs.map(
        (e) {
          final map = e as Map<String, dynamic>;
          return Keypoint(
            map['x'] as num,
            map['y'] as num,
            map['z'] as num?,
            map['score'] as num?,
            map['name'] as String?,
          );
        },
      ).toList(),
    );
  }

  final List<Keypoint> keypoints;
}

class EstimationConfig {
  const EstimationConfig({
    this.flipHorizontal = false,
    this.staticImageMode = true,
  });

  final bool flipHorizontal;
  final bool staticImageMode;
}

abstract class FaceLandmarksDetector {
  Future<Faces> estimateFaces(
    dynamic object, {
    EstimationConfig estimationConfig = const EstimationConfig(),
  });

  void dispose();
}
