import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            const _Header(),
            Transform.translate(
              offset: const Offset(0, -60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ScanButton(onTap: () => context.push(AppRoutes.faceScan)),
                    const SizedBox(height: 28),
                    const _SectionTitle(icon: Icons.auto_awesome_rounded, text: 'Why Choose Us'),
                    const SizedBox(height: 14),
                    const _FeatureGrid(),
                    const SizedBox(height: 28),
                    const _SectionTitle(icon: null, text: 'About This App'),
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

// ── HEADER ──
class _Header extends StatelessWidget {
  const _Header();

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
          const _DecorativeCircle(right: -50, top: -30, size: 160),
          const _DecorativeCircle(left: -60, bottom: -40, size: 130),
          const _HeaderContent(),
        ],
      ),
    );
  }
}

// ── DECORATIVE CIRCLE ──
class _DecorativeCircle extends StatelessWidget {
  final double? right;
  final double? top;
  final double? left;
  final double? bottom;
  final double  size;

  const _DecorativeCircle({
    this.right,
    this.top,
    this.left,
    this.bottom,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right:  right,
      top:    top,
      left:   left,
      bottom: bottom,
      child: Container(
        width:  size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ── HEADER CONTENT ──
class _HeaderContent extends StatelessWidget {
  const _HeaderContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.remove_red_eye_rounded, color: Colors.white, size: 48),
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
    );
  }
}

// ── SCAN BUTTON ──
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
            const _ScanButtonIcon(),
            const SizedBox(width: 16),
            const _ScanButtonText(),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF), size: 24),
          ],
        ),
      ),
    );
  }
}

// ── SCAN BUTTON ICON ──
class _ScanButtonIcon extends StatelessWidget {
  const _ScanButtonIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 30),
    );
  }
}

// ── SCAN BUTTON TEXT ──
class _ScanButtonText extends StatelessWidget {
  const _ScanButtonText();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Start New Scan',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
              ),
              SizedBox(width: 6),
              Icon(Icons.auto_awesome_rounded, color: Color(0xFF4F6DFF), size: 16),
            ],
          ),
          SizedBox(height: 3),
          Text(
            'AI-powered face analysis in seconds',
            style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}

// ── SECTION TITLE ──
class _SectionTitle extends StatelessWidget {
  final String   text;
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
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
        ),
      ],
    );
  }
}

// ── FEATURE GRID ──
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
      children: _features.map((f) => Expanded(
        child: _FeatureItem(feature: f),
      )).toList(),
    );
  }
}

// ── FEATURE ITEM ──
class _FeatureItem extends StatelessWidget {
  final Map<String, Object> feature;

  const _FeatureItem({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: feature['colors'] as List<Color>,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(feature['icon'] as IconData, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            feature['title'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
          ),
          const SizedBox(height: 4),
          Text(
            feature['desc'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280), height: 1.4),
          ),
        ],
      ),
    );
  }
}

// ── ABOUT CARD ──
class _AboutCard extends StatelessWidget {
  const _AboutCard();

  static const _items = [
    {
      'title': 'AI Face Analysis',
      'desc': 'Our advanced AI technology analyzes your facial features to determine your unique face shape, ensuring the most flattering frame recommendations.',
      'gradientColors': [Color(0xFF4F6DFF), Color(0xFF6B84FF)],
      'icon': Icons.document_scanner_rounded,
    },
    {
      'title': 'Lifestyle-Based Recommendations',
      'desc': 'Get personalized lens and frame suggestions based on your daily activities, screen time, and lifestyle needs.',
      'gradientColors': [Color(0xFF00C9A7), Color(0xFF00E6B8)],
      'icon': Icons.trending_up_rounded,
    },
    {
      'title': 'Virtual Try-On',
      'desc': 'See how different frames look on your face with our AR-powered virtual try-on feature before making a decision.',
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 14, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: _items.asMap().entries.map((entry) {
          return _AboutItem(
            item: entry.value,
            isLast: entry.key == _items.length - 1,
          );
        }).toList(),
      ),
    );
  }
}

// ── ABOUT ITEM ──
class _AboutItem extends StatelessWidget {
  final Map<String, Object> item;
  final bool isLast;

  const _AboutItem({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
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
            child: Icon(item['icon'] as IconData, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1F2937)),
                ),
                const SizedBox(height: 5),
                Text(
                  item['desc'] as String,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.55),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}