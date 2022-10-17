// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, cast_nullable_to_non_nullable, require_trailing_commas, lines_longer_than_80_chars

part of 'types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Face _$FaceFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Face',
      json,
      ($checkedConvert) {
        final val = Face(
          $checkedConvert(
              'keypoints',
              (v) => (v as List<dynamic>)
                  .map((e) => Keypoint.fromJson(e as Map<String, dynamic>))
                  .toList()),
          $checkedConvert(
              'box', (v) => BoundingBox.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'boundingBox': 'box'},
    );

Keypoint _$KeypointFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Keypoint',
      json,
      ($checkedConvert) {
        final val = Keypoint(
          $checkedConvert('x', (v) => v as num),
          $checkedConvert('y', (v) => v as num),
          $checkedConvert('z', (v) => v as num?),
          $checkedConvert('score', (v) => v as num?),
          $checkedConvert('name', (v) => v as String?),
        );
        return val;
      },
    );

BoundingBox _$BoundingBoxFromJson(Map<String, dynamic> json) => $checkedCreate(
      'BoundingBox',
      json,
      ($checkedConvert) {
        final val = BoundingBox(
          $checkedConvert('xMin', (v) => v as num),
          $checkedConvert('yMin', (v) => v as num),
          $checkedConvert('xMax', (v) => v as num),
          $checkedConvert('yMax', (v) => v as num),
          $checkedConvert('width', (v) => v as num),
          $checkedConvert('height', (v) => v as num),
        );
        return val;
      },
    );
