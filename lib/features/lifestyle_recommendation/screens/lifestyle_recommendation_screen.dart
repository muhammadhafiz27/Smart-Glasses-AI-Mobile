import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../routes/router_config.dart';
import '../../lifestyle/controllers/lifestyle_controller.dart';

// ── DATA MODEL ──
class _Recommendation {
  final String   title;
  final String   description;
  final IconData icon;
  final Color    gradientStart;
  final Color    gradientEnd;

  const _Recommendation({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
  });
}

// ── RULE ENGINE ──
class _RecommendationEngine {
  static List<_Recommendation> evaluate(LifestyleController ctrl) {
    final results    = <_Recommendation>[];
    final activity   = ctrl.primaryActivity.toLowerCase();
    final screenTime = ctrl.screenTimeHours;
    final isOutdoor  = ctrl.outdoorActivity;

    _addBlueLight(results, screenTime);
    _addAntiReflection(results, activity, screenTime);
    _addUvProtection(results, isOutdoor, activity);
    _addNightMode(results, activity, screenTime);
    _add202020Rule(results, screenTime);
    _addMyopiaPrevention(results, screenTime, isOutdoor);

    if (results.isEmpty) _addGeneral(results);

    return results;
  }

  static void _addBlueLight(List<_Recommendation> r, int screenTime) {
    if (screenTime < 6) return;
    r.add(const _Recommendation(
      title: 'Blue Light Protection',
      description:
          'Screen time ≥6 jam/hari meningkatkan risiko Digital Eye Strain (DES). '
          'Lensa blue-light filtering terbukti mengurangi kelelahan mata dan '
          'gangguan tidur akibat paparan HEV 400–500 nm (Sheppard & Wolffsohn, 2018).',
      icon: Icons.monitor_rounded,
      gradientStart: Color(0xFF4F6DFF),
      gradientEnd: Color(0xFF6B84FF),
    ));
  }

  static void _addAntiReflection(List<_Recommendation> r, String activity, int screenTime) {
    if (!activity.contains('office') && !activity.contains('reading') && screenTime < 4) return;
    r.add(const _Recommendation(
      title: 'Anti-Reflection Coating',
      description:
          'Coating AR menghilangkan hingga 99% pantulan dari layar & lampu '
          'fluorescent di lingkungan kerja. Studi AAO (2023) menyatakan lapisan '
          'ini esensial untuk pekerja kantor guna menjaga kontras dan ketajaman visual.',
      icon: Icons.shield_rounded,
      gradientStart: Color(0xFF00C9A7),
      gradientEnd: Color(0xFF00E6B8),
    ));
  }

  static void _addUvProtection(List<_Recommendation> r, bool isOutdoor, String activity) {
    if (!isOutdoor && !activity.contains('driving') &&
        !activity.contains('outdoor') && !activity.contains('sports')) {
      return;
    }
    r.add(const _Recommendation(
      title: 'UV & Polarized Protection',
      description:
          'Paparan UV kronik meningkatkan risiko katarak dan degenerasi makula '
          '(WHO, 2022). Lensa polarized mengurangi disability glare hingga 30% '
          'saat mengemudi, meningkatkan keamanan penglihatan (Rosenfield, 2016).',
      icon: Icons.wb_sunny_rounded,
      gradientStart: Color(0xFFF59E0B),
      gradientEnd: Color(0xFFF97316),
    ));
  }

  static void _addNightMode(List<_Recommendation> r, String activity, int screenTime) {
    if (!activity.contains('night') && screenTime < 8) return;
    r.add(const _Recommendation(
      title: 'Night Mode Lens',
      description:
          'Paparan layar setelah pukul 21.00 menekan melatonin hingga 50% '
          '(Chang et al., 2015). Lensa tint kuning ringan + AR coating '
          'mengurangi disability glare dan mendukung ritme sirkadian yang sehat.',
      icon: Icons.nightlight_rounded,
      gradientStart: Color(0xFF8B5CF6),
      gradientEnd: Color(0xFFEC4899),
    ));
  }

  static void _add202020Rule(List<_Recommendation> r, int screenTime) {
    if (screenTime <= 0) return;
    r.add(const _Recommendation(
      title: 'Aturan 20-20-20',
      description:
          'Setiap 20 menit, alihkan pandangan ke objek sejauh 20 kaki (6 m) '
          'selama 20 detik. Metode ini terbukti meredakan spasme akomodasi dan '
          'mengurangi gejala DES (Ciuffreda et al.; direkomendasikan AAO).',
      icon: Icons.access_time_rounded,
      gradientStart: Color(0xFF06B6D4),
      gradientEnd: Color(0xFF0EA5E9),
    ));
  }

