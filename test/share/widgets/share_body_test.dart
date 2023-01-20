import 'dart:typed_data';
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:holobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_helper/platform_helper.dart';

import '../../helpers/helpers.dart';

class _MockConvertBloc extends MockBloc<ConvertEvent, ConvertState>
    implements ConvertBloc {}

class _MockDownloadBloc extends MockBloc<DownloadEvent, DownloadState>
    implements DownloadBloc {}

class _MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  group('ShareBody', () {
    late ConvertBloc convertBloc;
    late DownloadBloc downloadBloc;
    late Uint8List thumbnail;
    late PlatformHelper platformHelper;

    setUp(() async {
      convertBloc = _MockConvertBloc();
      final image = await createTestImage(height: 10, width: 10);
      final bytesImage = await image.toByteData(format: ImageByteFormat.png);
      thumbnail = bytesImage!.buffer.asUint8List();
      when(() => convertBloc.state)
          .thenReturn(ConvertState(firstFrameProcessed: thumbnail));

      downloadBloc = _MockDownloadBloc();
      when(() => downloadBloc.state).thenReturn(const DownloadState());

      platformHelper = _MockPlatformHelper();
    });

    testWidgets(
      'renders SmallShareBody in small layout',
      (WidgetTester tester) async {
        tester.setSmallDisplaySize();
        await tester.pumpSubject(
          ShareBody(),
          convertBloc: convertBloc,
          downloadBloc: downloadBloc,
        );
        expect(find.byType(SmallShareBody), findsOneWidget);
      },
    );

    testWidgets(
      'forces the small resolution animation on mobile on SmalleShareBody',
      (WidgetTester tester) async {
        tester.setSmallDisplaySize();
        when(() => platformHelper.isMobile).thenReturn(true);
        await tester.pumpSubject(
          ShareBody(platformHelper: platformHelper),
          convertBloc: convertBloc,
          downloadBloc: downloadBloc,
        );
        expect(find.byType(PortalAnimationView), findsOneWidget);

        final widget = tester.widget<PortalAnimationView>(
          find.byType(PortalAnimationView),
        );

        expect(widget.mode, equals(PortalMode.mobile));
      },
    );

    testWidgets(
      'renders PortalAnimationView on SmallShareBody if desktop',
      (WidgetTester tester) async {
        tester.setSmallDisplaySize();
        when(() => platformHelper.isMobile).thenReturn(false);
        await tester.pumpSubject(
          ShareBody(platformHelper: platformHelper),
          convertBloc: convertBloc,
          downloadBloc: downloadBloc,
        );
        expect(find.byType(PortalAnimationView), findsOneWidget);
      },
    );

    testWidgets(
      'renders LargeShareBody in large layout',
      (WidgetTester tester) async {
        tester.setLargeDisplaySize();
        await tester.pumpSubject(
          ShareBody(),
          convertBloc: convertBloc,
          downloadBloc: downloadBloc,
        );
        expect(find.byType(LargeShareBody), findsOneWidget);
      },
    );

    testWidgets(
      'forces the small resolution animation on mobile on LargeShareBody',
      (WidgetTester tester) async {
        tester.setLargeDisplaySize();
        when(() => platformHelper.isMobile).thenReturn(true);

        await tester.pumpSubject(
          ShareBody(platformHelper: platformHelper),
          convertBloc: convertBloc,
          downloadBloc: downloadBloc,
        );
        expect(find.byType(PortalAnimationView), findsOneWidget);

        final widget = tester.widget<PortalAnimationView>(
          find.byType(PortalAnimationView),
        );

        expect(widget.mode, equals(PortalMode.mobile));
      },
    );

    testWidgets(
      'renders PortalAnimationView on LargeShareBody if desktop',
      (WidgetTester tester) async {
        tester.setLargeDisplaySize();
        when(() => platformHelper.isMobile).thenReturn(false);

        await tester.pumpSubject(
          ShareBody(platformHelper: platformHelper),
          convertBloc: convertBloc,
          downloadBloc: downloadBloc,
        );
        expect(find.byType(PortalAnimationView), findsOneWidget);
      },
    );

    testWidgets('displays a ShareButton', (tester) async {
      await tester.pumpSubject(
        ShareBody(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      expect(find.byType(ShareButton), findsOneWidget);
    });

    testWidgets('displays a DownloadButton', (tester) async {
      await tester.pumpSubject(
        ShareBody(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      expect(
        find.byType(DownloadButton),
        findsOneWidget,
      );
    });

    testWidgets('displays a RetakeButton', (tester) async {
      await tester.pumpSubject(
        ShareBody(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      expect(
        find.byType(RetakeButton),
        findsOneWidget,
      );
    });

    testWidgets('displays a PortalAnimation', (tester) async {
      when(() => platformHelper.isMobile).thenReturn(false);
      await tester.pumpSubject(
        ShareBody(platformHelper: platformHelper),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      expect(
        find.byType(PortalAnimation),
        findsOneWidget,
      );
    });

    testWidgets(
      'PortalAnimation is Clickable when animation is completed',
      (tester) async {
        when(() => platformHelper.isMobile).thenReturn(false);
        await tester.pumpSubject(
          ShareBody(platformHelper: platformHelper),
          convertBloc: convertBloc,
          downloadBloc: downloadBloc,
        );
        final portalAnimation = tester.widget<PortalAnimation>(
          find.byType(PortalAnimation),
        );

        portalAnimation.onComplete();
        await tester.pump();

        expect(find.byKey(ShareBody.portalVideoButtonKey), findsOneWidget);
      },
    );

    testWidgets(
      'Open the video dialog upon clicking the Portal',
      (tester) async {
        when(() => platformHelper.isMobile).thenReturn(false);
        await tester.pumpSubject(
          ShareBody(platformHelper: platformHelper),
          convertBloc: convertBloc,
          downloadBloc: downloadBloc,
        );
        final portalAnimation = tester.widget<PortalAnimation>(
          find.byType(PortalAnimation),
        );

        portalAnimation.onComplete();
        await tester.pump();

        await tester.tap(find.byKey(ShareBody.portalVideoButtonKey));
        await tester.pump();

        expect(find.byType(VideoDialogLauncher), findsOneWidget);
      },
    );

    testWidgets(
      'RetakeButton navigates to photobooth when pressed',
      (tester) async {
        await tester.pumpSubject(
          ShareBody(),
          convertBloc: convertBloc,
          downloadBloc: downloadBloc,
        );
        final finder = find.byType(RetakeButton);
        await tester.ensureVisible(finder);
        await tester.tap(finder);
        await tester.pump(kThemeAnimationDuration);
        await tester.pump(kThemeAnimationDuration);
        expect(find.byType(PhotoBoothPage), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    ShareBody subject, {
    required ConvertBloc convertBloc,
    required DownloadBloc downloadBloc,
  }) =>
      pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: convertBloc),
            BlocProvider.value(value: downloadBloc),
          ],
          child: SingleChildScrollView(child: subject),
        ),
      );
}
