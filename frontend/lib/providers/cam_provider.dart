import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider with ChangeNotifier {
  List<CameraDescription>? _cameras;

  List<CameraDescription> get cameras => _cameras ?? [];

  Future<void> initializeCameras() async {
    _cameras = await availableCameras();
    notifyListeners();
  }
}
