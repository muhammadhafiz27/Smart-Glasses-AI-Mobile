import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/recommendation_models.dart';
import '../../../routes/router_config.dart';
import '../../face_scan/controllers/face_scan_controller.dart';
import '../../lifestyle/controllers/lifestyle_controller.dart';
import '../controllers/recommendation_controller.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() =>
      _RecommendationScreenState();
}

class _RecommendationScreenState
    extends State<RecommendationScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final face = context.read<FaceScanController>();
      final lifestyle = context.read<LifestyleController>();

      context
          .read<RecommendationController>()
          .rebuild(face, lifestyle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Consumer<RecommendationController>(
        builder: (context, ctrl, _) {
          final result = ctrl.result;

          if (result == null) {
            return const _EmptyState();
          }

          return _RecommendationBody(result: result);
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => context.go(AppRoutes.faceScan),
        child: const Text('Start Face Scan'),
      ),
    );
  }
}

class _RecommendationBody extends StatelessWidget {
  final PersonalizationResult result;

  const _RecommendationBody({
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final shapeName =
        AppConstants.faceShapeNames[result.faceShape] ??
            result.faceShape;

    final lifestyle =
        context.read<LifestyleController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 70, 24, 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4F6DFF),
                    Color(0xFF6B84FF),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Your Personalized Result',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'AI-powered recommendations just for you',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // SUMMARY CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(
                                        0xFF4F6DFF)
                                    .withOpacity(0.08),
                                borderRadius:
                                    BorderRadius.circular(
                                        18),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Face Shape',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color:
                                          Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    shapeName,
                                    style:
                                        const TextStyle(
                                      fontSize: 22,
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                      color: Color(
                                          0xFF4F6DFF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(
                                        0xFF00C9A7)
                                    .withOpacity(0.08),
                                borderRadius:
                                    BorderRadius.circular(
                                        18),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Lifestyle',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color:
                                          Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    lifestyle
                                        .primaryActivity,
                                    textAlign:
                                        TextAlign.center,
                                    style:
                                        const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                      color: Color(
                                          0xFF00C9A7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // FRAME CARD
                    _GlassSection(
                      title: 'Recommended Frames',
                      child: Column(
                        children: [
                          ...result.frames
                              .asMap()
                              .entries
                              .map(
                                (e) => _FrameItem(
                                  frame: e.value,
                                  index: e.key,
                                ),
                              ),

                          const SizedBox(height: 16),

                          Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(
                                      20),
                              gradient:
                                  LinearGradient(
                                colors: [
                                  const Color(
                                          0xFF4F6DFF)
                                      .withOpacity(0.12),
                                  const Color(
                                          0xFF00C9A7)
                                      .withOpacity(0.12),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.visibility_rounded,
                                size: 80,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // LENS CARD
                    _GlassSection(
                      title: 'Recommended Lenses',
                      child: Column(
                        children: result.lenses
                            .map(
                              (lens) => _LensItem(
                                lens: lens,
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // TRY ON BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            context.push(
                                AppRoutes.tryOn),
                        style:
                            ElevatedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    40),
                          ),
                          backgroundColor:
                              Colors.transparent,
                          shadowColor:
                              Colors.transparent,
                        ).copyWith(
                          backgroundColor:
                              WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                        child: Ink(
                          decoration:
                              BoxDecoration(
                            gradient:
                                AppTheme.primaryGradient,
                            borderRadius:
                                BorderRadius.circular(
                                    40),
                          ),
                          child: Container(
                            alignment:
                                Alignment.center,
                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 18,
                            ),
                            child: const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              children: [
                                Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Try in AR',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // BACK BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            context.go(
                                AppRoutes.home),
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.grey.shade200,
                          foregroundColor:
                              Colors.black87,
                          elevation: 0,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    40),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home_rounded),
                            SizedBox(width: 10),
                            Text(
                              'Back to Home',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

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

class _GlassSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _GlassSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _FrameItem extends StatelessWidget {
  final FrameRecommendation frame;
  final int index;

  const _FrameItem({
    required this.frame,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF8F9FB),
            Color(0xFFF1F3F6),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  frame.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Perfect match for your face',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF00C9A7)
                  .withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(30),
            ),
            child: Text(
              '${((1 - (index * 0.08)) * 100).toInt()}%',
              style: const TextStyle(
                color: Color(0xFF00C9A7),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LensItem extends StatelessWidget {
  final LensRecommendation lens;

  const _LensItem({
    required this.lens,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00C9A7)
            .withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00C9A7),
                  Color(0xFF00E6B8),
                ],
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
            ),
            child: Text(
              lens.iconLabel,
              style: const TextStyle(
                fontSize: 22,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              lens.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),

          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFF00C9A7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}