import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/footer/footer.dart';
import 'package:holobooth/widgets/widgets.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FullFooter', () {
    testWidgets(
      'renders elements on small screen',
      (tester) async {
        tester.setSmallDisplaySize();
        await tester.pumpApp(FullFooter());
        expect(find.byType(FlutterIconLink), findsOneWidget);
        expect(find.byType(FirebaseIconLink), findsOneWidget);
        expect(find.byType(TensorflowIconLink), findsOneWidget);
        expect(find.byType(MediapipeIconLink), findsOneWidget);
      },
    );

    testWidgets(
      'renders elements on small screen when showIconsForSmall is false',
      (tester) async {
        tester.setSmallDisplaySize();
        await tester.pumpApp(FullFooter(showIconsForSmall: false));
        expect(find.byType(FlutterForwardFooterLink), findsOneWidget);
        expect(find.byType(HowItsMadeFooterLink), findsOneWidget);
        expect(find.byType(FooterTermsOfServiceLink), findsOneWidget);
        expect(find.byType(FooterPrivacyPolicyLink), findsOneWidget);
        expect(find.byType(MuteButton), findsOneWidget);
      },
    );

    testWidgets(
      'renders elements on large screen',
      (tester) async {
        tester.setDisplaySize(const Size(HoloboothBreakpoints.large, 800));
        await tester.pumpApp(FullFooter());
        expect(find.byType(FlutterIconLink), findsOneWidget);
        expect(find.byType(FirebaseIconLink), findsOneWidget);
        expect(find.byType(TensorflowIconLink), findsOneWidget);
        expect(find.byType(MediapipeIconLink), findsOneWidget);
        expect(find.byType(FlutterForwardFooterLink), findsOneWidget);
        expect(find.byType(HowItsMadeFooterLink), findsOneWidget);
        expect(find.byType(FooterTermsOfServiceLink), findsOneWidget);
        expect(find.byType(FooterPrivacyPolicyLink), findsOneWidget);
        expect(find.byType(MuteButton), findsOneWidget);
      },
    );
  });
}
