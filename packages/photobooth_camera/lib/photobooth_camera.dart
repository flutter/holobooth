library photobooth_camera;

export 'src/photobooth_camera_controller_unsupported.dart'
    if (dart.library.html) 'src/photobooth_camera_controller_web.dart';
