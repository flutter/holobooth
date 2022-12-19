import 'package:convert_repository/convert_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:screen_recorder/screen_recorder.dart';

class SharePage extends StatelessWidget {
  const SharePage({
    required this.images,
    required this.frames,
    super.key,
  });

  final List<PhotoboothCameraImage> images;
  final List<RawFrame> frames;

  static Route<void> route(
    List<PhotoboothCameraImage> images,
    List<RawFrame> frames,
  ) {
    return AppPageRoute(
      builder: (_) => SharePage(
        images: images,
        frames: frames,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShareBloc(),
        ),
        BlocProvider(
          create: (context) => ConvertBloc(
            convertRepository: context.read<ConvertRepository>(),
          )..add(ConvertFrames(frames)),
          lazy: false,
        ),
      ],
      child: ShareView(
        images: images,
      ),
    );
  }
}

class ShareView extends StatelessWidget {
  const ShareView({super.key, required this.images});

  final List<PhotoboothCameraImage> images;

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
                children: [
                  Expanded(child: ShareBody(images: images)),
                  const FullFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
