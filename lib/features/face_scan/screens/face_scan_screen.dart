import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../face_analysis/screen/face_analysis_screen.dart';
import '../controllers/face_scan_controller.dart';

// ─────────────────────────────────────────────────────────────
// FACE SCAN SCREEN
// ─────────────────────────────────────────────────────────────

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
              const _LoadingView(label: 'Analyzing face shape...'),
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
  const _LoadingView({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppTheme.accent),
            const SizedBox(height: 20),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CAMERA VIEW — orchestrator saja, delegasi ke sub-widget
// ─────────────────────────────────────────────────────────────

class _CameraView extends StatelessWidget {
  final FaceScanController ctrl;
  const _CameraView({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          _ScanHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _CameraCard(ctrl: ctrl),
                  const SizedBox(height: 36),
                  _ScanInfo(ctrl: ctrl),
                  const SizedBox(height: 40),
                  _ScanButton(ctrl: ctrl),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SCAN HEADER
// ─────────────────────────────────────────────────────────────

class _ScanHeader extends StatelessWidget {
  const _ScanHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4F6DFF), Color(0xFF6B84FF)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
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
            'AI Face Scan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CAMERA CARD
// ─────────────────────────────────────────────────────────────

class _CameraCard extends StatelessWidget {
  final FaceScanController ctrl;
  const _CameraCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, 10)),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(ctrl.cameraController!),
              Container(color: Colors.black.withValues(alpha: 0.15)),
              const _GridOverlay(),
              _ScanFrame(ctrl: ctrl),
              const _CameraStatusBadge(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// GRID OVERLAY
// ─────────────────────────────────────────────────────────────

class _GridOverlay extends StatelessWidget {
  const _GridOverlay();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.08,
      child: Column(
        children: List.generate(
          3,
          (_) => Expanded(
            child: Row(
              children: List.generate(
                3,
                (_) => Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SCAN FRAME — 4 sudut + scan line
// ─────────────────────────────────────────────────────────────

class _ScanFrame extends StatelessWidget {
  final FaceScanController ctrl;
  const _ScanFrame({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260,
        height: 340,
        child: Stack(
          children: [
            const _ScanCorner(top: true,  left: true),
            const _ScanCorner(top: true,  left: false),
            const _ScanCorner(top: false, left: true),
            const _ScanCorner(top: false, left: false),
            if (ctrl.state == FaceScanState.capturing)
              const _ScanLine(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SCAN CORNER — CC turun dari 17 → 4
// ─────────────────────────────────────────────────────────────

class _ScanCorner extends StatelessWidget {
  final bool top;
  final bool left;
  const _ScanCorner({required this.top, required this.left});

  static const BorderSide _filled = BorderSide(color: AppTheme.accent, width: 4);
  static const BorderSide _empty  = BorderSide.none;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top:    top  ? 0    : null,
      bottom: top  ? null : 0,
      left:   left ? 0    : null,
      right:  left ? null : 0,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          border: Border(
            top:    top  ? _filled : _empty,
            bottom: top  ? _empty  : _filled,
            left:   left ? _filled : _empty,
            right:  left ? _empty  : _filled,
          ),
          borderRadius: BorderRadius.only(
            topLeft:     (top && left)   ? const Radius.circular(24) : Radius.zero,
            topRight:    (top && !left)  ? const Radius.circular(24) : Radius.zero,
            bottomLeft:  (!top && left)  ? const Radius.circular(24) : Radius.zero,
            bottomRight: (!top && !left) ? const Radius.circular(24) : Radius.zero,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SCAN LINE
// ─────────────────────────────────────────────────────────────

class _ScanLine extends StatelessWidget {
  const _ScanLine();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 280),
      duration: const Duration(seconds: 2),
      builder: (context, value, _) {
        return Positioned(
          top: value,
          left: 0,
          right: 0,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.accent,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withValues(alpha: 0.7),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CAMERA STATUS BADGE
// ─────────────────────────────────────────────────────────────

class _CameraStatusBadge extends StatelessWidget {
  const _CameraStatusBadge();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 18,
      right: 18,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Camera Active',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SCAN INFO — ikon + judul + deskripsi
// ─────────────────────────────────────────────────────────────

class _ScanInfo extends StatelessWidget {
  final FaceScanController ctrl;
  const _ScanInfo({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final isCapturing = ctrl.state == FaceScanState.capturing;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.25),
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
          isCapturing
              ? 'Analyzing your facial structure using AI...'
              : 'Align your face inside the scanning area for accurate glasses recommendations.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SCAN BUTTON
// ─────────────────────────────────────────────────────────────

class _ScanButton extends StatelessWidget {
  final FaceScanController ctrl;
  const _ScanButton({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final isCapturing = ctrl.state == FaceScanState.capturing;

    return GestureDetector(
      onTap: isCapturing ? null : ctrl.captureAndAnalyze,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCapturing ? Icons.auto_awesome : Icons.camera_alt_rounded,
              color: Colors.white,
              size: 26,
            ),
            const SizedBox(width: 12),
            Text(
              isCapturing ? 'Scanning...' : 'Start Scan',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
  const _ErrorView({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppTheme.error,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                ctrl.errorMessage ?? 'An error occurred.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: ctrl.reset,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}