import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/rhymes_data.dart';

class RhymePlayerScreen extends StatefulWidget {
  final int rhymeIndex;

  const RhymePlayerScreen({super.key, required this.rhymeIndex});

  @override
  State<RhymePlayerScreen> createState() => _RhymePlayerScreenState();
}

class _RhymePlayerScreenState extends State<RhymePlayerScreen>
    with SingleTickerProviderStateMixin {
  late FlutterTts _tts;
  late PageController _pageController;
  late int _currentIndex;
  bool _isSpeaking = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  static const List<Color> _colors = [
    Color(0xFFE91E63), Color(0xFF9C27B0), Color(0xFF3F51B5),
    Color(0xFF00BCD4), Color(0xFF4CAF50), Color(0xFFFF9800),
    Color(0xFFE91E63), Color(0xFF673AB7), Color(0xFF009688),
    Color(0xFFFF5722), Color(0xFF2196F3), Color(0xFF8BC34A),
    Color(0xFFF44336), Color(0xFF00ACC1), Color(0xFFFF6F00),
    Color(0xFF7B1FA2), Color(0xFF388E3C), Color(0xFFD84315),
    Color(0xFF1565C0), Color(0xFFC2185B),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.rhymeIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _tts = FlutterTts();
    _tts.setLanguage('en-US');
    _tts.setSpeechRate(0.35);
    _tts.setPitch(1.2);

    _tts.setCompletionHandler(() {
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    });

    _tts.setCancelHandler(() {
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    if (_isSpeaking) {
      await _tts.stop();
      setState(() => _isSpeaking = false);
      return;
    }
    setState(() => _isSpeaking = true);
    await _tts.speak(text);
  }

  Color _getColor(int index) => _colors[index % _colors.length];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            _tts.stop();
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded, size: 28),
        ),
        title: Text(
          RhymesData.rhymes[_currentIndex].title,
          style: GoogleFonts.balooTamma2(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: RhymesData.rhymes.length,
        onPageChanged: (index) {
          _tts.stop();
          setState(() {
            _currentIndex = index;
            _isSpeaking = false;
          });
        },
        itemBuilder: (context, index) {
          final rhyme = RhymesData.rhymes[index];
          final color = _getColor(index);
          return _RhymePage(
            rhyme: rhyme,
            color: color,
            isSpeaking: _isSpeaking && index == _currentIndex,
            pulseAnim: _pulseAnim,
            onPlay: () => _speak(rhyme.lyrics),
          );
        },
      ),
    );
  }
}

class _RhymePage extends StatelessWidget {
  final RhymeItem rhyme;
  final Color color;
  final bool isSpeaking;
  final Animation<double> pulseAnim;
  final VoidCallback onPlay;

  const _RhymePage({
    required this.rhyme,
    required this.color,
    required this.isSpeaking,
    required this.pulseAnim,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Emoji
          Text(
            rhyme.emoji,
            style: const TextStyle(fontSize: 72),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            rhyme.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.balooTamma2(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          // Play button
          GestureDetector(
            onTap: onPlay,
            child: ScaleTransition(
              scale: isSpeaking ? pulseAnim : const AlwaysStoppedAnimation(1.0),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(102),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  isSpeaking ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSpeaking ? 'Tap to stop' : 'Tap to listen \u{1F50A}',
            style: GoogleFonts.balooTamma2(
              fontSize: 15,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 20),
          // Lyrics card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withAlpha(51), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(38),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              rhyme.lyrics,
              textAlign: TextAlign.center,
              style: GoogleFonts.balooTamma2(
                fontSize: 20,
                height: 1.6,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Swipe hint
          Text(
            '\u{2B05}\u{FE0F} Swipe for more rhymes \u{27A1}\u{FE0F}',
            style: GoogleFonts.balooTamma2(
              fontSize: 15,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
