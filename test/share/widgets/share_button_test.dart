import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockShareBloc extends MockBloc<ShareEvent, ShareState>
    implements ShareBloc {}

class _MockConvertBloc extends MockBloc<ConvertEvent, ConvertState>
    implements ConvertBloc {}

void main() {
  group('ShareButton', () {
    late ShareBloc shareBloc;
    late ConvertBloc convertBloc;

    setUp(() {
      shareBloc = _MockShareBloc();
      when(() => shareBloc.state).thenReturn(ShareState());
      convertBloc = _MockConvertBloc();
      when(() => convertBloc.state).thenReturn(ConvertState());
    });

    testWidgets(
      'opens ShareDialog on tap',
      (tester) async {
        final subject = ShareButton();
        await tester.pumpSubject(subject, shareBloc, convertBloc);
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
    ShareBloc shareBloc,
    ConvertBloc convertBloc,
  ) {
    return pumpApp(
      Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: shareBloc),
            BlocProvider.value(value: convertBloc),
          ],
          child: subject,
        ),
      ),
    );
  }
}
