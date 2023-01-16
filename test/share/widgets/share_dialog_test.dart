import 'dart:typed_data';
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockShareBloc extends MockBloc<ShareEvent, ShareState>
    implements ShareBloc {}

void main() {
  group('ShareDialog', () {
    late ShareBloc shareBloc;
    late Uint8List thumbnail;

    setUp(() async {
      shareBloc = _MockShareBloc();
      final image = await createTestImage(height: 10, width: 10);
      final bytesImage = await image.toByteData(format: ImageByteFormat.png);
      thumbnail = bytesImage!.buffer.asUint8List();
      when(() => shareBloc.state).thenReturn(ShareState(thumbnail: thumbnail));
    });

    test('can be instantiated', () {
      expect(
        ShareDialog(),
        isA<ShareDialog>(),
      );
    });

    testWidgets('renders ShareDialogBody', (tester) async {
      await tester.pumpSubject(ShareDialog(), shareBloc);
      expect(find.byType(ShareDialogBody), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareDialog subject, ShareBloc shareBloc) {
    return pumpApp(
      BlocProvider.value(
        value: shareBloc,
        child: Material(child: subject),
      ),
    );
  }
}
