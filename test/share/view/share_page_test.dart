import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockShareBloc extends MockBloc<ShareEvent, ShareState>
    implements ShareBloc {}

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  group('SharePage', () {
    test('is routable', () {
      expect(SharePage.route([]), isA<AppPageRoute<void>>());
    });
  });

  group('ShareView', () {
    late ShareBloc shareBloc;
    late UrlLauncherPlatform mock;

    setUp(() {
      mock = _MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      shareBloc = _MockShareBloc();

      when(() => shareBloc.state).thenReturn(ShareState());
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
        shareBloc,
      );
      expect(find.byType(ShareBackground), findsOneWidget);
    });

    testWidgets('contains a ShareBody', (tester) async {
      await tester.pumpSubject(
        ShareView(),
        shareBloc,
      );
      expect(find.byType(ShareBody), findsOneWidget);
    });

    testWidgets('opens the correct twitter url when ShareStatus is successful',
        (tester) async {
      whenListen(
        shareBloc,
        Stream.fromIterable([
          ShareState(),
          ShareState(
            shareUrl: ShareUrl.twitter,
            shareStatus: ShareStatus.success,
            twitterShareUrl: 'http://twitter.com',
          )
        ]),
      );
      await tester.pumpSubject(
        ShareView(),
        shareBloc,
      );
      await tester.pumpAndSettle();
      verify(
        () => mock.launchUrl('http://twitter.com', any()),
      ).called(1);
    });

    testWidgets('opens the correct facebook url when ShareStatus is successful',
        (tester) async {
      whenListen(
        shareBloc,
        Stream.fromIterable([
          ShareState(),
          ShareState(
            shareUrl: ShareUrl.facebook,
            shareStatus: ShareStatus.success,
            facebookShareUrl: 'http://facebook.com',
          )
        ]),
      );
      await tester.pumpSubject(
        ShareView(),
        shareBloc,
      );
      await tester.pumpAndSettle();
      verify(
        () => mock.launchUrl('http://facebook.com', any()),
      ).called(1);
    });

    testWidgets('opens the explicit share url when ShareStatus is successful',
        (tester) async {
      whenListen(
        shareBloc,
        Stream.fromIterable([
          ShareState(),
          ShareState(
            shareStatus: ShareStatus.success,
            explicitShareUrl: 'http://google.com',
          )
        ]),
      );
      await tester.pumpSubject(
        ShareView(),
        shareBloc,
      );
      await tester.pumpAndSettle();
      verify(
        () => mock.launchUrl('http://google.com', any()),
      ).called(1);
    });

    testWidgets('opens the correct url when a different button is pressed',
        (tester) async {
      whenListen(
        shareBloc,
        Stream.fromIterable([
          ShareState(
            shareUrl: ShareUrl.facebook,
            shareStatus: ShareStatus.success,
          ),
          ShareState(
            shareUrl: ShareUrl.twitter,
            shareStatus: ShareStatus.success,
            twitterShareUrl: 'http://twitter.com',
          )
        ]),
      );
      await tester.pumpSubject(
        ShareView(),
        shareBloc,
      );
      await tester.pumpAndSettle();
      verify(
        () => mock.launchUrl('http://twitter.com', any()),
      ).called(1);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareView subject, ShareBloc bloc) => pumpApp(
        MultiBlocProvider(
          providers: [BlocProvider.value(value: bloc)],
          child: subject,
        ),
      );
}
