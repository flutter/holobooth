import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/bloc/share_bloc.dart';
import 'package:io_photobooth/share/widgets/widgets.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockShareBloc extends MockBloc<ShareEvent, ShareState>
    implements ShareBloc {}

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  late ShareBloc shareBloc;
  late UrlLauncherPlatform mock;

  group('TwitterButton', () {
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

    testWidgets('dismissed after tapping', (tester) async {
      await tester.pumpSubject(TwitterButton(), shareBloc);
      await tester.tap(find.byType(TwitterButton));
      await tester.pumpAndSettle();
      expect(find.byType(TwitterButton), findsNothing);
      verify(() => shareBloc.add(const ShareTapped(shareUrl: ShareUrl.twitter)))
          .called(1);
    });

    testWidgets('opens link when sharing is successful', (tester) async {
      when(() => shareBloc.state).thenReturn(
        ShareState(
          shareStatus: ShareStatus.success,
          shareUrl: ShareUrl.twitter,
          twitterShareUrl: 'https://twitter.com',
        ),
      );
      await tester.pumpSubject(TwitterButton(), shareBloc);
      await tester.tap(find.byType(TwitterButton));
      await tester.pumpAndSettle();
      verify(
        () => mock.launchUrl('https://twitter.com', any()),
      ).called(1);
      expect(find.byType(TwitterButton), findsNothing);
      verifyNever(
        () => shareBloc.add(const ShareTapped(shareUrl: ShareUrl.twitter)),
      );
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(TwitterButton subject, ShareBloc bloc) => pumpApp(
        MultiBlocProvider(
          providers: [BlocProvider.value(value: bloc)],
          child: subject,
        ),
      );
}
