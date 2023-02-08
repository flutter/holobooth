import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

enum ConvertErrorOrigin {
  frames,
  video,
}

class ConvertErrorView extends StatelessWidget {
  const ConvertErrorView({
    required this.convertErrorOrigin,
    super.key,
  });

  final ConvertErrorOrigin convertErrorOrigin;

  @override
  Widget build(BuildContext context) {
    final maxTriesReached =
        context.select((ConvertBloc bloc) => bloc.state.maxTriesReached);
    const buttonWidth = 250.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 84),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (maxTriesReached)
            GradientText(
              text: context.l10n.maxRetriesReached,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            )
          else if (convertErrorOrigin == ConvertErrorOrigin.frames)
            const SizedBox(
              width: buttonWidth,
              child: TryAgainFrameProcessingButton(),
            )
          else
            const SizedBox(
              width: buttonWidth,
              child: TryAgainVideoGenerationButton(),
            ),
          const SizedBox(height: 24),
          const SizedBox(width: buttonWidth, child: RetakeExperienceButton()),
        ],
      ),
    );
  }
}

@visibleForTesting
class TryAgainVideoGenerationButton extends StatelessWidget {
  const TryAgainVideoGenerationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientElevatedButton(
      child: Text(l10n.tryAgainVideoGeneration),
      onPressed: () {
        context.read<ConvertBloc>().add(const GenerateVideoRequested());
      },
    );
  }
}

@visibleForTesting
class TryAgainFrameProcessingButton extends StatelessWidget {
  const TryAgainFrameProcessingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientElevatedButton(
      child: Text(l10n.tryAgainVideoGeneration),
      onPressed: () {
        context.read<ConvertBloc>().add(const GenerateFramesRequested());
      },
    );
  }
}

@visibleForTesting
class RetakeExperienceButton extends StatelessWidget {
  const RetakeExperienceButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return OutlinedButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(PhotoBoothPage.route());
      },
      child: Text(l10n.retakeVideoGeneration),
    );
  }
}
