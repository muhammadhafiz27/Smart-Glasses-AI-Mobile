// ────────────────────────────────────────────────
// Frame recommendation rules based on face shape
// Source: iris.ca (IRIS optical)
// ────────────────────────────────────────────────

class RecommendationRules {
  /// Returns list of recommended frame shapes for a given face shape
  static List<String> getFramesForFaceShape(String faceShape) {
    return _frameRules[faceShape.toLowerCase()] ?? [];
  }

  /// Returns list of recommended lens types for lifestyle combination
  static List<String> getLensesForLifestyle({
    required String primaryActivity,
    required int screenTimeHours,
    required bool outdoorActivity,
  }) {
    final lenses = <String>{};

    // Screen-heavy users
    if (screenTimeHours >= 6) {
      lenses.add('Blue Light Blocking');
    }
    if (screenTimeHours >= 3) {
      lenses.add('Anti-Reflective');
    }

    // Outdoor / UV protection
    if (outdoorActivity) {
      lenses.add('Photochromic (Transition)');
      lenses.add('Polarized');
    }

    // Activity-based
    switch (primaryActivity) {
      case 'Reading / Office Work':
        lenses.add('Anti-Reflective');
        lenses.add('Blue Light Blocking');
        break;
      case 'Outdoor / Sports':
        lenses.add('Polarized');
        lenses.add('UV400 Protection');
        break;
      case 'Driving':
        lenses.add('Polarized');
        lenses.add('Anti-Reflective');
        break;
      case 'Night Activities':
        lenses.add('Anti-Reflective');
        lenses.add('Yellow Tinted');
        break;
      case 'Mixed / General':
        lenses.add('Photochromic (Transition)');
        lenses.add('Anti-Reflective');
        break;
    }

    // Always add a generic option if empty
    if (lenses.isEmpty) {
      lenses.add('Standard Clear');
      lenses.add('Anti-Reflective');
    }

    // Return top 2
    return lenses.take(2).toList();
  }

  /// Returns lens descriptions
  static String getLensDescription(String lensName) {
    return _lensDescriptions[lensName] ??
        'A quality lens option suited for your needs.';
  }

  /// Returns frame descriptions
  static String getFrameDescription(String frameName) {
    return _frameDescriptions[frameName] ??
        'A stylish frame option that suits your face shape.';
  }

  // ─── Private data ───────────────────────────────

  static const Map<String, List<String>> _frameRules = {
    'round': ['Angular / Rectangular', 'Square', 'Browline', 'Geometric'],
    'oval': ['Butterfly', 'Round', 'Square', 'Wide Rectangle'],
    'square': ['Round', 'Oval', 'Aviator', 'Rimless'],
    'oblong': ['Aviator', 'Butterfly', 'Wide Frame', 'Deep Lens'],
    'heart': ['Oval', 'Half-Rimless', 'Light Rimless', 'Bottom-Heavy'],
  };

  static const Map<String, String> _frameDescriptions = {
    'Angular / Rectangular':
        'Sharp angles contrast soft round features, adding definition to the face.',
    'Square':
        'Bold corners create structure and balance circular facial contours.',
    'Browline':
        'Emphasizes the brow line, adding character and visual interest.',
    'Geometric':
        'Unique polygon shapes add artistic flair while balancing round features.',
    'Butterfly':
        'Upswept corners lift the appearance and highlight cheekbones beautifully.',
    'Round':
        'Soft curves complement natural facial symmetry and add warmth.',
    'Wide Rectangle':
        'Broadens the face visually, balancing elongated features.',
    'Aviator':
        'Iconic teardrop shape suits many faces and adds timeless style.',
    'Rimless':
        'Lightweight and nearly invisible, lets your natural features shine.',
    'Oval':
        'Versatile egg-shaped frame that flatters most face shapes.',
    'Deep Lens':
        'Taller lenses balance the length of an oblong face shape.',
    'Wide Frame':
        'Creates horizontal width to offset a long, narrow face.',
    'Half-Rimless':
        'Delicate upper frame minimizes width at the forehead area.',
    'Light Rimless':
        'Minimalist design that does not add visual weight to the upper face.',
    'Bottom-Heavy':
        'Draws attention downward, balancing a wider forehead naturally.',
  };

  static const Map<String, String> _lensDescriptions = {
    'Blue Light Blocking':
        'Filters harmful blue light from screens, reducing eye strain and improving sleep.',
    'Anti-Reflective':
        'Eliminates glare from artificial light and screens for clearer, more comfortable vision.',
    'Photochromic (Transition)':
        'Automatically darkens outdoors and clears indoors — perfect for on-the-go lifestyles.',
    'Polarized':
        'Blocks intense reflected glare, ideal for driving, water, and outdoor activities.',
    'UV400 Protection':
        'Blocks 100% of UV-A and UV-B rays, protecting eyes from sun damage.',
    'Yellow Tinted':
        'Enhances contrast in low-light conditions, great for night driving and dim environments.',
    'Standard Clear':
        'Everyday clarity lens with accurate color rendering for general use.',
  };
}
