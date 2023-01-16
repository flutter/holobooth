import 'package:io_photobooth/bootstrap.dart';
import 'package:io_photobooth/firebase_options_dev.dart';

Future<void> main() async {
  const convertUrl = 'https://convert-it4sycsdja-uc.a.run.app';
  await bootstrap(
    convertUrl: convertUrl,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
