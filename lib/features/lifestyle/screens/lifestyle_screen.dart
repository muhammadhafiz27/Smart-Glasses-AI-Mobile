import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../routes/router_config.dart';
import '../controllers/lifestyle_controller.dart';

class LifestyleScreen extends StatelessWidget {
  const LifestyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Consumer<LifestyleController>(
          builder: (context, ctrl, _) => Column(
            children: [
              const _LifestyleHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const _LifestyleTitle(),
                      const SizedBox(height: 36),
                      _ActivityList(ctrl: ctrl),
                      const SizedBox(height: 8),
                      _OutdoorToggle(ctrl: ctrl),
                      const SizedBox(height: 20),
                      _ScreenTimeCard(ctrl: ctrl),
                      const SizedBox(height: 28),
                      _ActivitySummary(ctrl: ctrl),
                      const SizedBox(height: 36),
                      _ContinueButton(ctrl: ctrl),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── HEADER ──
class _LifestyleHeader extends StatelessWidget {
  const _LifestyleHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4F6DFF), Color(0xFF6B84FF)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Lifestyle Input',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// ── TITLE ──
class _LifestyleTitle extends StatelessWidget {
  const _LifestyleTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Your Daily Activities',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
        ),
        SizedBox(height: 10),
        Text(
          'Help AI recommend the best glasses for your lifestyle',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
        ),
      ],
    );
  }
}

// ── ACTIVITY LIST ──
class _ActivityList extends StatelessWidget {
  final LifestyleController ctrl;

  const _ActivityList({required this.ctrl});

  static const _activities = [
    {'label': 'Reading / Office Work', 'icon': Icons.monitor_rounded,        'index': 0},
    {'label': 'Outdoor / Sports',      'icon': Icons.wb_sunny_rounded,        'index': 1},
    {'label': 'Driving',               'icon': Icons.directions_car_rounded,  'index': 2},
    {'label': 'Night Activities',      'icon': Icons.nightlight_rounded,      'index': 3},
    {'label': 'Mixed / General',       'icon': Icons.blur_on_rounded,         'index': 4},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _activities.map((a) {
        final value    = LifestyleController.activityOptions[a['index'] as int];
        final selected = ctrl.primaryActivity == value;
        return _ActivityItem(
          label:    a['label']  as String,
          icon:     a['icon']   as IconData,
          selected: selected,
          onTap:    () => ctrl.setActivity(value),
        );
      }).toList(),
    );
  }
}

// ── ACTIVITY ITEM ──
class _ActivityItem extends StatelessWidget {
  final String   label;
  final IconData icon;
  final bool     selected;
  final VoidCallback onTap;

  const _ActivityItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppTheme.primary : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            _ActivityIcon(icon: icon, selected: selected),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: selected ? AppTheme.primary : AppTheme.textPrimary,
                ),
              ),
            ),
            _CheckCircle(selected: selected),
          ],
        ),
      ),
    );
  }
}

// ── ACTIVITY ICON ──
class _ActivityIcon extends StatelessWidget {
  final IconData icon;
  final bool     selected;

  const _ActivityIcon({required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: selected ? AppTheme.primaryGradient : null,
        color: selected ? null : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, size: 28, color: selected ? Colors.white : Colors.grey.shade700),
    );
  }
}

// ── CHECK CIRCLE ──
class _CheckCircle extends StatelessWidget {
  final bool selected;

  const _CheckCircle({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: selected ? AppTheme.primary : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppTheme.primary : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
          : null,
    );
  }
}

// ── OUTDOOR TOGGLE ──
class _OutdoorToggle extends StatelessWidget {
  final LifestyleController ctrl;

  const _OutdoorToggle({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: ctrl.outdoorActivity ? AppTheme.primaryGradient : null,
              color: ctrl.outdoorActivity ? null : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.nature_people_rounded,
              size: 26,
              color: ctrl.outdoorActivity ? Colors.white : Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Outdoor Activity',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                SizedBox(height: 2),
                Text(
                  'Do you spend time outdoors daily?',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          Switch(value: ctrl.outdoorActivity, onChanged: ctrl.setOutdoor, activeThumbColor: AppTheme.primary),
        ],
      ),
    );
  }
}

// ── SCREEN TIME CARD ──
class _ScreenTimeCard extends StatelessWidget {
  final LifestyleController ctrl;

  const _ScreenTimeCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 18, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Screen Time Per Day',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 26),
          _ScreenTimeDisplay(hours: ctrl.screenTimeHours),
          const SizedBox(height: 26),
          _ScreenTimeSlider(ctrl: ctrl),
        ],
      ),
    );
  }
}

// ── SCREEN TIME DISPLAY ──
class _ScreenTimeDisplay extends StatelessWidget {
  final int hours;

  const _ScreenTimeDisplay({required this.hours});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
          child: Text(
            '$hours',
            style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
        const Text('hours / day', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
      ],
    );
  }
}

// ── SCREEN TIME SLIDER ──
class _ScreenTimeSlider extends StatelessWidget {
  final LifestyleController ctrl;

  const _ScreenTimeSlider({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor:   AppTheme.primary,
            inactiveTrackColor: Colors.grey.shade200,
            thumbColor:         AppTheme.primary,
            overlayColor:       AppTheme.primary.withValues(alpha: 0.1),
            trackHeight:        5,
          ),
          child: Slider(
            value:     ctrl.screenTimeHours.toDouble(),
            min:       0,
            max:       12,
            divisions: 12,
            onChanged: (v) => ctrl.setScreenTime(v.round()),
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0h',  style: TextStyle(color: Colors.grey)),
            Text('6h',  style: TextStyle(color: Colors.grey)),
            Text('12h', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

// ── ACTIVITY SUMMARY ──
class _ActivitySummary extends StatelessWidget {
  final LifestyleController ctrl;

  const _ActivitySummary({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary.withValues(alpha: 0.1), AppTheme.accent.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected Activity',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 10),
          Text(
            ctrl.primaryActivity.isNotEmpty ? ctrl.primaryActivity : 'No activity selected yet',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ── CONTINUE BUTTON ──
class _ContinueButton extends StatelessWidget {
  final LifestyleController ctrl;

  const _ContinueButton({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final enabled = ctrl.primaryActivity.isNotEmpty;
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: enabled ? () => context.push(AppRoutes.lifestyleRecommendation) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: enabled ? 0.35 : 0.15),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              SizedBox(width: 10),
              Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}