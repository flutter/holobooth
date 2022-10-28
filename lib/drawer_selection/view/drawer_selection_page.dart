import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:io_photobooth/drawer_selection/drawer_selection.dart';

class DrawerSelectionPage extends StatelessWidget {
  const DrawerSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DrawerSelectionBloc(),
      child: const DrawerSelectionView(),
    );
  }
}

class DrawerSelectionView extends StatelessWidget {
  const DrawerSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerSelectionBloc, DrawerSelectionState>(
      builder: (context, state) {
        // TODO: return correct widget based on the state.
        return const SizedBox();
      },
    );
  }
}
