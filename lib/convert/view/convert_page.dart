import 'package:convert_repository/convert_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/footer/footer.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
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
        frames: frames,
      ),
      child: const ConvertView(),
    );
  }
}

@visibleForTesting
class ConvertView extends StatefulWidget {
  const ConvertView({super.key});

  @override
  State<ConvertView> createState() => _ConvertViewState();
}

class _ConvertViewState extends State<ConvertView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ConvertBloc>().add(const GenerateFramesRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConvertBloc, ConvertState>(
      listener: (context, state) {
        if (state.status == ConvertStatus.errorLoadingFrames) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.convertErrorMessage)),
          );
        } else if (state.status == ConvertStatus.loadedFrames) {
          final convertBloc = context.read<ConvertBloc>()
            ..add(const GenerateVideoRequested());
          Navigator.of(context).push(SharePage.route(convertBloc: convertBloc));
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child:
                  Assets.backgrounds.loadingBackground.image(fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Column(
                children: [
                  const Expanded(child: ConvertBody()),
                  FullFooter(),
                ],
              ),
            ),
          ],
        ),
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          child: BlocBuilder<ConvertBloc, ConvertState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              if (state.status == ConvertStatus.errorLoadingFrames) {
                return const ConvertErrorView(
                  convertErrorOrigin: ConvertErrorOrigin.frames,
                );
              } else if (state.status == ConvertStatus.loadingFrames) {
                return const CreatingVideoView();
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
