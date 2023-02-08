import 'package:download_repository/download_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/footer/footer.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class SharePage extends StatelessWidget {
  const SharePage({
    required this.convertBloc,
    super.key,
  });

  final ConvertBloc convertBloc;

  static Route<void> route({
    required ConvertBloc convertBloc,
  }) =>
      AppPageRoute(builder: (_) => SharePage(convertBloc: convertBloc));

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: convertBloc),
        BlocProvider(
          create: (_) => DownloadBloc(
            downloadRepository: context.read<DownloadRepository>(),
          ),
        ),
      ],
      child: const Scaffold(body: ShareView()),
    );
  }
}

class ShareView extends StatelessWidget {
  const ShareView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ShareBackground()),
        Positioned.fill(
          child: Column(
            children: [
              Expanded(child: ShareBody()),
              FullFooter(footerDecoration: true),
            ],
          ),
        ),
      ],
    );
  }
}
