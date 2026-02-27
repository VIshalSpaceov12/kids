import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class AbcForestScreen extends StatelessWidget {
  const AbcForestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back_rounded, size: 28),
        ),
        title: Text(
          'ABC Forest \u{1F333}',
          style: GoogleFonts.balooTamma2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              '\u{1F332}\u{1F333}\u{1F334}',
              style: TextStyle(fontSize: 56),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose a game!',
              style: GoogleFonts.balooTamma2(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Learn letters with Indian mythology!',
              style: GoogleFonts.balooTamma2(
                fontSize: 16,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 40),
            // Game cards
            _GameCard(
              title: 'Learn Letters',
              subtitle: 'A to Z with mythology heroes!',
              emoji: '\u{1F524}',
              color: AppColors.abcForest,
              onTap: () => context.push('/abc-forest/learn'),
            ),
            const SizedBox(height: 20),
            _GameCard(
              title: 'Trace Letters',
              subtitle: 'Draw letters with your finger!',
              emoji: '\u{270F}\u{FE0F}',
              color: AppColors.primaryPurple,
              onTap: () => context.push('/abc-forest/tracing'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const _GameCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(77),
              blurRadius: 10,
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
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withAlpha(38),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.balooTamma2(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.balooTamma2(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: color,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
