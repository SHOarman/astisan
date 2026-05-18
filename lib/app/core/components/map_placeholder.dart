import 'package:flutter/material.dart';
import '../constants/static/app_colors.dart';

class MapPlaceholder extends StatelessWidget {
  final Widget? child;

  const MapPlaceholder({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // High-fidelity custom painted vector map background
          const Positioned.fill(
            child: CustomPaint(
              painter: MapBackgroundPainter(),
            ),
          ),
          if (child != null) Positioned.fill(child: child!),
        ],
      ),
    );
  }
}

class MapBackgroundPainter extends CustomPainter {
  const MapBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // 1. Draw Land Base (Google Maps warm light grey/cream style)
    final Paint landPaint = Paint()
      ..color = const Color(0xFFF4F3F0)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), landPaint);

    // 2. Draw Green Parks / Woodlands (Soft light green)
    final Paint parkPaint = Paint()
      ..color = const Color(0xFFE1F5E3)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.08, h * 0.12, w * 0.32, h * 0.12), const Radius.circular(20)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.65, h * 0.42, w * 0.28, h * 0.18), const Radius.circular(24)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.15, h * 0.72, w * 0.38, h * 0.11), const Radius.circular(16)), parkPaint);

    // 3. Draw Water Bodies / Curved River (Sleek light blue)
    final Paint waterPaint = Paint()
      ..color = const Color(0xFFC5E3FC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24.0
      ..strokeCap = StrokeCap.round;

    final Path riverPath = Path();
    riverPath.moveTo(-20, h * 0.3);
    riverPath.cubicTo(w * 0.3, h * 0.22, w * 0.4, h * 0.58, w + 20, h * 0.62);
    canvas.drawPath(riverPath, waterPaint);

    // 4. Draw Building Blocks (Subtle warm grey squares/rectangles)
    final Paint buildingPaint = Paint()
      ..color = const Color(0xFFEBE9E4)
      ..style = PaintingStyle.fill;

    final List<Rect> buildingList = [
      Rect.fromLTWH(w * 0.08, h * 0.4, 24, 18),
      Rect.fromLTWH(w * 0.16, h * 0.42, 20, 20),
      Rect.fromLTWH(w * 0.24, h * 0.39, 32, 16),
      
      Rect.fromLTWH(w * 0.5, h * 0.15, 20, 24),
      Rect.fromLTWH(w * 0.58, h * 0.12, 28, 20),
      
      Rect.fromLTWH(w * 0.55, h * 0.72, 24, 24),
      Rect.fromLTWH(w * 0.65, h * 0.75, 36, 18),
      Rect.fromLTWH(w * 0.78, h * 0.72, 22, 22),
    ];
    for (var rect in buildingList) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), buildingPaint);
    }

    // 5. Draw Local Streets / Road Grid Network (Crisp white lines)
    final Paint streetPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    final Path streets = Path();
    // Grid horizontal lines
    streets.moveTo(0, h * 0.1); streets.lineTo(w, h * 0.1);
    streets.moveTo(0, h * 0.38); streets.lineTo(w, h * 0.38);
    streets.moveTo(0, h * 0.55); streets.lineTo(w, h * 0.55);
    streets.moveTo(0, h * 0.82); streets.lineTo(w, h * 0.82);

    // Grid vertical lines
    streets.moveTo(w * 0.15, 0); streets.lineTo(w * 0.15, h);
    streets.moveTo(w * 0.45, 0); streets.lineTo(w * 0.45, h);
    streets.moveTo(w * 0.78, 0); streets.lineTo(w * 0.78, h);

    // Diagonal street
    streets.moveTo(0, h * 0.9); streets.lineTo(w, h * 0.4);

    canvas.drawPath(streets, streetPaint);

    // 6. Draw Primary Highway (Bold golden-yellow highway crossing the city)
    final Paint highwayBorderPaint = Paint()
      ..color = const Color(0xFFEAD8A8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round;

    final Paint highwayPaint = Paint()
      ..color = const Color(0xFFFFEB9C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    final Path highwayPath = Path();
    highwayPath.moveTo(w * 0.05, 0);
    highwayPath.cubicTo(w * 0.2, h * 0.4, w * 0.8, h * 0.5, w * 0.95, h);

    canvas.drawPath(highwayPath, highwayBorderPaint);
    canvas.drawPath(highwayPath, highwayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
