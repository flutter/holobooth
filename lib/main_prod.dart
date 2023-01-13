import 'package:io_photobooth/bootstrap.dart';
import 'package:io_photobooth/firebase_options_prod.dart';

Future<void> main() async {
  const convertUrl = 'https://convert-fge4q4vwia-uc.a.run.app';
  const shareUrl =
      'https://holobooth.flutter.dev/share/';
  const assetBucketUrl =
      'https://storage.googleapis.com/io-photobooth-dev.appspot.com/uploads/';
  await bootstrap(
    convertUrl: convertUrl,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    shareUrl: shareUrl,
    assetBucketUrl: assetBucketUrl,
  );
}
