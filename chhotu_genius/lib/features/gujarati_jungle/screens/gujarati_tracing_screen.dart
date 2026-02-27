import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/progress_provider.dart';
import '../data/gujarati_data.dart';

class GujaratiTracingScreen extends StatefulWidget {
  const GujaratiTracingScreen({super.key});

  @override
  State<GujaratiTracingScreen> createState() => _GujaratiTracingScreenState();
}

class _GujaratiTracingScreenState extends State<GujaratiTracingScreen> {
  int _currentLetterIndex = 0;
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];

  final List<GujaratiLetter> _letters = GujaratiData.allLetters;

  static const List<Color> _strokeColors = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFF45B7D1),
    Color(0xFFF9CA24),
    Color(0xFF6C5CE7),
    Color(0xFFFF9FF3),
    Color(0xFF00D2D3),
    Color(0xFFFFA502),
  ];

  GujaratiLetter get _currentItem => _letters[_currentLetterIndex];

  void _clear() {
    setState(() {
      _strokes.clear();
      _currentStroke = [];
    });
  }

  void _nextLetter() {
    context
        .read<ProgressProvider>()
        .recordProgress('gujarati_jungle', 'trace_${_currentItem.transliteration}', 1);

    setState(() {
      if (_currentLetterIndex < _letters.length - 1) {
        _currentLetterIndex++;
      } else {
        _currentLetterIndex = 0;
      }
      _strokes.clear();
      _currentStroke = [];
    });
  }

  void _prevLetter() {
    setState(() {
      if (_currentLetterIndex > 0) {
        _currentLetterIndex--;
      } else {
        _currentLetterIndex = _letters.length - 1;
      }
      _strokes.clear();
      _currentStroke = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, size: 28),
        ),
        title: Text(
          'Trace Kakko \u{270F}\u{FE0F}',
          style: GoogleFonts.balooTamma2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Letter indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _prevLetter,
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 28,
                    color: AppColors.gujaratiJungle,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gujaratiJungle.withAlpha(38),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${_currentItem.letter}  ${_currentItem.transliteration}',
                    style: GoogleFonts.balooTamma2(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gujaratiJungle,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _nextLetter,
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 28,
                    color: AppColors.gujaratiJungle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Trace the letter with your finger!',
              style: GoogleFonts.balooTamma2(
                fontSize: 16,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 12),
            // Drawing canvas
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.gujaratiJungle.withAlpha(51),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      // Watermark letter
                      Center(
                        child: Text(
                          _currentItem.letter,
                          style: TextStyle(
                            fontSize: 280,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.withAlpha(38),
                          ),
                        ),
                      ),
                      // Drawing area
                      GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            _currentStroke = [details.localPosition];
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            _currentStroke.add(details.localPosition);
                          });
                        },
                        onPanEnd: (details) {
                          setState(() {
                            _strokes.add(List.from(_currentStroke));
                            _currentStroke = [];
                          });
                        },
                        child: CustomPaint(
                          painter: _TracingPainter(
                            strokes: _strokes,
                            currentStroke: _currentStroke,
                            colors: _strokeColors,
                          ),
                          size: Size.infinite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _clear,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.wrongRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      'Clear',
                      style: GoogleFonts.balooTamma2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _nextLetter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.correctGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                      'Next Letter',
                      style: GoogleFonts.balooTamma2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _TracingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final List<Color> colors;

  _TracingPainter({
    required this.strokes,
    required this.currentStroke,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int s = 0; s < strokes.length; s++) {
      _drawStroke(canvas, strokes[s], colors[s % colors.length]);
    }
    if (currentStroke.isNotEmpty) {
      _drawStroke(
        canvas,
        currentStroke,
        colors[strokes.length % colors.length],
      );
    }
  }

  void _drawStroke(Canvas canvas, List<Offset> points, Color color) {
    if (points.length < 2) {
      if (points.length == 1) {
        final paint = Paint()
          ..color = color
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round;
        canvas.drawCircle(points[0], 4, paint);
      }
      return;
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = color.withAlpha(77)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      final midY = (p0.dy + p1.dy) / 2;
      path.quadraticBezierTo(p0.dx, p0.dy, midX, midY);
    }

    if (points.length > 1) {
      path.lineTo(points.last.dx, points.last.dy);
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);

    if (points.length > 2) {
      final lastPoint = points.last;
      final sparklePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(lastPoint, 3, sparklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TracingPainter oldDelegate) {
    return true;
  }
}
