library firebase_analytics_client;

export 'src/firebase_analytics_client_io.dart'
    if (dart.library.html) 'src/firebase_analytics_client_web.dart';
