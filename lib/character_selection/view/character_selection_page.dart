import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionPage extends StatelessWidget {
  const CharacterSelectionPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const CharacterSelectionPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => CharacterSelectionBloc(),
        child: const CharacterSelectionView(),
      ),
    );
  }
}

@visibleForTesting
class CharacterSelectionView extends StatelessWidget {
  const CharacterSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageView(
      background: const CharacterSelectionBackground(),
      body: const CharacterSelectionBody(),
      footer: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          SizedBox(
            height: 100,
            width: 100,
            child: NextButton(),
          ),
          SimplifiedFooter(),
        ],
      ),
    );
  }
}
