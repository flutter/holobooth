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

import '../../helpers/helpers.dart';

class _MockConvertBloc extends MockBloc<ConvertEvent, ConvertState>
    implements ConvertBloc {}

void main() {
  group('ShareBody', () {
    late ConvertBloc convertBloc;
    late Uint8List thumbnail;

    setUp(() async {
      convertBloc = _MockConvertBloc();
      final image = await createTestImage(height: 10, width: 10);
      final bytesImage = await image.toByteData(format: ImageByteFormat.png);
      thumbnail = bytesImage!.buffer.asUint8List();
      when(() => convertBloc.state)
          .thenReturn(ConvertState(firstFrameProcessed: thumbnail));
    });

    testWidgets(
      'renders SmallShareBody in small layout',
      (WidgetTester tester) async {
        tester.setSmallDisplaySize();
        await tester.pumpSubject(ShareBody(), convertBloc);
        expect(find.byType(SmallShareBody), findsOneWidget);
      },
    );

    testWidgets(
      'renders LargeShareBody in large layout',
      (WidgetTester tester) async {
        tester.setLargeDisplaySize();
        await tester.pumpSubject(ShareBody(), convertBloc);
        expect(find.byType(LargeShareBody), findsOneWidget);
      },
    );

    testWidgets('displays a ShareButton', (tester) async {
      await tester.pumpSubject(ShareBody(), convertBloc);
      expect(find.byType(ShareButton), findsOneWidget);
    });

    testWidgets('displays a DownloadButton', (tester) async {
      await tester.pumpSubject(ShareBody(), convertBloc);
      expect(
        find.byType(DownloadButton),
        findsOneWidget,
      );
    });

    testWidgets('displays a RetakeButton', (tester) async {
      await tester.pumpSubject(ShareBody(), convertBloc);
      expect(
        find.byType(RetakeButton),
        findsOneWidget,
      );
    });

    testWidgets(
      'RetakeButton navigates to photobooth when pressed',
      (tester) async {
        await tester.pumpSubject(ShareBody(), convertBloc);
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
  Future<void> pumpSubject(ShareBody subject, ConvertBloc bloc) => pumpApp(
        MultiBlocProvider(
          providers: [BlocProvider.value(value: bloc)],
          child: SingleChildScrollView(child: subject),
        ),
      );
}
