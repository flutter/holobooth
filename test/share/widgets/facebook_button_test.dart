import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/share/share.dart';
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
  group('FacebookButton', () {
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

    testWidgets('dismissed after tapping', (tester) async {
      await tester.pumpSubject(FacebookButton(), shareBloc);
      await tester.tap(find.byType(FacebookButton));
      await tester.pumpAndSettle();
      expect(find.byType(FacebookButton), findsNothing);
      verify(
        () => shareBloc.add(const ShareTapped(shareUrl: ShareUrl.facebook)),
      ).called(1);
    });

    testWidgets('opens link when sharing is successful', (tester) async {
      when(() => shareBloc.state).thenReturn(
        ShareState(
          shareStatus: ShareStatus.success,
          shareUrl: ShareUrl.facebook,
          facebookShareUrl: 'https://facebook.com',
        ),
      );
      await tester.pumpSubject(FacebookButton(), shareBloc);
      await tester.tap(find.byType(FacebookButton));
      await tester.pumpAndSettle();
      verify(
        () => mock.launchUrl('https://facebook.com', any()),
      ).called(1);
      expect(find.byType(FacebookButton), findsNothing);
      verifyNever(
        () => shareBloc.add(const ShareTapped(shareUrl: ShareUrl.facebook)),
      );
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(FacebookButton subject, ShareBloc bloc) => pumpApp(
        MultiBlocProvider(
          providers: [BlocProvider.value(value: bloc)],
          child: subject,
        ),
      );
}
