import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/rhymes_data.dart';
import 'rhyme_player_screen.dart';

class RhymesScreen extends StatelessWidget {
  const RhymesScreen({super.key});

  static const List<Color> _cardColors = [
    Color(0xFFE91E63), Color(0xFF9C27B0), Color(0xFF3F51B5),
    Color(0xFF00BCD4), Color(0xFF4CAF50), Color(0xFFFF9800),
    Color(0xFFE91E63), Color(0xFF673AB7), Color(0xFF009688),
    Color(0xFFFF5722), Color(0xFF2196F3), Color(0xFF8BC34A),
    Color(0xFFF44336), Color(0xFF00ACC1), Color(0xFFFF6F00),
    Color(0xFF7B1FA2), Color(0xFF388E3C), Color(0xFFD84315),
    Color(0xFF1565C0), Color(0xFFC2185B),
  ];

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
          'Rhymes \u{1F3B5}',
          style: GoogleFonts.balooTamma2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            '\u{1F3A4}\u{1F3B6}\u{1F3B5}',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 8),
          Text(
            'Sing along!',
            style: GoogleFonts.balooTamma2(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(
            'Tap a rhyme to listen & read',
            style: GoogleFonts.balooTamma2(
              fontSize: 16,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: RhymesData.rhymes.length,
              itemBuilder: (context, index) {
                final rhyme = RhymesData.rhymes[index];
                final color = _cardColors[index % _cardColors.length];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RhymeCard(
                    rhyme: rhyme,
                    color: color,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RhymePlayerScreen(
                            rhymeIndex: index,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RhymeCard extends StatelessWidget {
  final RhymeItem rhyme;
  final Color color;
  final VoidCallback onTap;

  const _RhymeCard({
    required this.rhyme,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(77),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: color.withAlpha(77),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withAlpha(38),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  rhyme.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rhyme.title,
                    style: GoogleFonts.balooTamma2(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.volume_up_rounded,
                        size: 16,
                        color: color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Tap to listen',
                        style: GoogleFonts.balooTamma2(
                          fontSize: 13,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.play_circle_fill_rounded,
              color: color,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
