import 'package:holobooth/bootstrap.dart';
import 'package:holobooth/firebase_options_dev.dart';

Future<void> main() async {
  const convertUrl = 'https://convert-it4sycsdja-uc.a.run.app';
  await bootstrap(
    convertUrl: convertUrl,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
