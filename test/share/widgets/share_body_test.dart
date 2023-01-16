import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:holobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockShareBloc extends MockBloc<ShareEvent, ShareState>
    implements ShareBloc {}

void main() {
  group('ShareBody', () {
    late ShareBloc shareBloc;
    final thumbnail = Uint8List.fromList(transparentImage);

    setUp(() {
      shareBloc = _MockShareBloc();
      when(() => shareBloc.state).thenReturn(ShareState(thumbnail: thumbnail));
    });

    testWidgets(
      'renders SmallShareBody in small layout',
      (WidgetTester tester) async {
        tester.setSmallDisplaySize();
        await tester.pumpSubject(ShareBody(), shareBloc);
        expect(find.byType(SmallShareBody), findsOneWidget);
      },
    );

    testWidgets(
      'renders LargeShareBody in large layout',
      (WidgetTester tester) async {
        tester.setLargeDisplaySize();
        await tester.pumpSubject(ShareBody(), shareBloc);
        expect(find.byType(LargeShareBody), findsOneWidget);
      },
    );

    testWidgets('displays a ShareButton', (tester) async {
      await tester.pumpSubject(ShareBody(), shareBloc);
      expect(find.byType(ShareButton), findsOneWidget);
    });

    testWidgets('displays a DownloadButton', (tester) async {
      await tester.pumpSubject(ShareBody(), shareBloc);
      expect(
        find.byType(DownloadButton),
        findsOneWidget,
      );
    });

    testWidgets('displays a RetakeButton', (tester) async {
      await tester.pumpSubject(ShareBody(), shareBloc);
      expect(
        find.byType(RetakeButton),
        findsOneWidget,
      );
    });

    testWidgets(
      'RetakeButton navigates to photobooth when pressed',
      (tester) async {
        await tester.pumpSubject(ShareBody(), shareBloc);
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
  Future<void> pumpSubject(ShareBody subject, ShareBloc bloc) => pumpApp(
        MultiBlocProvider(
          providers: [BlocProvider.value(value: bloc)],
          child: SingleChildScrollView(child: subject),
        ),
      );
}
