/// Set of tags used to filter tests.
///
/// For example, golden test can be run with:
/// ```
/// flutter test --tags golden
/// ```
///
/// **NOTE**: Tags should be registered on the `dart_test.yaml` file.
abstract class TestTag {
  static const golden = 'golden';
}
