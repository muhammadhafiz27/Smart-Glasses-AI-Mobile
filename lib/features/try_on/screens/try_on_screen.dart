import 'dart:typed_data';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/recommendation_models.dart';
import '../../recommendation/controllers/recommendation_controller.dart';

// ── GLASSES ASSET MAPPER ──
class GlassesAssetMapper {
  static const Map<String, String> _map = {
    'angular':       'assets/glasses/angular.png',
    'rectangular':   'assets/glasses/angular.png',
    'square':        'assets/glasses/square.png',
    'wide rectangle':'assets/glasses/wide_rectangular.png',
    'browline':      'assets/glasses/browline.png',
    'half-rimless':  'assets/glasses/half_rimless.png',
    'half rimless':  'assets/glasses/half_rimless.png',
    'butterfly':     'assets/glasses/butterfly.png',
    'bottom-heavy':  'assets/glasses/bottom_heavy.png',
    'geometric':     'assets/glasses/geometric.png',
    'rimless':       'assets/glasses/rimless.png',
    'light rimless': 'assets/glasses/light_rimless.png',
    'aviator':       'assets/glasses/aviator.png',
    'oval':          'assets/glasses/Oval.png',
    'round':         'assets/glasses/round.png',
    'deep lens':     'assets/glasses/deep_lens.png',
    'wide frame':    'assets/glasses/wide_frame.png',
  };

  static const String _fallback = 'assets/glasses/round.png';

