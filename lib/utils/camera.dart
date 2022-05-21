import 'package:camera/camera.dart';

class Camera {
  static Future<bool> hayCamaras() async {
    try {
      await availableCameras();
      return true;
    } catch (e) {
      return false;
    }
  }
}
