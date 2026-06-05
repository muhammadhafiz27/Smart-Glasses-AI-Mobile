class AppConstants {
  // Model
  static const String modelPath = 'assets/models/face_shape_model.tflite';
  static const String labelPath = 'assets/labels/labels.txt';
  static const int inputSize = 224;
  static const int numClasses = 5;

  // Face shapes
  static const List<String> faceShapes = [
    'heart',
    'oblong',
    'oval',
    'round',
    'square',
  ];

  // Face shape display names (capitalized)
  static const Map<String, String> faceShapeNames = {
    'heart': 'Heart',
    'oblong': 'Oblong',
    'oval': 'Oval',
    'round': 'Round',
    'square': 'Square',
  };

  // Face shape descriptions
  static const Map<String, String> faceShapeDescriptions = {
    'heart':
        'Wider forehead with a narrower chin. Your face tapers to a point at the chin.',
    'oblong':
        'Face is longer than it is wide with a long straight cheek line.',
    'oval':
        'Balanced proportions with a slightly wider forehead and gentle jaw.',
    'round':
        'Full cheeks and rounded chin with similar width and length.',
    'square':
        'Strong jawline with similar measurements in width and length.',
  };

  // Confidence threshold
  static const double confidenceThreshold = 0.50;
}
