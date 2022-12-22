import 'package:convert_repository/convert_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/share/view/view.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:screen_recorder/screen_recorder.dart';

class ConvertPage extends StatelessWidget {
  const ConvertPage({
    required this.frames,
    super.key,
  });

  final List<RawFrame> frames;

  static Route<void> route(
    List<RawFrame> frames,
  ) {
    return AppPageRoute(builder: (_) => ConvertPage(frames: frames));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConvertBloc(
        convertRepository: context.read<ConvertRepository>(),
      )..add(ConvertFrames(frames)),
      lazy: false,
      child: const ConvertView(),
    );
  }
}

class ConvertView extends StatelessWidget {
  const ConvertView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ConvertBody(),
    );
  }
}

class ConvertBody extends StatelessWidget {
  const ConvertBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConvertBloc, ConvertState>(
      listener: (context, state) {
        if (state.isFinished) {
          Navigator.of(context).push(
            SharePage.route(state.frames),
          );
        } else if (state.status == ConvertStatus.error) {
          Navigator.of(context).push(
            SharePage.route(state.frames),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Assets.backgrounds.loadingBackground.image(
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: state.status == ConvertStatus.loading
                      ? const ConvertLoadingBody(dimension: 200)
                      : const ConvertFinished(dimension: 200),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

@visibleForTesting
class ConvertLoadingBody extends StatelessWidget {
  const ConvertLoadingBody({super.key, required this.dimension});

  final double dimension;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConvertLoadingView(dimension: dimension),
        const SizedBox(height: 50),
        const ConvertMessage(),
      ],
    );
  }
}
