import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  Future<void> _initializeCameraController() async {
    _controller = CameraController();
    await _controller.initialize();
    await _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSnapPressed() async {
    final navigator = Navigator.of(context);
    final image = await _controller.takePicture();
    final previewPageRoute = PreviewPage.route(image: image.data);
    await _controller.stop();
    await navigator.push<void>(previewPageRoute);
    await _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Camera(
          controller: _controller,
          placeholder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          preview: (context, preview) => CameraFrame(
            onSnapPressed: _onSnapPressed,
            child: preview,
          ),
          error: (context, error) => Center(child: Text(error.description)),
        ),
      ),
    );
  }
}

class CameraFrame extends StatelessWidget {
  const CameraFrame({
    super.key,
    required this.onSnapPressed,
    required this.child,
  });

  final Widget child;
  final void Function() onSnapPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: onSnapPressed,
            child: const Text('Take Photo'),
          ),
        ),
      ],
    );
  }
}

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key, required this.image});

  static Route<void> route({required String image}) {
    return MaterialPageRoute<void>(builder: (_) => PreviewPage(image: image));
  }

  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: Center(
        child: Image.network(
          image,
          errorBuilder: (context, error, stackTrace) {
            return Text('Error, $error, $stackTrace');
          },
        ),
      ),
    );
  }
}
