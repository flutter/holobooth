import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockConvertBloc extends MockBloc<ConvertEvent, ConvertState>
    implements ConvertBloc {}

void main() {
  group('ShareDialog', () {
    late ConvertBloc convertBloc;
    final thumbnail = Uint8List.fromList(transparentImage);

    setUp(() {
      convertBloc = _MockConvertBloc();
      when(() => convertBloc.state)
          .thenReturn(ConvertState(firstFrameProcessed: thumbnail));
    });

    test('can be instantiated', () {
      expect(
        ShareDialog(),
        isA<ShareDialog>(),
      );
    });

    testWidgets('renders ShareDialogBody', (tester) async {
      await tester.pumpSubject(ShareDialog(), convertBloc);
      expect(find.byType(ShareDialogBody), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareDialog subject, ConvertBloc convertBloc) {
    return pumpApp(
      BlocProvider.value(
        value: convertBloc,
        child: Material(child: subject),
      ),
    );
  }
}
