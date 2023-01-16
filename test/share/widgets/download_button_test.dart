import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/share/share.dart';

import '../../helpers/helpers.dart';

class _MockConvertBloc extends MockBloc<ConvertEvent, ConvertState>
    implements ConvertBloc {}

void main() {
  group('DownloadButton', () {
    testWidgets('opens DownloadOptionDialog on tap', (tester) async {
      await tester.pumpApp(
        buildSubject(
          DownloadButton(),
          convertBloc: _MockConvertBloc(),
        ),
      );
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      expect(find.byType(DownloadOptionDialog), findsOneWidget);
    });

    testWidgets('closes DownloadOptionDialog tapping on DownloadAsAGifButton',
        (tester) async {
      await tester.pumpApp(
        buildSubject(
          DownloadButton(),
          convertBloc: _MockConvertBloc(),
        ),
      );
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DownloadAsAGifButton));
      await tester.pumpAndSettle();
      expect(find.byType(DownloadOptionDialog), findsNothing);
    });

    testWidgets('closes DownloadOptionDialog tapping on DownloadAsAVideoButton',
        (tester) async {
      await tester.pumpApp(
        buildSubject(
          DownloadButton(),
          convertBloc: _MockConvertBloc(),
        ),
      );
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DownloadAsAVideoButton));
      await tester.pumpAndSettle();
      expect(find.byType(DownloadOptionDialog), findsNothing);
    });
  });
}

Widget buildSubject(
  Widget subject, {
  required ConvertBloc convertBloc,
}) {
  return BlocProvider.value(value: convertBloc, child: subject);
}
