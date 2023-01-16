import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class ConvertErrorView extends StatelessWidget {
  const ConvertErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        TryAgainVideoGenerationButton(),
        SizedBox(height: 16),
        RetakeExperienceButton(),
      ],
    );
  }
}

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

class RetakeExperienceButton extends StatelessWidget {
  const RetakeExperienceButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GradientElevatedButton(
      child: Text(l10n.retakeVideoGeneration),
      onPressed: () {
        Navigator.of(context).pushReplacement(PhotoBoothPage.route());
      },
    );
  }
}
