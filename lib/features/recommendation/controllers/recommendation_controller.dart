import 'package:flutter/foundation.dart';

import '../../../ai/services/recommendation_service.dart';
import '../../../features/face_scan/controllers/face_scan_controller.dart';
import '../../../features/lifestyle/controllers/lifestyle_controller.dart';
import '../../../models/recommendation_models.dart';

class RecommendationController extends ChangeNotifier {
  final RecommendationService _service;
  PersonalizationResult? _result;
  final bool _isBuilding = false;

  RecommendationController(this._service);

  PersonalizationResult? get result => _result;
  bool get isBuilding => _isBuilding;

  void updateInputs(FaceScanController face, LifestyleController lifestyle) {
    if (face.result != null) {
      _buildResult(face, lifestyle);
    }
  }

  void _buildResult(FaceScanController face, LifestyleController lifestyle) {
    final faceResult = face.result;
    if (faceResult == null) return;

    _result = _service.buildRecommendation(
      faceShape: faceResult.shape,
      confidence: faceResult.confidence,
      lifestyle: lifestyle.data,
    );
    notifyListeners();
  }

  /// Manually trigger rebuild (called when user navigates to recommendation)
  void rebuild(FaceScanController face, LifestyleController lifestyle) {
    _buildResult(face, lifestyle);
  }
}
