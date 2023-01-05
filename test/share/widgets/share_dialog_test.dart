import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockShareBloc extends MockBloc<ShareEvent, ShareState>
    implements ShareBloc {}

void main() {
  group('ShareDialog', () {
    late ShareBloc shareBloc;
    final thumbnail = Uint8List.fromList(transparentImage);

    setUp(() {
      shareBloc = _MockShareBloc();
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
