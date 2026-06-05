class GlassesAssetMapper {
  // ── Daftarkan semua aset yang kamu punya di sini ──
  // Key: kata kunci (lowercase), Value: path aset
  static const Map<String, String> _assetMap = {
    // Style
    'wayfarer':    'assets/glasses/wayfarer_black.png',
    'rectangular': 'assets/glasses/wayfarer_black.png',
    'classic':     'assets/glasses/wayfarer_black.png',
    'square':      'assets/glasses/wayfarer_black.png',

    'oval':        'assets/glasses/oval_black.png',
    'round':       'assets/glasses/oval_black.png',
    'circle':      'assets/glasses/oval_black.png',
    'circular':    'assets/glasses/oval_black.png',

    'cat':         'assets/glasses/cateye_black.png',
    'cateye':      'assets/glasses/cateye_black.png',
    'cat-eye':     'assets/glasses/cateye_black.png',

    'sport':       'assets/glasses/sporty_black.png',
    'sporty':      'assets/glasses/sporty_black.png',
    'wraparound':  'assets/glasses/sporty_black.png',
    'athletic':    'assets/glasses/sporty_black.png',
  };

  // Fallback jika tidak ada yang cocok
  static const String _fallback = 'assets/glasses/wayfarer_black.png';

  /// Ambil path aset berdasarkan nama frame dari AI
  /// Contoh: "Classic Wayfarer Black" → 'assets/glasses/wayfarer_black.png'
  static String getAsset(String frameName) {
    final lower = frameName.toLowerCase();

    for (final entry in _assetMap.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }

    return _fallback;
  }
}