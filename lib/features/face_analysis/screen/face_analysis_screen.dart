import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/router_config.dart';
import '../../face_scan/controllers/face_scan_controller.dart';

class FaceAnalysisScreen extends StatelessWidget {
  const FaceAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<FaceScanController>();
    final result = ctrl.result;

    if (result == null) {
      return const Scaffold(
        body: Center(
          child: Text('No analysis data found'),
        ),
      );
    }

    final shapeName =
        AppConstants.faceShapeNames[result.shape] ?? result.shape;

    final description =
        AppConstants.faceShapeDescriptions[result.shape] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [
                  // SUCCESS ICON
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00C9A7),
                          Color(0xFF00E6B8),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accent.withOpacity(0.35),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 72,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // TITLE
                  const Text(
                    'Face Analysis',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // RESULT CARD
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primary.withOpacity(0.10),
                          AppTheme.accent.withOpacity(0.10),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Detected Face Shape',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 14),

                        ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [
                                AppTheme.primary,
                                AppTheme.accent,
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            shapeName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // CONFIDENCE
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Confidence',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  result.confidencePercent,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: LinearProgressIndicator(
                                value: result.confidence,
                                minHeight: 12,
                                backgroundColor: Colors.grey.shade300,
                                valueColor:
                                    const AlwaysStoppedAnimation(
                                  AppTheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // INFO CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // CONTINUE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push(AppRoutes.lifestyle);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(100),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}