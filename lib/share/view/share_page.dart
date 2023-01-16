import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/footer/footer.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

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
    return Scaffold(
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
    );
  }
}
