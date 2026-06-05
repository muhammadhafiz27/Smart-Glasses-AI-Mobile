import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../face_analysis/screen/face_analysis_screen.dart';
import '../controllers/face_scan_controller.dart';

class FaceScanScreen extends StatefulWidget {
  const FaceScanScreen({super.key});

  @override
  State<FaceScanScreen> createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FaceScanController>().initCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<FaceScanController>(
        builder: (context, ctrl, _) {
          return switch (ctrl.state) {
            FaceScanState.idle =>
              const _LoadingView(label: 'Initializing...'),

            FaceScanState.cameraReady ||
            FaceScanState.capturing =>
              _CameraView(ctrl: ctrl),

            FaceScanState.analyzing =>
              const _LoadingView(
                label: 'Analyzing face shape...',
              ),

            FaceScanState.done =>
              const FaceAnalysisScreen(),

            FaceScanState.error =>
              _ErrorView(ctrl: ctrl),
          };
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// LOADING VIEW
// ─────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  final String label;

  const _LoadingView({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppTheme.accent,
            ),

            const SizedBox(height: 20),

            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CAMERA VIEW
// ─────────────────────────────────────────────────────────────

class _CameraView extends StatelessWidget {
  final FaceScanController ctrl;

  const _CameraView({
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    final cam = ctrl.cameraController!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          // HEADER
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 20,
              right: 20,
              bottom: 20,
            ),
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
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
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
                  'AI Face Scan',
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
                  // CAMERA CARD
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 24,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // CAMERA
                            CameraPreview(cam),

                            // DARK OVERLAY
                            Container(
                              color: Colors.black.withOpacity(0.15),
                            ),

                            // GRID
                            Opacity(
                              opacity: 0.08,
                              child: Column(
                                children: List.generate(
                                  3,
                                  (row) => Expanded(
                                    child: Row(
                                      children: List.generate(
                                        3,
                                        (col) => Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // SCAN FRAME
                            Center(
                              child: SizedBox(
                                width: 260,
                                height: 340,
                                child: Stack(
                                  children: [
                                    _corner(
                                      top: true,
                                      left: true,
                                    ),

                                    _corner(
                                      top: true,
                                      left: false,
                                    ),

                                    _corner(
                                      top: false,
                                      left: true,
                                    ),

                                    _corner(
                                      top: false,
                                      left: false,
                                    ),

                                    // SCAN LINE
                                    if (ctrl.state ==
                                        FaceScanState.capturing)
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(
                                          begin: 0,
                                          end: 280,
                                        ),
                                        duration: const Duration(
                                          seconds: 2,
                                        ),
                                        builder:
                                            (context, value, child) {
                                          return Positioned(
                                            top: value,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color:
                                                    AppTheme.accent,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppTheme
                                                        .accent
                                                        .withOpacity(
                                                          0.7,
                                                        ),
                                                    blurRadius: 12,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            // STATUS
                            Positioned(
                              top: 18,
                              right: 18,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.black.withOpacity(
                                    0.45,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(40),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration:
                                          const BoxDecoration(
                                        color:
                                            Colors.greenAccent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    const Text(
                                      'Camera Active',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ICON
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius:
                          BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary
                              .withOpacity(0.25),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.face_retouching_natural,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Smart AI Detection',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    ctrl.state ==
                            FaceScanState.capturing
                        ? 'Analyzing your facial structure using AI...'
                        : 'Align your face inside the scanning area for accurate glasses recommendations.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // BUTTON
                  GestureDetector(
                    onTap:
                        ctrl.state ==
                                FaceScanState.capturing
                            ? null
                            : ctrl.captureAndAnalyze,
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 250,
                      ),
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 36,
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
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            ctrl.state ==
                                    FaceScanState
                                        .capturing
                                ? Icons.auto_awesome
                                : Icons
                                    .camera_alt_rounded,
                            color: Colors.white,
                            size: 26,
                          ),

                          const SizedBox(width: 12),

                          Text(
                            ctrl.state ==
                                    FaceScanState
                                        .capturing
                                ? 'Scanning...'
                                : 'Start Scan',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
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
    );
  }

  Widget _corner({
    required bool top,
    required bool left,
  }) {
    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: left ? 0 : null,
      right: left ? null : 0,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          border: Border(
            top: top
                ? const BorderSide(
                    color: AppTheme.accent,
                    width: 4,
                  )
                : BorderSide.none,
            bottom: !top
                ? const BorderSide(
                    color: AppTheme.accent,
                    width: 4,
                  )
                : BorderSide.none,
            left: left
                ? const BorderSide(
                    color: AppTheme.accent,
                    width: 4,
                  )
                : BorderSide.none,
            right: !left
                ? const BorderSide(
                    color: AppTheme.accent,
                    width: 4,
                  )
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft:
                top && left
                    ? const Radius.circular(24)
                    : Radius.zero,
            topRight:
                top && !left
                    ? const Radius.circular(24)
                    : Radius.zero,
            bottomLeft:
                !top && left
                    ? const Radius.circular(24)
                    : Radius.zero,
            bottomRight:
                !top && !left
                    ? const Radius.circular(24)
                    : Radius.zero,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ERROR VIEW
// ─────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final FaceScanController ctrl;

  const _ErrorView({
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppTheme.error,
                size: 64,
              ),

              const SizedBox(height: 16),

              Text(
                ctrl.errorMessage ??
                    'An error occurred.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: ctrl.reset,
                icon: const Icon(
                  Icons.refresh_rounded,
                ),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}