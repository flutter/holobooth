import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/share/share.dart';

class SharePage extends StatelessWidget {
  const SharePage({
    super.key,
    required this.firstFrame,
    required this.videoPath,
  });

  final Uint8List firstFrame;
  final String videoPath;

  static Route<void> route({
    required Uint8List firstFrame,
    required String videoPath,
  }) =>
      AppPageRoute(
        builder: (_) => SharePage(
          firstFrame: firstFrame,
          videoPath: videoPath,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShareBloc(
        thumbnail: firstFrame,
        videoPath: videoPath,
      ),
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
