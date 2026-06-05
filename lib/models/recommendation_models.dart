class FrameRecommendation {
  final String name;
  final String description;
  final String imagePlaceholder; // asset path or placeholder label

  const FrameRecommendation({
    required this.name,
    required this.description,
    required this.imagePlaceholder,
  });
}

class LensRecommendation {
  final String name;
  final String description;
  final String iconLabel; // emoji or label for placeholder icon

  const LensRecommendation({
    required this.name,
    required this.description,
    required this.iconLabel,
  });
}

class PersonalizationResult {
  final String faceShape;
  final double confidence;
  final List<FrameRecommendation> frames;
  final List<LensRecommendation> lenses;
  final double compatibilityScore; // 0.0 – 1.0

  const PersonalizationResult({
    required this.faceShape,
    required this.confidence,
    required this.frames,
    required this.lenses,
    required this.compatibilityScore,
  });

  String get compatibilityPercent =>
      '${(compatibilityScore * 100).toStringAsFixed(0)}%';
}
