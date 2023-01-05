import 'package:convert_repository/convert_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/footer/footer.dart';
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
      await Future<void>.delayed(const Duration(milliseconds: 300));
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
          Align(
            child: BlocBuilder<ConvertBloc, ConvertState>(
              builder: (context, state) {
                switch (state.status) {
                  case ConvertStatus.loadingFrames:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Loading...',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: PhotoboothColors.white),
                        ),
                        const SizedBox(height: 24),
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [
                                Color(0xffF9F8C4),
                                Color(0xff27F5DD),
                              ],
                            ).createShader(Offset.zero & bounds.size);
                          },
                          child: Container(
                            height: 35,
                            width: 400,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(200)),
                              border: Border.all(color: Colors.white),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(200)),
                              child: LinearProgressIndicator(
                                value: state.progress,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                backgroundColor: PhotoboothColors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
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
