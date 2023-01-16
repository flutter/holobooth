import 'dart:typed_data';
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockConvertBloc extends MockBloc<ConvertEvent, ConvertState>
    implements ConvertBloc {}

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  group('SharePage', () {
    late Uint8List firstFrame;

    late ConvertBloc convertBloc;
    setUp(() async {
      final image = await createTestImage(height: 10, width: 10);
      final bytesImage = await image.toByteData(format: ImageByteFormat.png);
      firstFrame = bytesImage!.buffer.asUint8List();
      convertBloc = _MockConvertBloc();
    });

    test('is routable', () {
      expect(
        SharePage.route(
          firstFrame: firstFrame,
          videoPath: '',
          convertBloc: convertBloc,
        ),
        isA<AppPageRoute<void>>(),
      );
    });
  });

  group('ShareView', () {
    late UrlLauncherPlatform mock;
    late ConvertBloc convertBloc;

    setUp(() {
      mock = _MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      convertBloc = _MockConvertBloc();

      when(() => convertBloc.state).thenReturn(ConvertState());
      when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
      when(
        () => mock.launchUrl(any(), any()),
      ).thenAnswer((_) async => true);
    });

    setUpAll(() {
      registerFallbackValue(LaunchOptions());
    });

    testWidgets('renders ShareBackground', (tester) async {
      await tester.pumpSubject(
        ShareView(),
        convertBloc,
      );
      expect(find.byType(ShareBackground), findsOneWidget);
    });

    testWidgets('contains a ShareBody', (tester) async {
      await tester.pumpSubject(
        ShareView(),
        convertBloc,
      );
      expect(find.byType(ShareBody), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareView subject, ConvertBloc bloc) => pumpApp(
        BlocProvider.value(
          value: bloc,
          child: subject,
        ),
      );
}
