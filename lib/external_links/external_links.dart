import 'package:photobooth_ui/photobooth_ui.dart';

const flutterDevExternalLink = 'https://flutter.dev';
const firebaseExternalLink = 'https://firebase.google.com';
const photoboothEmail = 'mailto:flutter-photo-booth@google.com';
const openSourceLink = 'https://github.com/flutter/photobooth';
const tensorFlowLink = 'https://tensorflow.org';
const mediaPipeLink = 'https://mediapipe.dev/';

Future<void> launchFirebaseLink() => openLink(firebaseExternalLink);
Future<void> launchPhotoboothEmail() => openLink(photoboothEmail);
Future<void> launchOpenSourceLink() => openLink(openSourceLink);
