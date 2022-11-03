import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/drawer_selection/drawer_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SelectionButtons', () {
    testWidgets(
        'shows the bottomSheet when screen width is smaller '
        'than mobile breakpoint', (tester) async {
      tester.setSmallDisplaySize();
      await tester.pumpApp(
        BlocProvider.value(
          value: DrawerSelectionBloc(),
          child: PhotoBoothView(),
        ),
      );
      await tester
          .tap(find.byKey(SelectionButtons.backgroundSelectorButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(ItemSelectorBottomSheet<Color>), findsOneWidget);
    });
    testWidgets('onSelected is invoked when item is selected', (tester) async {
      tester.setSmallDisplaySize();
      await tester.pumpApp(
        SelectionButtons(),
      );
      await tester
          .tap(find.byKey(SelectionButtons.backgroundSelectorButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(ItemSelectorBottomSheet<Color>), findsOneWidget);
      await tester.ensureVisible(find.byType(ColoredBox).at(2));

      await tester.tapAt(tester.getTopLeft(find.byType(ColoredBox).at(2)));
      // TODO(laura177): check unSelected is invoked.
    });
  });
}
