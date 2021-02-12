import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';

class Cameras {
  List<CameraDescription> _cameras = [];
  int _currentId = 0;

  static Cameras get I {
    return GetIt.I<Cameras>();
  }

  Cameras() {
    availableCameras().then((cameras) {
      _cameras = cameras;
    });
  }

  CameraDescription get() {
    if (_cameras.length == 0) {
      return null;
    }
    return _cameras[_currentId];
  }

  CameraDescription next() {
    _currentId++;
    _currentId %= _cameras.length;
    return get();
  }
}
