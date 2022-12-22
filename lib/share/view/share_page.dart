import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:screen_recorder/screen_recorder.dart';

class SharePage extends StatelessWidget {
  const SharePage({
    required this.frames,
    super.key,
  });

  final List<RawFrame> frames;

  static Route<void> route(List<RawFrame> frames) =>
      AppPageRoute(builder: (_) => SharePage(frames: frames));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShareBloc(thumbnail: frames.first.image),
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
