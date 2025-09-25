import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef YLabelFormatter = String Function(double v);

/// Grafik garis sederhana (sparkline) tanpa package.
/// - Ada grid halus
/// - Ada sumbu-Y (min, mid, max)
/// - Line + area gradient
class CustomGraph extends StatelessWidget {
  final List<double> values;
  final double height;

  /// Tampilkan sumbu Y (label min, mid, max)
  final bool showYAxis;

  /// Jumlah tick sumbu Y (default 3 = min, mid, max)
  final int yTicks;

  /// Formatter label Y, contoh: (v) => 'Rp ${v.toStringAsFixed(0)}'
  final YLabelFormatter? yLabelFormatter;

  /// Warna utama garis
  final Color lineColor;

  /// Warna awal–akhir untuk area gradient
  final List<Color> gradientArea;

  const CustomGraph({
    super.key,
    required this.values,
    this.height = 200,
    this.showYAxis = true,
    this.yTicks = 3,
    this.yLabelFormatter,
    this.lineColor = const Color(0xFF4E73DF),
    this.gradientArea = const [
      Color(0xFF4E73DF),
      Color(0xFF7F9BFF),
    ],
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Belum ada data.',
          style: GoogleFonts.poppins(color: const Color(0xFF7A7A7A)),
        ),
      );
    }

    // lebar untuk label sumbu-Y
    final yLabelWidth = showYAxis ? 56.0 : 0.0;

    return SizedBox(
      height: height,
      child: Row(
        children: [
          if (showYAxis)
            SizedBox(
              width: yLabelWidth,
              child: _YAxis(
                values: values,
                ticks: yTicks,
                formatter: yLabelFormatter,
              ),
            ),
          Expanded(
            child: CustomPaint(
              painter: _SparklinePainter(values, lineColor, gradientArea),
              foregroundPainter: _GridlinePainter(values),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _YAxis extends StatelessWidget {
  final List<double> values;
  final int ticks;
  final YLabelFormatter? formatter;

  const _YAxis({
    required this.values,
    required this.ticks,
    this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final labels = <String>[];

    if (ticks <= 1) {
      labels.add(_fmt(minV));
    } else {
      for (int i = 0; i < ticks; i++) {
        final t = i / (ticks - 1); // 0..1
        final val = maxV - t * (maxV - minV); // dari atas ke bawah
        labels.add(_fmt(val));
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: labels
          .map(
            (text) => Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: const Color(0xFF9E9E9E),
              ),
            ),
          )
          .toList(),
    );
  }

  String _fmt(double v) {
    if (formatter != null) return formatter!(v);
    return v.toStringAsFixed(0);
  }
}

class _GridlinePainter extends CustomPainter {
  final List<double> values;
  _GridlinePainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final ticks = 3;

    final gridPaint = Paint()
      ..color = const Color(0xFF9E9E9E).withOpacity(0.15)
      ..strokeWidth = 1;

    for (int i = 0; i < ticks; i++) {
      final t = i / (ticks - 1);
      final val = maxV - t * (maxV - minV);
      final norm = (val - minV) / ((maxV - minV) == 0 ? 1.0 : (maxV - minV));
      final y = size.height - (norm * size.height);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridlinePainter oldDelegate) => false;
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;
  final List<Color> gradientArea;

  _SparklinePainter(this.values, this.lineColor, this.gradientArea);

  @override
  void paint(Canvas canvas, Size size) {
    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV) == 0 ? 1.0 : (maxV - minV);
    final dx = values.length == 1 ? 0.0 : size.width / (values.length - 1);

    final line = Paint()
      ..color = lineColor
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          gradientArea.first.withOpacity(0.25),
          gradientArea.last.withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final pathFill = Path();

    for (int i = 0; i < values.length; i++) {
      final x = values.length == 1 ? size.width / 2 : i * dx;
      final norm = (values[i] - minV) / range;
      final y = size.height - (norm * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        pathFill.moveTo(x, size.height);
        pathFill.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        pathFill.lineTo(x, y);
      }
    }

    pathFill.lineTo(values.length == 1 ? size.width / 2 : size.width, size.height);
    pathFill.close();

    canvas.drawPath(pathFill, areaPaint);
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.gradientArea != gradientArea;
  }
}
