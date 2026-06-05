import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../models/face_shape_result.dart';

class TFLiteService {
  Interpreter? _interpreter;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  /// Load the TFLite model from assets
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        AppConstants.modelPath,
      );

      final inputShape =
          _interpreter!.getInputTensor(0).shape;

      final outputShape =
          _interpreter!.getOutputTensor(0).shape;

      debugPrint('✅ MODEL LOADED');
      debugPrint('Input Shape : $inputShape');
      debugPrint('Output Shape: $outputShape');

      _isLoaded = true;
    } catch (e) {
      _isLoaded = false;

      debugPrint('❌ TFLite load error: $e');
    }
  }

  /// Run inference on an image file
  /// Returns a [FaceShapeResult] with the predicted class and confidence
  Future<FaceShapeResult> classifyImage(File imageFile) async {
    try {
      debugPrint('🚀 classifyImage START');

      if (!_isLoaded || _interpreter == null) {
        debugPrint('⚠️ MODEL NOT LOADED -> MOCK RESULT');
        return _mockClassify();
      }

      final inputTensor = await _preprocessImage(imageFile);

      debugPrint('✅ PREPROCESS DONE');

      final output = List.filled(
        AppConstants.numClasses,
        0.0,
      ).reshape([1, AppConstants.numClasses]);

      debugPrint('🧠 RUNNING INFERENCE');

      _interpreter!.run(inputTensor, output);

      debugPrint('✅ INFERENCE DONE');
      debugPrint('OUTPUT: $output');

      final probabilities =
          List<double>.from(output[0] as List);

      return _buildResult(probabilities, imageFile.path);
    } catch (e) {
      debugPrint('❌ CLASSIFY ERROR: $e');
      rethrow;
    }
  }

  // ─── Private helpers ────────────────────────────

  Future<List<List<List<List<double>>>>> _preprocessImage(File file) async {
    final rawBytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(rawBytes);
    if (image == null) throw Exception('Cannot decode image');

    image = img.copyResize(
      image,
      width: AppConstants.inputSize,
      height: AppConstants.inputSize,
    );

    // Shape: [1, 224, 224, 3]
    final input = List.generate(
      1,
      (_) => List.generate(
        AppConstants.inputSize,
        (y) => List.generate(
          AppConstants.inputSize,
          (x) {
            final pixel = image!.getPixel(x, y);
            // MobileNetV2 preprocess_input: scale to [-1, 1]
            return [
              (pixel.r / 127.5) - 1.0,
              (pixel.g / 127.5) - 1.0,
              (pixel.b / 127.5) - 1.0,
            ];
          },
        ),
      ),
    );
    return input;
  }

  FaceShapeResult _buildResult(List<double> probabilities, String? imagePath) {
    double maxScore = 0;
    int maxIdx = 0;
    for (int i = 0; i < probabilities.length; i++) {
      if (probabilities[i] > maxScore) {
        maxScore = probabilities[i];
        maxIdx = i;
      }
    }

    final allScores = <String, double>{};
    for (int i = 0; i < AppConstants.faceShapes.length; i++) {
      allScores[AppConstants.faceShapes[i]] = probabilities[i];
    }

    return FaceShapeResult(
      shape: AppConstants.faceShapes[maxIdx],
      confidence: maxScore,
      allScores: allScores,
      imagePath: imagePath,
    );
  }

  /// Mock result for development / demo mode
  FaceShapeResult _mockClassify() {
    final mockScores = <String, double>{
      'heart': 0.05,
      'oblong': 0.08,
      'oval': 0.72,
      'round': 0.10,
      'square': 0.05,
    };
    return FaceShapeResult(
      shape: 'oval',
      confidence: 0.72,
      allScores: mockScores,
    );
  }

  void dispose() {
    _interpreter?.close();
  }
}

// Simple debug print helper (no flutter dependency needed)
void debugPrint(String msg) {
  // ignore: avoid_print
  print('[TFLiteService] $msg');
}
