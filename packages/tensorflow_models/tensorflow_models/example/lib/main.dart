// ignore_for_file: avoid_print

import 'package:example/sample_realtime.dart';
import 'package:example/sample_single_image.dart';
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

  static final _samples = <String, Route<void>>{
    'Posenet - Single Image': SingleCapturePage.route(),
    'Posenet - Realtime': SampleRealtimePosenet.route(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tensorflow Examples')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final entry in _samples.entries)
              TextButton(
                onPressed: () => Navigator.of(context).push(entry.value),
                child: Text(entry.key),
              )
          ],
        ),
      ),
    );
  }
}
