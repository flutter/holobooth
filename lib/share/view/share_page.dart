import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class SharePage extends StatelessWidget {
  const SharePage({
    super.key,
    required this.firstFrame,
    required this.videoPath,
    required this.convertBloc,
  });

  final Uint8List firstFrame;
  final String videoPath;
  final ConvertBloc convertBloc;

  static Route<void> route({
    required Uint8List firstFrame,
    required String videoPath,
    required ConvertBloc convertBloc,
  }) =>
      AppPageRoute(
        builder: (_) => SharePage(
          firstFrame: firstFrame,
          videoPath: videoPath,
          convertBloc: convertBloc,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShareBloc(
            thumbnail: firstFrame,
            videoPath: videoPath,
          ),
        ),
        BlocProvider.value(value: convertBloc),
      ],
      child: const ShareView(),
    );
  }
}

class ShareView extends StatelessWidget {
  const ShareView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShareBloc, ShareState>(
      listenWhen: (previous, current) {
        return previous.shareStatus != current.shareStatus ||
            previous.shareUrl != current.shareUrl;
      },
      listener: (context, state) {
        if (state.shareStatus.isSuccess) {
          final String url;
          switch (state.shareUrl) {
            case ShareUrl.none:
              url = state.explicitShareUrl;
              break;
            case ShareUrl.twitter:
              url = state.twitterShareUrl;
              break;
            case ShareUrl.facebook:
              url = state.facebookShareUrl;
              break;
          }
          openLink(url);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            const Positioned.fill(child: ShareBackground()),
            Positioned.fill(
              child: Column(
                children: const [
                  Expanded(child: ShareBody()),
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
