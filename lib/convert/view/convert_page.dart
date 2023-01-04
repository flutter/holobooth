import 'package:convert_repository/convert_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/share/view/view.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:screen_recorder/screen_recorder.dart';

class ConvertPage extends StatelessWidget {
  const ConvertPage({
    required this.frames,
    super.key,
  });

  final List<Frame> frames;

  static Route<void> route(
    List<Frame> frames,
  ) {
    return AppPageRoute(builder: (_) => ConvertPage(frames: frames));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConvertBloc(
        convertRepository: context.read<ConvertRepository>(),
      ),
      child: ConvertView(frames: frames),
    );
  }
}

class ConvertView extends StatefulWidget {
  const ConvertView({super.key, required this.frames});

  final List<Frame> frames;

  @override
  State<ConvertView> createState() => _ConvertViewState();
}

class _ConvertViewState extends State<ConvertView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<ConvertBloc>().add(ConvertFrames(widget.frames));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ConvertBody());
  }
}

class ConvertBody extends StatelessWidget {
  const ConvertBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConvertBloc, ConvertState>(
      listener: (context, state) {
        if (state.isFinished) {
          Navigator.of(context).push(
            SharePage.route(
              videoPath: state.videoPath,
              firstFrame: state.firstFrame!,
            ),
          );
        } else if (state.status == ConvertStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.convertErrorMessage)),
          );
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Assets.backgrounds.loadingBackground.image(fit: BoxFit.cover),
          Align(
            child: BlocBuilder<ConvertBloc, ConvertState>(
              builder: (context, state) {
                switch (state.status) {
                  case ConvertStatus.loadingFrames:
                    return GradientText(
                      text: 'Frames processed ${state.framesProcessed}...',
                      style: PhotoboothTextStyle.displayMedium,
                      textAlign: TextAlign.center,
                    );
                  case ConvertStatus.loadingVideo:
                    return const ConvertLoadingBody();
                  case ConvertStatus.success:
                    return const ConvertFinished(dimension: 200);
                  case ConvertStatus.error:
                    return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
class ConvertLoadingBody extends StatelessWidget {
  const ConvertLoadingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        ConvertLoadingView(dimension: 200),
        SizedBox(height: 50),
        ConvertMessage(),
      ],
    );
  }
}