  static void _addMyopiaPrevention(List<_Recommendation> r, int screenTime, bool isOutdoor) {
    if (screenTime < 6 || isOutdoor) return;
    r.add(const _Recommendation(
      title: 'Pencegahan Miopi',
      description:
          'Holden et al. (2016) memproyeksikan 50% populasi miopi pada 2050, '
          'dipercepat oleh near-work berlebihan. Aktivitas luar ruangan ≥2 jam/hari '
          'terbukti menunda onset dan progresi miopi melalui stimulasi dopamin retina.',
      icon: Icons.visibility_rounded,
      gradientStart: Color(0xFF10B981),
      gradientEnd: Color(0xFF34D399),
    ));
  }

  static void _addGeneral(List<_Recommendation> r) {
    r.add(const _Recommendation(
      title: 'Jaga Kesehatan Mata',
      description:
          'Pemeriksaan mata rutin setiap 1–2 tahun direkomendasikan meski tidak '
          'ada keluhan (AAO, 2023). Pola hidup seimbang, nutrisi cukup lutein & '
          'zeaxanthin, serta pencahayaan ruangan yang baik mendukung kesehatan mata.',
      icon: Icons.favorite_rounded,
      gradientStart: Color(0xFF4F6DFF),
      gradientEnd: Color(0xFF00C9A7),
    ));
  }
}

// ── SCREEN ──
class LifestyleRecommendationScreen extends StatelessWidget {
  const LifestyleRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl            = context.watch<LifestyleController>();
    final recommendations = _RecommendationEngine.evaluate(ctrl);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Column(
          children: [
            const _RecommendationHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    _SummaryCard(ctrl: ctrl),
                    const SizedBox(height: 20),
                    ..._buildRecommendationList(recommendations),
                    const _DisclaimerAlert(),
                    const SizedBox(height: 28),
                    const _ContinueButton(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRecommendationList(List<_Recommendation> recs) {
    return recs.map((rec) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _RecommendationCard(rec: rec),
    )).toList();
  }
}

// ── HEADER ──
class _RecommendationHeader extends StatelessWidget {
  const _RecommendationHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF4F6DFF), Color(0xFF6B84FF)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _BackButton(),
              const SizedBox(width: 14),
              const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 26),
              const SizedBox(width: 10),
              const Flexible(
                child: Text(
                  'Lifestyle Recommendations',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 44),
            child: Text(
              'Personalized insights based on your daily activities',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ── BACK BUTTON ──
class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
      ),
    );
  }
}

// ── DISCLAIMER ALERT ──
class _DisclaimerAlert extends StatelessWidget {
  const _DisclaimerAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFFBEB), Color(0xFFFFF7ED)]),
        borderRadius: BorderRadius.circular(16),
        border: const Border(left: BorderSide(color: Color(0xFFF59E0B), width: 4)),
      ),
      padding: const EdgeInsets.all(16),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Rekomendasi ini berbasis riset ilmiah dan kebiasaan '
              'hidup Anda. Untuk saran medis, konsultasikan dengan '
              'dokter mata atau optometris.',
              style: TextStyle(fontSize: 12, color: Color(0xFF374151), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ── CONTINUE BUTTON ──
class _ContinueButton extends StatelessWidget {
  const _ContinueButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.recommendation),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF4F6DFF), Color(0xFF00C9A7)]),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4F6DFF).withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View Glasses Recommendations',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── SUMMARY CARD ──
class _SummaryCard extends StatelessWidget {
  final LifestyleController ctrl;

  const _SummaryCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SummaryHeader(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatChip(
                  value: '${ctrl.screenTimeHours}h',
                  label: 'Screen Time',
                  color: const Color(0xFF4F6DFF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatChip(
                  value: ctrl.primaryActivity,
                  label: 'Primary Use',
                  color: const Color(0xFF00C9A7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── SUMMARY HEADER ──
class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF4F6DFF), Color(0xFF00C9A7)]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.shield_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 14),
        const Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analysis Complete',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF1F2937)),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                "We've analyzed your lifestyle patterns",
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── STAT CHIP ──
class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color  color;

  const _StatChip({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }
}

// ── RECOMMENDATION CARD ──
class _RecommendationCard extends StatelessWidget {
  final _Recommendation rec;

  const _RecommendationCard({required this.rec});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [rec.gradientStart, rec.gradientEnd]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(rec.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1F2937)),
                ),
                const SizedBox(height: 6),
                Text(
                  rec.description,
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