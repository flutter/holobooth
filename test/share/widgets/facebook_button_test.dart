import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/share/share.dart';
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

  group('FacebookButton', () {
    const facebookUrl = 'https://facebook.com';
    setUp(() {
      mock = _MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      convertBloc = _MockConvertBloc();

      when(() => convertBloc.state).thenReturn(
        ConvertState(facebookShareUrl: facebookUrl),
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
      await tester.pumpSubject(FacebookButton(), convertBloc);
      await tester.tap(find.byType(FacebookButton));
      await tester.pumpAndSettle();
      expect(find.byType(FacebookButton), findsNothing);
    });

    testWidgets('opens link if sharing enabled', (tester) async {
      await tester.pumpSubject(
        FacebookButton(sharingEnabled: true),
        convertBloc,
      );
      await tester.tap(find.byType(FacebookButton));
      await tester.pumpAndSettle();
      verify(
        () => mock.launchUrl(facebookUrl, any()),
      ).called(1);
      expect(find.byType(FacebookButton), findsNothing);
    });

    testWidgets('shows Snackbar if sharing disabled', (tester) async {
      await tester.pumpSubject(FacebookButton(), convertBloc);
      await tester.tap(find.byType(FacebookButton));
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    FacebookButton subject,
    ConvertBloc bloc,
  ) =>
      pumpApp(
        MultiBlocProvider(
          providers: [BlocProvider.value(value: bloc)],
          child: Scaffold(body: subject),
        ),
        // analyticsRepository: _MockAnalyticsRepository(),
      );
}
