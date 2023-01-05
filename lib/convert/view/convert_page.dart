import 'package:convert_repository/convert_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
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

@visibleForTesting
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ConvertBloc>().add(ConvertFrames(widget.frames));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child:
                Assets.backgrounds.loadingBackground.image(fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Column(
              children: const [
                Expanded(child: ConvertBody()),
                FullFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
class ConvertBody extends StatelessWidget {
  const ConvertBody({super.key});

  static const errorViewKey = Key('errorView');

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConvertBloc, ConvertState>(
      listener: (context, state) {
        if (state.status == ConvertStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.convertErrorMessage)),
          );
        } else if (state.status == ConvertStatus.framesProcessed) {
          context.read<ConvertBloc>().add(const GenerateVideo());
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            child: BlocBuilder<ConvertBloc, ConvertState>(
              builder: (context, state) {
                switch (state.status) {
                  case ConvertStatus.loadingFrames:
                    return LoadingFramesView(progress: state.progress);
                  case ConvertStatus.creatingVideo:
                  case ConvertStatus.framesProcessed:
                    return const CreatingVideoView();
                  case ConvertStatus.videoCreated:
                    return const ConvertFinished(dimension: 200);
                  case ConvertStatus.error:
                    return const SizedBox(key: errorViewKey);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
