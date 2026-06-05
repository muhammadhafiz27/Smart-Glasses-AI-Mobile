import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../routes/router_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── HEADER ──────────────────────────────────────────────────
            _Header(),

            // ── BODY (overlap dengan header) ────────────────────────────
            Transform.translate(
              offset: const Offset(0, -60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scan Button
                    _ScanButton(onTap: () => context.push(AppRoutes.faceScan)),
                    const SizedBox(height: 28),

                    // Why Choose Us
                    _SectionTitle(
                      icon: Icons.auto_awesome_rounded,
                      text: 'Why Choose Us',
                    ),
                    const SizedBox(height: 14),
                    const _FeatureGrid(),
                    const SizedBox(height: 28),

                    // About This App
                    const _SectionTitle(
                      icon: null,
                      text: 'About This App',
                    ),
                    const SizedBox(height: 14),
                    const _AboutCard(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HEADER — center-aligned, dekoratif circles
// ─────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4F6DFF), Color(0xFF5D7BFF), Color(0xFF00C9A7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(48),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative circle — kanan atas
          Positioned(
            right: -50,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Decorative circle — kiri bawah
          Positioned(
            left: -60,
            bottom: -40,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content — center
          Column(
            children: [
              // Icon glasses dalam circle
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.remove_red_eye_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Smart Glasses Recommender',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Find your perfect eyewear with\nAI-powered recommendations',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SCAN BUTTON — card putih overlap dari header
// ─────────────────────────────────────────────
class _ScanButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ScanButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            // Gradient icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F6DFF), Color(0xFF00C9A7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F6DFF).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.camera_alt_rounded,
                  color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Start New Scan',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.auto_awesome_rounded,
                          color: Color(0xFF4F6DFF), size: 16),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'AI-powered face analysis in seconds',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFF9CA3AF), size: 24),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SECTION TITLE
// ─────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String text;
  final IconData? icon;
  const _SectionTitle({required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: const Color(0xFF4F6DFF), size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// FEATURE GRID — 3 kolom seperti TSX
// ─────────────────────────────────────────────
class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  static const _features = [
    {
      'title': 'AI Face Scan',
      'desc': 'Advanced facial recognition',
      'icon': Icons.document_scanner_rounded,
      'colors': [Color(0xFF4F6DFF), Color(0xFF6B84FF)],
    },
    {
      'title': 'Smart Match',
      'desc': 'Personalized frame picks',
      'icon': Icons.remove_red_eye_rounded,
      'colors': [Color(0xFF00C9A7), Color(0xFF00E6B8)],
    },
    {
      'title': 'Style Analysis',
      'desc': 'Lifestyle-based insights',
      'icon': Icons.trending_up_rounded,
      'colors': [Color(0xFF9B59B6), Color(0xFFE91E8C)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _features.map((f) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: f['colors'] as List<Color>,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    f['icon'] as IconData,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  f['title'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  f['desc'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
// ABOUT CARD — 3 item dengan gradient berbeda
// ─────────────────────────────────────────────
class _AboutCard extends StatelessWidget {
  const _AboutCard();

  static const _items = [
    {
      'title': 'AI Face Analysis',
      'desc':
          'Our advanced AI technology analyzes your facial features to determine your unique face shape, ensuring the most flattering frame recommendations.',
      'gradientColors': [Color(0xFF4F6DFF), Color(0xFF6B84FF)],
      'icon': Icons.document_scanner_rounded,
    },
    {
      'title': 'Lifestyle-Based Recommendations',
      'desc':
          'Get personalized lens and frame suggestions based on your daily activities, screen time, and lifestyle needs.',
      'gradientColors': [Color(0xFF00C9A7), Color(0xFF00E6B8)],
      'icon': Icons.trending_up_rounded,
    },
    {
      'title': 'Virtual Try-On',
      'desc':
          'See how different frames look on your face with our AR-powered virtual try-on feature before making a decision.',
      'gradientColors': [Color(0xFF9B59B6), Color(0xFFE91E8C)],
      'icon': Icons.remove_red_eye_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: _items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: i < _items.length - 1 ? 20 : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: item['gradientColors'] as List<Color>,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item['desc'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}