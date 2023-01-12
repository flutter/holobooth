import 'package:io_photobooth/bootstrap.dart';
import 'package:io_photobooth/firebase_options_dev.dart';

Future<void> main() async {
  const convertUrl = 'https://convert-it4sycsdja-uc.a.run.app';
  const shareUrl =
      'https://96e0700d-fe2c-4609-b43c-87093e447b75.web.app/share/';
  const assetBucketUrl =
      'https://storage.googleapis.com/io-photobooth-dev.appspot.com/uploads/';
  await bootstrap(
    convertUrl: convertUrl,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    shareUrl: shareUrl,
    assetBucketUrl: assetBucketUrl,
  );
}
