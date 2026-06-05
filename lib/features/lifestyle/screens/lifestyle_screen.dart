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
          builder: (context, ctrl, _) {
            final activities = [
              {
                'label': 'Reading / Office Work',
                'value': LifestyleController.activityOptions[0],
                'icon': Icons.monitor_rounded,
              },
              {
                'label': 'Outdoor / Sports',
                'value': LifestyleController.activityOptions[1],
                'icon': Icons.wb_sunny_rounded,
              },
              {
                'label': 'Driving',
                'value': LifestyleController.activityOptions[2],
                'icon': Icons.directions_car_rounded,
              },
              {
                'label': 'Night Activities',
                'value': LifestyleController.activityOptions[3],
                'icon': Icons.nightlight_rounded,
              },
              {
                'label': 'Mixed / General',
                'value': LifestyleController.activityOptions[4],
                'icon': Icons.blur_on_rounded,
              },
            ];

            return Column(
              children: [
                // HEADER
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF4F6DFF),
                        Color(0xFF6B84FF),
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 14,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Lifestyle Input',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // TITLE
                        const Text(
                          'Your Daily Activities',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Help AI recommend the best glasses for your lifestyle',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ACTIVITIES
                        Column(
                          children: activities.map((activity) {
                            final selected =
                                ctrl.primaryActivity ==
                                    activity['value'];

                            return GestureDetector(
                              onTap: () => ctrl.setActivity(
                                activity['value'] as String,
                              ),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 250),
                                margin:
                                    const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppTheme.primary
                                          .withOpacity(0.08)
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(24),
                                  border: Border.all(
                                    color: selected
                                        ? AppTheme.primary
                                        : Colors.grey.shade200,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // ICON
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      padding:
                                          const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: selected
                                            ? AppTheme
                                                .primaryGradient
                                            : null,
                                        color: selected
                                            ? null
                                            : Colors.grey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(
                                                20),
                                      ),
                                      child: Icon(
                                        activity['icon']
                                            as IconData,
                                        size: 28,
                                        color: selected
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                      ),
                                    ),

                                    const SizedBox(width: 18),

                                    // TEXT
                                    Expanded(
                                      child: Text(
                                        activity['label']
                                            as String,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: selected
                                              ? AppTheme.primary
                                              : AppTheme
                                                  .textPrimary,
                                        ),
                                      ),
                                    ),

                                    // CHECK
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? AppTheme.primary
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: selected
                                              ? AppTheme.primary
                                              : Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                      child: selected
                                          ? const Icon(
                                              Icons.check_rounded,
                                              color: Colors.white,
                                              size: 18,
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 8),

                        // OUTDOOR TOGGLE
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: ctrl.outdoorActivity
                                      ? AppTheme.primaryGradient
                                      : null,
                                  color: ctrl.outdoorActivity
                                      ? null
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.nature_people_rounded,
                                  size: 26,
                                  color: ctrl.outdoorActivity
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Outdoor Activity',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Do you spend time outdoors daily?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: ctrl.outdoorActivity,
                                onChanged: ctrl.setOutdoor,
                                activeColor: AppTheme.primary,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // SCREEN TIME CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withOpacity(0.05),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Screen Time Per Day',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),

                              const SizedBox(height: 26),

                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return AppTheme.primaryGradient
                                      .createShader(bounds);
                                },
                                child: Text(
                                  '${ctrl.screenTimeHours}',
                                  style: const TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const Text(
                                'hours / day',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 26),

                              SliderTheme(
                                data: SliderTheme.of(context)
                                    .copyWith(
                                  activeTrackColor:
                                      AppTheme.primary,
                                  inactiveTrackColor:
                                      Colors.grey.shade200,
                                  thumbColor: AppTheme.primary,
                                  overlayColor: AppTheme.primary
                                      .withOpacity(0.1),
                                  trackHeight: 5,
                                ),
                                child: Slider(
                                  value: ctrl.screenTimeHours
                                      .toDouble(),
                                  min: 0,
                                  max: 12,
                                  divisions: 12,
                                  onChanged: (v) {
                                    ctrl.setScreenTime(
                                      v.round(),
                                    );
                                  },
                                ),
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: const [
                                  Text(
                                    '0h',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '6h',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '12h',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // SUMMARY
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primary.withOpacity(0.1),
                                AppTheme.accent.withOpacity(0.1),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selected Activity',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: AppTheme.textPrimary,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                ctrl.primaryActivity.isNotEmpty
                                    ? ctrl.primaryActivity
                                    : 'No activity selected yet',
                                style: const TextStyle(
                                  color:
                                      AppTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: ctrl.primaryActivity.isEmpty
                                ? null
                                : () {
                                    context.push(
                                      AppRoutes
                                          .lifestyleRecommendation,
                                    );
                                  },
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 250),
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                gradient:
                                    AppTheme.primaryGradient,
                                borderRadius:
                                    BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary
                                        .withOpacity(0.35),
                                    blurRadius: 18,
                                    offset:
                                        const Offset(0, 8),
                                  )
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continue',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}