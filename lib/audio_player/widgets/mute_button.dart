import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class MuteButton extends StatelessWidget {
  const MuteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MuteSoundBloc, MuteSoundState>(
      builder: (context, state) => OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: const Size.square(40),
          side: BorderSide(
            color: HoloBoothColors.white.withOpacity(0.32),
          ),
        ),
        onPressed: () => context.read<MuteSoundBloc>().add(MuteSoundToggled()),
        child: state.isMuted
            ? const Icon(Icons.volume_off, size: 16)
            : const Icon(Icons.volume_up, size: 16),
      ),
    );
  }
}
