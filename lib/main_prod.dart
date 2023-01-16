import 'package:holobooth/bootstrap.dart';
import 'package:holobooth/firebase_options_prod.dart';

Future<void> main() async {
  const convertUrl = 'https://convert-fge4q4vwia-uc.a.run.app';
  const shareUrl = 'https://holobooth.flutter.dev/share/';
  const assetBucketUrl =
      'https://storage.googleapis.com/holobooth-prod.appspot.com/uploads/';
  await bootstrap(
    convertUrl: convertUrl,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    shareUrl: shareUrl,
    assetBucketUrl: assetBucketUrl,
  );
}
