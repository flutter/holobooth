import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class ConvertErrorView extends StatelessWidget {
  const ConvertErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        RetryVideoGenerationButton(),
        SizedBox(height: 16),
        RestartExperienceButton(),
      ],
    );
  }
}

class RetryVideoGenerationButton extends StatelessWidget {
  const RetryVideoGenerationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientElevatedButton(
      child: const Text('Try again'),
      onPressed: () {
        context.read<ConvertBloc>().add(GenerateVideoRequested(null));
      },
    );
  }
}

class RestartExperienceButton extends StatelessWidget {
  const RestartExperienceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientElevatedButton(
      child: const Text('Retake'),
      onPressed: () {
        Navigator.of(context).pushReplacement(PhotoBoothPage.route());
      },
    );
  }
}
