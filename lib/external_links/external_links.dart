import 'package:photobooth_ui/photobooth_ui.dart';

const flutterDevExternalLink = 'https://flutter.dev';
const firebaseExternalLink = 'https://firebase.google.com';
const tensorFlowLink = 'https://tensorflow.org';
const mediaPipeLink = 'https://mediapipe.dev/';
const photoboothEmail = 'mailto:flutter-photo-booth@google.com';
const termsOfServiceLink = 'https://policies.google.com/terms';
const privacyPolicyLink = 'https://policies.google.com/privacy';
const classicPhotoboothLink = 'https://photobooth.flutter.dev';

Future<void> launchPhotoboothEmail() => openLink(photoboothEmail);
