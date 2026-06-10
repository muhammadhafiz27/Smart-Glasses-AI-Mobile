
import '../../core/constants/recommendation_rules.dart';
import '../../models/lifestyle_data.dart';
import '../../models/recommendation_models.dart';

class RecommendationService {
  /// Build a full [PersonalizationResult] from face shape + lifestyle
  PersonalizationResult buildRecommendation({
    required String faceShape,
    required double confidence,
    required LifestyleData lifestyle,
  }) {
    // ── Frames (top 3) ──────────────────────────
    final frameNames =
        RecommendationRules.getFramesForFaceShape(faceShape).take(3).toList();

    final frames = frameNames
        .map(
          (name) => FrameRecommendation(
            name: name,
            description: RecommendationRules.getFrameDescription(name),
            imagePlaceholder: 'assets/images/frames/${_toAssetName(name)}.png',
          ),
        )
        .toList();

    // ── Lenses (top 2) ──────────────────────────
    final lensNames = RecommendationRules.getLensesForLifestyle(
      primaryActivity: lifestyle.primaryActivity,
      screenTimeHours: lifestyle.screenTimeHours,
      outdoorActivity: lifestyle.outdoorActivity,
    );

    final lenses = lensNames
        .map(
          (name) => LensRecommendation(
            name: name,
            description: RecommendationRules.getLensDescription(name),
            iconLabel: _lensIcon(name),
          ),
        )
        .toList();

    // ── Compatibility score ──────────────────────
    // Weighted: 60% model confidence + 40% rule coverage quality
    final ruleCoverage = frameNames.length / 3.0;
    final score = (confidence * 0.6 + ruleCoverage * 0.4).clamp(0.0, 1.0);

    return PersonalizationResult(
      faceShape: faceShape,
      confidence: confidence,
      frames: frames,
      lenses: lenses,
      compatibilityScore: score,
    );
  }

  String _toAssetName(String name) =>
      name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');

  String _lensIcon(String lensName) {
    const map = <String, String>{
      'Blue Light Blocking': '💻',
      'Anti-Reflective': '✨',
      'Photochromic (Transition)': '🌤️',
      'Polarized': '🕶️',
      'UV400 Protection': '☀️',
      'Yellow Tinted': '🌙',
      'Standard Clear': '👁️',
    };
    return map[lensName] ?? '🔍';
  }
}
