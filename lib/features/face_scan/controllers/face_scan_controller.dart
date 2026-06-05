import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../ai/services/tflite_service.dart';
import '../../../models/face_shape_result.dart';

enum FaceScanState { idle, cameraReady, capturing, analyzing, done, error }

class FaceScanController extends ChangeNotifier {
  CameraController? _cameraController;
  FaceScanState _state = FaceScanState.idle;
  FaceShapeResult? _result;
  String? _errorMessage;
  String? _capturedImagePath;

  CameraController? get cameraController => _cameraController;
  FaceScanState get state => _state;
  FaceShapeResult? get result => _result;
  String? get errorMessage => _errorMessage;
  String? get capturedImagePath => _capturedImagePath;
  bool get isLoading =>
      _state == FaceScanState.capturing || _state == FaceScanState.analyzing;

  final TFLiteService _tflite = TFLiteService();

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        front,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();
      _setState(FaceScanState.cameraReady);

      // Load TFLite model
      await _tflite.loadModel();
    } catch (e) {
      _errorMessage = 'Camera initialization failed: $e';
      _setState(FaceScanState.error);
    }
  }

  Future<void> captureAndAnalyze() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return;
    }

    _setState(FaceScanState.capturing);

    try {
      final XFile photo =
          await _cameraController!.takePicture();

      _capturedImagePath = photo.path;

      _setState(FaceScanState.analyzing);

      final imageFile = File(photo.path);

      _result = await _tflite.classifyImage(imageFile);

      // Dispose camera
      await _cameraController?.dispose();
      _cameraController = null;

      _setState(FaceScanState.done);
    } catch (e) {
      _errorMessage = 'Analysis failed: $e';
      _setState(FaceScanState.error);
    }
  }

  Future<void> reset() async {
    _result = null;
    _capturedImagePath = null;
    _errorMessage = null;

    await initCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _tflite.dispose();
    super.dispose();
  }

  void _setState(FaceScanState newState) {
    _state = newState;
    notifyListeners();
  }
}
