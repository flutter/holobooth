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
  group('ShareButton', () {
    late ShareBloc shareBloc;

    setUp(() {
      shareBloc = _MockShareBloc();
      when(() => shareBloc.state).thenReturn(ShareState());
    });

    testWidgets(
      'opens ShareDialog on tap',
      (tester) async {
        final subject = ShareButton();
        await tester.pumpSubject(subject, shareBloc);
        await tester.tap(find.byWidget(subject));
        await tester.pumpAndSettle();

        expect(find.byType(ShareDialog), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareButton subject, ShareBloc shareBloc) {
    return pumpApp(
      Scaffold(
        body: BlocProvider.value(
          value: shareBloc,
          child: subject,
        ),
      ),
    );
  }
}
