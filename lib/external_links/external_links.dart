import 'package:holobooth_ui/holobooth_ui.dart';

const flutterDevExternalLink = 'https://flutter.dev';
const flutterForwardLink = 'https://flutter.dev/events/flutter-forward';
const howItsMadeLink =
    'https://medium.com/flutter/how-its-made-holobooth-6473f3d018dd';
const repositoryLink = 'https://github.com/flutter/holobooth';
const firebaseExternalLink = 'https://firebase.google.com';
const tensorFlowLink = 'https://tensorflow.org';
const mediaPipeLink = 'https://mediapipe.dev/';
const photoboothEmail = 'mailto:flutter-photo-booth@google.com';
const termsOfServiceLink = 'https://policies.google.com/terms';
const privacyPolicyLink = 'https://policies.google.com/privacy';
const classicPhotoboothLink = 'https://photobooth.flutter.dev';

Future<void> launchPhotoboothEmail() => openLink(photoboothEmail);
