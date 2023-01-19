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
      'opens ShareDialog on tap if ConvertStatus.videoCreated',
      (tester) async {
        when(() => convertBloc.state).thenReturn(
          ConvertState(status: ConvertStatus.videoCreated),
        );

        await tester.pumpSubject(ShareButton(), convertBloc);
        await tester.tap(find.byType(ShareButton));
        await tester.pumpAndSettle();
        expect(find.byType(ShareDialog), findsOneWidget);
      },
    );

    testWidgets(
      'adds ShareRequested with ShareType.socialMedia on tap '
      'if ConvertStatus.creatingVideo',
      (tester) async {
        when(() => convertBloc.state).thenReturn(
          ConvertState(status: ConvertStatus.creatingVideo),
        );

        await tester.pumpSubject(ShareButton(), convertBloc);
        await tester.tap(find.byType(ShareButton));
        verify(() => convertBloc.add(ShareRequested(ShareType.socialMedia)))
            .called(1);
      },
    );

    testWidgets(
      'opens ConvertErrorView on tap '
      'if ConvertStatus.errorGeneratingVideo',
      (tester) async {
        when(() => convertBloc.state).thenReturn(
          ConvertState(status: ConvertStatus.errorGeneratingVideo),
        );

        await tester.pumpSubject(ShareButton(), convertBloc);
        await tester.tap(find.byType(ShareButton));
        await tester.pumpAndSettle();
        expect(find.byType(ConvertErrorView), findsOneWidget);
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
