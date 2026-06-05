// ─────────────────────────────────
// face_shape_result.dart
// ─────────────────────────────────
class FaceShapeResult {
  final String shape;          // e.g. "oval"
  final double confidence;     // 0.0 – 1.0
  final Map<String, double> allScores;
  final String? imagePath;

  const FaceShapeResult({
    required this.shape,
    required this.confidence,
    required this.allScores,
    this.imagePath,
  });

  String get confidencePercent =>
      '${(confidence * 100).toStringAsFixed(1)}%';
}
