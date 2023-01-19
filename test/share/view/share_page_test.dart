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

class _MockDownloadBloc extends MockBloc<DownloadEvent, DownloadState>
    implements DownloadBloc {}

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  group('SharePage', () {
    late ConvertBloc convertBloc;

    setUp(() async {
      convertBloc = _MockConvertBloc();
    });

    test('is routable', () {
      expect(
        SharePage.route(convertBloc: convertBloc),
        isA<AppPageRoute<void>>(),
      );
    });
  });

  group('ShareView', () {
    late UrlLauncherPlatform mock;
    late ConvertBloc convertBloc;
    late DownloadBloc downloadBloc;

    setUp(() {
      mock = _MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      convertBloc = _MockConvertBloc();

      when(() => convertBloc.state).thenReturn(ConvertState());
      when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
      when(
        () => mock.launchUrl(any(), any()),
      ).thenAnswer((_) async => true);

      downloadBloc = _MockDownloadBloc();
      when(() => downloadBloc.state).thenReturn(const DownloadState());
    });

    setUpAll(() {
      registerFallbackValue(LaunchOptions());
    });

    testWidgets('renders ShareBackground', (tester) async {
      await tester.pumpSubject(
        ShareView(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      expect(find.byType(ShareBackground), findsOneWidget);
    });

    testWidgets('contains a ShareBody', (tester) async {
      await tester.pumpSubject(
        ShareView(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      expect(find.byType(ShareBody), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    ShareView subject, {
    required ConvertBloc convertBloc,
    required DownloadBloc downloadBloc,
  }) =>
      pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: convertBloc),
            BlocProvider.value(value: downloadBloc),
          ],
          child: subject,
        ),
      );
}
