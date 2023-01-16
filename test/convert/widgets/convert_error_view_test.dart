import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockConvertBloc extends MockBloc<ConvertEvent, ConvertState>
    implements ConvertBloc {}

void main() {
  group('ConvertErrorView', () {
    late ConvertBloc convertBloc;

    setUp(() {
      convertBloc = _MockConvertBloc();
      when(() => convertBloc.state)
          .thenReturn(ConvertState(status: ConvertStatus.error));
    });

    testWidgets(
      'adds GenerateVideoRequested tapping on TryAgainVideoGenerationButton',
      (tester) async {
        await tester.pumpSubject(ConvertErrorView(), convertBloc);
        await tester.tap(find.byType(TryAgainVideoGenerationButton));
        verify(() => convertBloc.add(GenerateVideoRequested())).called(1);
      },
    );

    testWidgets(
      'navigates to PhotoBoothPage tapping on RetakeExperienceButton',
      (tester) async {
        await tester.pumpSubject(ConvertErrorView(), convertBloc);
        await tester.tap(find.byType(RetakeExperienceButton));
        await tester.pump(kThemeAnimationDuration);
        await tester.pump(kThemeAnimationDuration);
        expect(find.byType(PhotoBoothPage), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    ConvertErrorView subject,
    ConvertBloc convertBloc,
  ) =>
      pumpApp(
        BlocProvider.value(
          value: convertBloc,
          child: subject,
        ),
      );
}
