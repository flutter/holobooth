import 'package:io_photobooth/bootstrap.dart';
import 'package:io_photobooth/firebase_options_prod.dart';

Future<void> main() async {
  const convertUrl = 'https://convert-fge4q4vwia-uc.a.run.app';
  await bootstrap(
    convertUrl: convertUrl,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
