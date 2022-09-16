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
  Face(this.keypoints);
  final List<Keypoint> keypoints;
}

abstract class FaceLandmarksDetector {
  Future<Faces> estimateFaces(dynamic object);

  void dispose();
}