  static String fromName(String frameName) {
    final lower = frameName.toLowerCase();
    for (final entry in _map.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return _fallback;
  }
}

// ── SCREEN ──
class TryOnScreen extends StatefulWidget {
  const TryOnScreen({super.key});

  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen>
    with SingleTickerProviderStateMixin {
  int _selectedFrameIndex = 0;

  late final AnimationController _pulseCtrl;
  late final Animation<double>   _pulseAnim;

  CameraController? _cameraController;
  bool _isCameraReady = false;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  Face? _detectedFace;
  bool _isDetecting = false;
  Size _imageSize   = Size.zero;

  static const _rotation = InputImageRotation.rotation270deg;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  Future<void> _initCamera() async {
    try {
      final cameras     = await availableCameras();
      final frontCamera = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
      _cameraController = CameraController(frontCamera, ResolutionPreset.low, enableAudio: false);
      await _cameraController!.initialize();
      await _cameraController!.startImageStream(_onCameraImage);
      if (!mounted) return;
      setState(() => _isCameraReady = true);
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void _onCameraImage(CameraImage image) {
    if (_isDetecting) return;
    _isDetecting = true;
    _processCameraImage(image).whenComplete(() => _isDetecting = false);
  }

  Future<void> _processCameraImage(CameraImage image) async {
    try {
      _imageSize = Size(image.width.toDouble(), image.height.toDouble());
      final inputImage = _buildInputImage(image);
      if (inputImage == null) return;
      final faces = await _faceDetector.processImage(inputImage);
      if (mounted) setState(() => _detectedFace = faces.isNotEmpty ? faces.first : null);
    } catch (e) {
      debugPrint('Process error: $e');
    }
  }

  InputImage? _buildInputImage(CameraImage image) {
    if (image.planes.length >= 3) return _buildAndroidImage(image);
    if (image.planes.length == 1) return _buildIosImage(image);
    return null;
  }

  InputImage _buildAndroidImage(CameraImage image) {
    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final width         = image.width;
    final height        = image.height;
    final yRowStride    = yPlane.bytesPerRow;
    final uvRowStride   = uPlane.bytesPerRow;
    final uvPixelStride = uPlane.bytesPerPixel ?? 1;

    final nv21 = Uint8List(
      width * height + 2 * ((width / 2).ceil()) * ((height / 2).ceil()),
    );

    int idx = 0;
    for (int row = 0; row < height; row++) {
      final rowStart = row * yRowStride;
      for (int col = 0; col < width; col++) {
        nv21[idx++] = yPlane.bytes[rowStart + col];
      }
    }
    for (int row = 0; row < height ~/ 2; row++) {
      final rowStart = row * uvRowStride;
      for (int col = 0; col < width ~/ 2; col++) {
        final uvOffset = rowStart + col * uvPixelStride;
        if (uvOffset < vPlane.bytes.length) nv21[idx++] = vPlane.bytes[uvOffset];
        if (uvOffset < uPlane.bytes.length) nv21[idx++] = uPlane.bytes[uvOffset];
      }
    }

    return InputImage.fromBytes(
      bytes: nv21,
      metadata: InputImageMetadata(
        size: Size(width.toDouble(), height.toDouble()),
        rotation: _rotation,
        format: InputImageFormat.nv21,
        bytesPerRow: width,
      ),
    );
  }

  InputImage _buildIosImage(CameraImage image) {
    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: _imageSize,
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.bgra8888,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _faceDetector.close();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result     = context.watch<RecommendationController>().result;
    final screenSize = MediaQuery.of(context).size;
    final frameName  = (result != null && result.frames.isNotEmpty)
        ? result.frames[_selectedFrameIndex].name
        : '';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _CameraLayer(isCameraReady: _isCameraReady, controller: _cameraController),
          Container(color: Colors.black.withOpacity(0.15)),
          if (_detectedFace != null && _isCameraReady)
            ..._buildGlassesPositioned(screenSize, frameName),
          const _TopBar(),
          _ArBadge(screenSize: screenSize, faceDetected: _detectedFace != null),
          _BottomSelector(
            result: result,
            selectedIndex: _selectedFrameIndex,
            onSelect: (i) => setState(() => _selectedFrameIndex = i),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGlassesPositioned(Size screenSize, String frameName) {
    final face     = _detectedFace!;
    final leftEye  = face.landmarks[FaceLandmarkType.leftEye];
    final rightEye = face.landmarks[FaceLandmarkType.rightEye];

    final double rawEyeX;
    final double rawEyeY;
    double rotationAngle = 0.0;

    if (leftEye != null && rightEye != null) {
      rawEyeX = (leftEye.position.x + rightEye.position.x) / 2;
      rawEyeY = (leftEye.position.y + rightEye.position.y) / 2;
      final dx = (rightEye.position.x - leftEye.position.x).toDouble();
      final dy = (rightEye.position.y - leftEye.position.y).toDouble();
      rotationAngle = -math.atan2(dy, dx);
    } else {
      rawEyeX      = face.boundingBox.center.dx;
      rawEyeY      = face.boundingBox.top + face.boundingBox.height * 0.35;
      rotationAngle = ((face.headEulerAngleZ ?? 0) * math.pi / 180);
    }

    final imgW   = _imageSize.height;
    final scaleX = screenSize.width  / imgW;
    final scaleY = screenSize.height / _imageSize.width;

    final screenX      = screenSize.width - (rawEyeX * scaleX);
    final screenY      = rawEyeY * scaleY;
    final faceScreenW  = face.boundingBox.width * scaleX;
    final glassesWidth = (faceScreenW * 1.6).clamp(80.0, 320.0);
    final assetPath    = GlassesAssetMapper.fromName(frameName);

    return [
      Positioned(
        left: screenX - glassesWidth / 2,
        top:  screenY - glassesWidth * 0.3,
        child: Transform.rotate(
          angle: rotationAngle,
          child: ScaleTransition(
            scale: _pulseAnim,
            child: _GlassesWidget(width: glassesWidth, assetPath: assetPath),
          ),
        ),
      ),
    ];
  }
}

// ── CAMERA LAYER ──
class _CameraLayer extends StatelessWidget {
  final bool              isCameraReady;
  final CameraController? controller;

  const _CameraLayer({required this.isCameraReady, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (isCameraReady && controller != null) return CameraPreview(controller!);
    return const Center(child: CircularProgressIndicator(color: AppTheme.accent));
  }
}

// ── TOP BAR ──
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── AR BADGE ──
class _ArBadge extends StatelessWidget {
  final Size screenSize;
  final bool faceDetected;

  const _ArBadge({required this.screenSize, required this.faceDetected});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top:   screenSize.height * 0.12,
      left:  0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.accent.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.view_in_ar_rounded, color: AppTheme.accent, size: 16),
              const SizedBox(width: 6),
              Text(
                faceDetected ? 'AI Face Tracking Active' : 'Mendeteksi Wajah...',
                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── BOTTOM SELECTOR ──
class _BottomSelector extends StatelessWidget {
  final dynamic result;
  final int     selectedIndex;
  final ValueChanged<int> onSelect;

  const _BottomSelector({
    required this.result,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left:   0,
      right:  0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end:   Alignment.topCenter,
            colors: [Colors.black, Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Frame to Preview', style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 12),
            if (result != null && result.frames.isNotEmpty)
              _FrameSelector(
                frames:        result.frames,
                selectedIndex: selectedIndex,
                onSelect:      onSelect,
              )
            else
              const Text('No frames loaded.', style: TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ── GLASSES WIDGET ──
class _GlassesWidget extends StatelessWidget {
  final double width;
  final String assetPath;

  const _GlassesWidget({required this.width, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      fit: BoxFit.fitWidth,
      errorBuilder: (_, __, ___) => SizedBox(
        width: width,
        child: const Icon(Icons.visibility_outlined, color: Colors.white54, size: 40),
      ),
    );
  }
}

// ── FRAME SELECTOR ──
class _FrameSelector extends StatelessWidget {
  final List<FrameRecommendation> frames;
  final int                       selectedIndex;
  final ValueChanged<int>         onSelect;

  const _FrameSelector({
    required this.frames,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: frames.asMap().entries.map((e) {
          final isSelected = e.key == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : Colors.white.withOpacity(0.2),
                ),
              ),
              child: Text(
                e.value.name.split(' ').first,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}