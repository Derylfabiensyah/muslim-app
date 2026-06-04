import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/kiblat_viewmodel.dart';

class KiblatPage extends StatefulWidget {
  const KiblatPage({super.key});

  @override
  State<KiblatPage> createState() => _KiblatPageState();
}

class _KiblatPageState extends State<KiblatPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<KiblatViewModel>().initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<KiblatViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: vm.isLoading
                ? _buildLoading()
                : vm.error != null
                    ? _buildError(vm)
                    : _buildCompass(vm),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF546B41), Color(0xFF3D5230)],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: const Column(
        children: [
          Text(
            'Arah Kiblat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Arahkan ponsel Anda ke arah Kiblat',
            style: TextStyle(
              color: Color(0xFF99AD7A),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF546B41),
          ),
          SizedBox(height: 20),
          Text(
            'Mencari lokasi Anda...',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF546B41),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pastikan GPS aktif',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(KiblatViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off,
                size: 48,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              vm.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF333333),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => vm.initialize(),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'Coba Lagi',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF546B41),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompass(KiblatViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Info cards
          _buildInfoCards(vm),
          const SizedBox(height: 32),
          // Compass
          _buildCompassWidget(vm),
          const SizedBox(height: 24),
          // Instruction
          _buildInstruction(vm),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildInfoCards(KiblatViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: _infoCard(
            icon: Icons.my_location,
            label: 'Lokasi Anda',
            value:
                '${vm.latitude?.toStringAsFixed(4) ?? '-'}, ${vm.longitude?.toStringAsFixed(4) ?? '-'}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _infoCard(
            icon: Icons.mosque,
            label: 'Jarak ke Ka\'bah',
            value: '${vm.distanceToKaaba.toStringAsFixed(0)} km',
          ),
        ),
      ],
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF546B41).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF546B41), size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompassWidget(KiblatViewModel vm) {
    return SizedBox(
      width: 300,
      height: 300,
      child: CustomPaint(
        painter: _CompassPainter(
          heading: vm.heading ?? 0,
          qiblaDirection: vm.qiblaDirection ?? 0,
        ),
        child: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color:
                      const Color(0xFF546B41).withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${vm.qiblaDirection?.toStringAsFixed(1) ?? '0'}°',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF546B41),
                  ),
                ),
                const Text(
                  'Kiblat',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction(KiblatViewModel vm) {
    // Tentukan apakah sudah mengarah ke kiblat (toleransi ±5 derajat)
    double diff = 0;
    if (vm.heading != null && vm.qiblaDirection != null) {
      diff = ((vm.qiblaDirection! - vm.heading!) % 360 + 360) % 360;
      if (diff > 180) diff = 360 - diff;
    }
    final bool isAligned = diff < 5 && vm.heading != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isAligned ? const Color(0xFF546B41) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isAligned
                ? const Color(0xFF546B41).withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isAligned
                  ? Colors.white.withValues(alpha: 0.2)
                  : const Color(0xFF546B41).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isAligned ? Icons.check_circle : Icons.explore,
              color: isAligned ? Colors.white : const Color(0xFF546B41),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAligned
                      ? 'Anda Menghadap Kiblat! ✓'
                      : 'Putar Ponsel Anda',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isAligned ? Colors.white : const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAligned
                      ? 'Arah ponsel sudah tepat ke arah Ka\'bah'
                      : 'Arahkan ponsel hingga jarum hijau menunjuk ke atas',
                  style: TextStyle(
                    fontSize: 13,
                    color: isAligned
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Painter untuk kompas dengan arah kiblat
class _CompassPainter extends CustomPainter {
  final double heading;
  final double qiblaDirection;

  _CompassPainter({
    required this.heading,
    required this.qiblaDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    canvas.save();
    // Rotasi seluruh kompas berdasarkan heading device
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-heading * pi / 180);

    // ===== Background Circle =====
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, radius, bgPaint);

    // Outer border
    final borderPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset.zero, radius, borderPaint);

    // ===== Tick marks =====
    for (int i = 0; i < 360; i += 5) {
      final angle = i * pi / 180;
      final isCardinal = i % 90 == 0;
      final isMajor = i % 30 == 0;

      double innerLen;
      double strokeW;
      Color color;

      if (isCardinal) {
        innerLen = 20;
        strokeW = 3;
        color = const Color(0xFF333333);
      } else if (isMajor) {
        innerLen = 14;
        strokeW = 2;
        color = const Color(0xFF999999);
      } else {
        innerLen = 8;
        strokeW = 1;
        color = const Color(0xFFCCCCCC);
      }

      final outer = Offset(
        (radius - 6) * cos(angle - pi / 2),
        (radius - 6) * sin(angle - pi / 2),
      );
      final inner = Offset(
        (radius - 6 - innerLen) * cos(angle - pi / 2),
        (radius - 6 - innerLen) * sin(angle - pi / 2),
      );

      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..color = color
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.round,
      );
    }

    // ===== Cardinal labels =====
    final cardinals = ['U', 'T', 'S', 'B'];
    for (int i = 0; i < 4; i++) {
      final angle = i * 90 * pi / 180;
      final textOffset = Offset(
        (radius - 38) * cos(angle - pi / 2),
        (radius - 38) * sin(angle - pi / 2),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: cardinals[i],
          style: TextStyle(
            color: i == 0 ? const Color(0xFFD32F2F) : const Color(0xFF333333),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      canvas.save();
      canvas.translate(textOffset.dx, textOffset.dy);
      canvas.rotate(heading * pi / 180); // Counter-rotate text
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }

    // ===== North indicator (red triangle) =====
    const northAngle = -pi / 2; // North is at top
    final northTip = Offset(
      (radius - 2) * cos(northAngle),
      (radius - 2) * sin(northAngle),
    );
    final northPath = Path()
      ..moveTo(northTip.dx, northTip.dy)
      ..lineTo(northTip.dx - 6, northTip.dy + 14)
      ..lineTo(northTip.dx + 6, northTip.dy + 14)
      ..close();
    canvas.drawPath(
      northPath,
      Paint()
        ..color = const Color(0xFFD32F2F)
        ..style = PaintingStyle.fill,
    );

    // ===== Qibla arrow =====
    final qiblaAngle = qiblaDirection * pi / 180 - pi / 2;

    // Arrow body
    final arrowLength = radius - 50;
    final arrowEnd = Offset(
      arrowLength * cos(qiblaAngle),
      arrowLength * sin(qiblaAngle),
    );

    // Draw arrow line
    final arrowPaint = Paint()
      ..color = const Color(0xFF546B41)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, arrowEnd, arrowPaint);

    // Arrow head
    const headLength = 16.0;
    const headAngle = 0.4;
    final arrowHead = Path()
      ..moveTo(arrowEnd.dx, arrowEnd.dy)
      ..lineTo(
        arrowEnd.dx - headLength * cos(qiblaAngle - headAngle),
        arrowEnd.dy - headLength * sin(qiblaAngle - headAngle),
      )
      ..lineTo(
        arrowEnd.dx - headLength * cos(qiblaAngle + headAngle),
        arrowEnd.dy - headLength * sin(qiblaAngle + headAngle),
      )
      ..close();
    canvas.drawPath(
      arrowHead,
      Paint()
        ..color = const Color(0xFF546B41)
        ..style = PaintingStyle.fill,
    );

    // Ka'bah icon at arrow tip
    final kaabaCenter = Offset(
      (arrowLength + 4) * cos(qiblaAngle),
      (arrowLength + 4) * sin(qiblaAngle),
    );
    canvas.save();
    canvas.translate(kaabaCenter.dx, kaabaCenter.dy);
    canvas.rotate(heading * pi / 180); // Counter-rotate
    // Ka'bah dot
    canvas.drawCircle(
      Offset.zero,
      10,
      Paint()
        ..color = const Color(0xFF546B41)
        ..style = PaintingStyle.fill,
    );
    // Small square inside
    canvas.drawRect(
      const Rect.fromLTWH(-4, -4, 8, 8),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    canvas.restore();

    // Opposite end (small tail)
    final tailEnd = Offset(
      -30 * cos(qiblaAngle),
      -30 * sin(qiblaAngle),
    );
    canvas.drawLine(
      Offset.zero,
      tailEnd,
      Paint()
        ..color = const Color(0xFF546B41).withValues(alpha: 0.3)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // Center dot
    canvas.drawCircle(
      Offset.zero,
      6,
      Paint()
        ..color = const Color(0xFF546B41)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset.zero,
      3,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CompassPainter oldDelegate) {
    return oldDelegate.heading != heading ||
        oldDelegate.qiblaDirection != qiblaDirection;
  }
}
