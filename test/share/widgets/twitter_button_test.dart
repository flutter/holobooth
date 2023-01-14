import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/share/widgets/widgets.dart';
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
  late ConvertBloc convertBloc;
  late UrlLauncherPlatform mock;

  group('TwitterButton', () {
    const twitterUrl = 'https://twitter.com';
    setUp(() {
      mock = _MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      convertBloc = _MockConvertBloc();

      when(() => convertBloc.state).thenReturn(
        ConvertState(twitterShareUrl: twitterUrl),
      );
      when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
      when(
        () => mock.launchUrl(any(), any()),
      ).thenAnswer((_) async => true);
    });

    setUpAll(() {
      registerFallbackValue(LaunchOptions());
    });

    testWidgets('dismissed after tapping', (tester) async {
      await tester.pumpSubject(TwitterButton(), convertBloc);
      await tester.tap(find.byType(TwitterButton));
      await tester.pumpAndSettle();
      expect(find.byType(TwitterButton), findsNothing);
    });

    testWidgets('opens link if sharing enabled', (tester) async {
      await tester.pumpSubject(
        TwitterButton(sharingEnabled: true),
        convertBloc,
      );
      await tester.tap(find.byType(TwitterButton));
      await tester.pumpAndSettle();
      verify(
        () => mock.launchUrl(twitterUrl, any()),
      ).called(1);
      expect(find.byType(TwitterButton), findsNothing);
    });

    testWidgets('shows Snackbar if sharing disabled', (tester) async {
      await tester.pumpSubject(TwitterButton(), convertBloc);
      await tester.tap(find.byType(TwitterButton));
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    TwitterButton subject,
    ConvertBloc bloc,
  ) =>
      pumpApp(
        MultiBlocProvider(
          providers: [BlocProvider.value(value: bloc)],
          child: Scaffold(body: subject),
        ),
      );
}
