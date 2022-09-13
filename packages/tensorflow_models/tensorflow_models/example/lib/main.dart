// ignore_for_file: avoid_print

import 'package:example/sample_single_image.dart';
import 'package:example/sample_transparent_image.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: App());
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(SampleTransparentImage.route());
            },
            child: const Text('Transparent image example'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(SingleCapturePage.route());
            },
            child: const Text('Single image example'),
          )
        ],
      ),
    );
  }
}
