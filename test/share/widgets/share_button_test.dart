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
  group('ShareButton', () {
    late ConvertBloc convertBloc;

    setUp(() {
      convertBloc = _MockConvertBloc();
      when(() => convertBloc.state).thenReturn(ConvertState());
    });

    testWidgets(
      'opens ShareDialog on tap',
      (tester) async {
        final subject = ShareButton();
        await tester.pumpSubject(subject, convertBloc);
        await tester.tap(find.byWidget(subject));
        await tester.pumpAndSettle();
        expect(find.byType(ShareDialog), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    ShareButton subject,
    ConvertBloc convertBloc,
  ) {
    return pumpApp(
      Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: convertBloc),
          ],
          child: subject,
        ),
      ),
    );
  }
}
