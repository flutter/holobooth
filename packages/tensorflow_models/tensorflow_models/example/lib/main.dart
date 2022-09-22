import 'package:example/src/pages/pages.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      const MaterialApp(home: _App()),
    );

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  static final _pages = <String, Route<void>>{
    'Landmarks Single Image': LandmarksSingleImagePage.route(),
    'Landmarks Video Stream': LandmarksVideoStreamPage.route(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tensorflow Examples')),
      body: ListView.builder(
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          final page = _pages.entries.elementAt(index);
          return ListTile(
            title: Text(page.key),
            onTap: () => Navigator.of(context).push(page.value),
          );
        },
      ),
    );
  }
}
