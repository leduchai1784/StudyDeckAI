import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class AvatarEditorDialog extends StatefulWidget {
  final Uint8List imageBytes;
  final Future<bool> Function(Uint8List croppedBytes) onConfirm;

  const AvatarEditorDialog({
    super.key,
    required this.imageBytes,
    required this.onConfirm,
  });

  static Future<bool?> show(
    BuildContext context, {
    required Uint8List imageBytes,
    required Future<bool> Function(Uint8List croppedBytes) onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AvatarEditorDialog(
        imageBytes: imageBytes,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<AvatarEditorDialog> createState() => _AvatarEditorDialogState();
}

class _AvatarEditorDialogState extends State<AvatarEditorDialog> {
  ui.Image? _decodedImage;
  double _naturalWidth = 1.0;
  double _naturalHeight = 1.0;
  bool _isLoadingImage = true;

  // Transformations
  double _scale = 1.0;
  double _baseScale = 1.0;
  Offset _offset = Offset.zero;
  Offset _baseOffset = Offset.zero;
  Offset _focalPoint = Offset.zero;
  int _rotation = 0; // 0, 90, 180, 270 degrees
  bool _flipX = false;

  bool _isSubmitting = false;

  // Viewport and Crop Circle diameter
  static const double _cropSize = 250.0;

  @override
  void initState() {
    super.initState();
    _decodeImage();
  }

  Future<void> _decodeImage() async {
    try {
      final codec = await ui.instantiateImageCodec(widget.imageBytes);
      final frame = await codec.getNextFrame();
      if (mounted) {
        setState(() {
          _decodedImage = frame.image;
          _naturalWidth = frame.image.width.toDouble();
          _naturalHeight = frame.image.height.toDouble();
          _isLoadingImage = false;
          _scale = _minScale;
          _offset = Offset.zero;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingImage = false);
        Navigator.of(context).pop(false);
      }
    }
  }

  double get _baseWidth {
    if (_naturalHeight == 0) return _cropSize;
    final aspect = _naturalWidth / _naturalHeight;
    if (aspect >= 1.0) {
      return _cropSize * aspect;
    } else {
      return _cropSize;
    }
  }

  double get _baseHeight {
    if (_naturalWidth == 0) return _cropSize;
    final aspect = _naturalWidth / _naturalHeight;
    if (aspect >= 1.0) {
      return _cropSize;
    } else {
      return _cropSize / aspect;
    }
  }

  /// Minimum scale ensures that the photo is AT LEAST as large as the crop circle.
  /// The crop circle will never exceed the photo bounds or show empty borders.
  double get _minScale {
    final bool isRotated = _rotation == 90 || _rotation == 270;
    final double visibleW = isRotated ? _baseHeight : _baseWidth;
    final double visibleH = isRotated ? _baseWidth : _baseHeight;
    if (visibleW == 0 || visibleH == 0) return 1.0;
    final double scaleX = _cropSize / visibleW;
    final double scaleY = _cropSize / visibleH;
    return math.max(scaleX, scaleY);
  }

  /// Clamps the pan offset so that the photo edges never pull away inside the crop circle.
  Offset _clampOffset(Offset offset, double scale) {
    final bool isRotated = _rotation == 90 || _rotation == 270;
    final double visibleW = (isRotated ? _baseHeight : _baseWidth) * scale;
    final double visibleH = (isRotated ? _baseWidth : _baseHeight) * scale;

    final double maxPanX = math.max(0.0, (visibleW - _cropSize) / 2);
    final double maxPanY = math.max(0.0, (visibleH - _cropSize) / 2);

    return Offset(
      offset.dx.clamp(-maxPanX, maxPanX),
      offset.dy.clamp(-maxPanY, maxPanY),
    );
  }

  void _zoomIn() {
    setState(() {
      _scale = (_scale * 1.15).clamp(_minScale, _minScale * 3.5);
      _offset = _clampOffset(_offset, _scale);
    });
  }

  void _zoomOut() {
    setState(() {
      _scale = (_scale / 1.15).clamp(_minScale, _minScale * 3.5);
      _offset = _clampOffset(_offset, _scale);
    });
  }

  void _rotateLeft() {
    setState(() {
      _rotation = (_rotation - 90) % 360;
      if (_scale < _minScale) _scale = _minScale;
      _offset = _clampOffset(_offset, _scale);
    });
  }

  void _rotateRight() {
    setState(() {
      _rotation = (_rotation + 90) % 360;
      if (_scale < _minScale) _scale = _minScale;
      _offset = _clampOffset(_offset, _scale);
    });
  }

  void _flipHorizontal() {
    setState(() {
      _flipX = !_flipX;
    });
  }

  void _reset() {
    setState(() {
      _rotation = 0;
      _flipX = false;
      _scale = _minScale;
      _offset = Offset.zero;
    });
  }

  Future<Uint8List?> _exportCroppedImage({int targetSize = 512}) async {
    if (_decodedImage == null) return null;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, targetSize.toDouble(), targetSize.toDouble()),
    );

    final double exportScale = targetSize / _cropSize;

    // Solid white background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, targetSize.toDouble(), targetSize.toDouble()),
      Paint()..color = Colors.white,
    );

    canvas.save();
    // 1. Translate to center of target
    canvas.translate(targetSize / 2, targetSize / 2);
    // 2. Translate by user pan (scaled)
    canvas.translate(_offset.dx * exportScale, _offset.dy * exportScale);
    // 3. Rotate
    canvas.rotate(_rotation * math.pi / 180.0);
    // 4. Scale & Flip
    final double finalScale = _scale * exportScale;
    canvas.scale(_flipX ? -finalScale : finalScale, finalScale);

    // 5. Draw image centered
    final srcRect = Rect.fromLTWH(0, 0, _naturalWidth, _naturalHeight);
    final dstRect = Rect.fromCenter(
      center: Offset.zero,
      width: _baseWidth,
      height: _baseHeight,
    );

    canvas.drawImageRect(
      _decodedImage!,
      srcRect,
      dstRect,
      Paint()..filterQuality = FilterQuality.high,
    );
    canvas.restore();

    final picture = recorder.endRecording();
    final img = await picture.toImage(targetSize, targetSize);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<void> _handleConfirm() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      final croppedBytes = await _exportCroppedImage(targetSize: 512);
      if (croppedBytes == null) {
        setState(() => _isSubmitting = false);
        return;
      }

      final success = await widget.onConfirm(croppedBytes);
      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop(true);
      } else {
        setState(() => _isSubmitting = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi xử lý ảnh: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 22,
              color: const Color(0xFF334155),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.brandSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chỉnh Sửa Ảnh Đại Diện',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandTextPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: _reset,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Đặt lại',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.brandPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kéo để căn chỉnh, thu phóng hoặc xoay ảnh phù hợp.',
                  style: TextStyle(fontSize: 12.5, color: AppTheme.brandTextSecondary),
                ),
              ),
              const SizedBox(height: 16),

              // Interactive Image Viewport with Circular Mask bounded to image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: _cropSize,
                  height: _cropSize,
                  color: const Color(0xFF0F172A),
                  child: _isLoadingImage
                      ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
                      : GestureDetector(
                          onScaleStart: (details) {
                            _baseScale = _scale;
                            _baseOffset = _offset;
                            _focalPoint = details.localFocalPoint;
                          },
                          onScaleUpdate: (details) {
                            setState(() {
                              _scale = (_baseScale * details.scale).clamp(_minScale, _minScale * 3.5);
                              _offset = _clampOffset(_baseOffset + (details.localFocalPoint - _focalPoint), _scale);
                            });
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // 1. Transformed Image Canvas
                              CustomPaint(
                                painter: _ImageCanvasPainter(
                                  image: _decodedImage,
                                  naturalWidth: _naturalWidth,
                                  naturalHeight: _naturalHeight,
                                  baseWidth: _baseWidth,
                                  baseHeight: _baseHeight,
                                  offset: _offset,
                                  scale: _scale,
                                  rotation: _rotation,
                                  flipX: _flipX,
                                ),
                              ),

                              // 2. Circular Vignette & Grid Overlay
                              IgnorePointer(
                                child: CustomPaint(
                                  painter: _AvatarCropOverlayPainter(cropSize: _cropSize),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 18),

              // 5 Toolbar Buttons Row (Zoom In, Zoom Out, Rotate Left, Rotate Right, Flip)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildToolbarButton(
                    icon: Icons.zoom_in,
                    tooltip: 'Phóng to (+)',
                    onTap: _zoomIn,
                  ),
                  const SizedBox(width: 8),
                  _buildToolbarButton(
                    icon: Icons.zoom_out,
                    tooltip: 'Thu nhỏ (-)',
                    onTap: _zoomOut,
                  ),
                  const SizedBox(width: 8),
                  _buildToolbarButton(
                    icon: Icons.rotate_left,
                    tooltip: 'Xoay trái 90°',
                    onTap: _rotateLeft,
                  ),
                  const SizedBox(width: 8),
                  _buildToolbarButton(
                    icon: Icons.rotate_right,
                    tooltip: 'Xoay phải 90°',
                    onTap: _rotateRight,
                  ),
                  const SizedBox(width: 8),
                  _buildToolbarButton(
                    icon: Icons.sync_rounded,
                    tooltip: 'Lật ngang (Flip)',
                    onTap: _flipHorizontal,
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Action Buttons: Hủy & Xác nhận
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: const BorderSide(color: AppTheme.brandBorder),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brandPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_rounded, size: 18, color: Colors.white),
                                SizedBox(width: 6),
                                Text(
                                  'Xác Nhận & Đổi',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageCanvasPainter extends CustomPainter {
  final ui.Image? image;
  final double naturalWidth;
  final double naturalHeight;
  final double baseWidth;
  final double baseHeight;
  final Offset offset;
  final double scale;
  final int rotation;
  final bool flipX;

  _ImageCanvasPainter({
    required this.image,
    required this.naturalWidth,
    required this.naturalHeight,
    required this.baseWidth,
    required this.baseHeight,
    required this.offset,
    required this.scale,
    required this.rotation,
    required this.flipX,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null) return;

    canvas.save();
    // Center of viewport
    canvas.translate(size.width / 2, size.height / 2);
    // Pan offset
    canvas.translate(offset.dx, offset.dy);
    // Rotate
    canvas.rotate(rotation * math.pi / 180.0);
    // Scale & Flip
    canvas.scale(flipX ? -scale : scale, scale);

    final srcRect = Rect.fromLTWH(0, 0, naturalWidth, naturalHeight);
    final dstRect = Rect.fromCenter(
      center: Offset.zero,
      width: baseWidth,
      height: baseHeight,
    );

    canvas.drawImageRect(
      image!,
      srcRect,
      dstRect,
      Paint()..filterQuality = FilterQuality.medium,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ImageCanvasPainter old) {
    return old.offset != offset ||
        old.scale != scale ||
        old.rotation != rotation ||
        old.flipX != flipX ||
        old.image != image;
  }
}

class _AvatarCropOverlayPainter extends CustomPainter {
  final double cropSize;

  _AvatarCropOverlayPainter({required this.cropSize});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = cropSize / 2;

    // 1. Semi-transparent dark vignette outside circle
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final circlePath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    final dimPath = Path.combine(PathOperation.difference, backgroundPath, circlePath);

    canvas.drawPath(
      dimPath,
      Paint()..color = Colors.black.withValues(alpha: 0.55),
    );

    // 2. White circle boundary
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // 3. Subtle grid lines inside circle (rule of thirds)
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.save();
    canvas.clipPath(circlePath);

    final leftX = center.dx - radius + (radius * 2 / 3);
    final rightX = center.dx - radius + (radius * 4 / 3);
    final topY = center.dy - radius + (radius * 2 / 3);
    final bottomY = center.dy - radius + (radius * 4 / 3);

    canvas.drawLine(Offset(leftX, 0), Offset(leftX, size.height), gridPaint);
    canvas.drawLine(Offset(rightX, 0), Offset(rightX, size.height), gridPaint);
    canvas.drawLine(Offset(0, topY), Offset(size.width, topY), gridPaint);
    canvas.drawLine(Offset(0, bottomY), Offset(size.width, bottomY), gridPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AvatarCropOverlayPainter oldDelegate) {
    return oldDelegate.cropSize != cropSize;
  }
}
