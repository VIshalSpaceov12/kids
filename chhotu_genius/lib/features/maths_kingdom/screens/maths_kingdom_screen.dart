import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_state_provider.dart';

class MathsKingdomScreen extends StatelessWidget {
  const MathsKingdomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final classLevel = appState.profile?.classLevel ?? 'nursery';

    // Multiplication locked for Nursery/KG
    final multiplicationLocked =
        classLevel == 'nursery' || classLevel == 'kg';
    // Division locked for Nursery/KG/Class 1
    final divisionLocked = classLevel == 'nursery' ||
        classLevel == 'kg' ||
        classLevel == 'class1';

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
          'Maths Kingdom \u{1F451}',
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
              '\u{1F451}\u{2795}\u{2796}\u{2716}\u{FE0F}\u{2797}',
              style: TextStyle(fontSize: 48),
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
            const SizedBox(height: 32),
            _GameCard(
              title: 'Addition',
              subtitle: 'Learn to add numbers!',
              emoji: '\u{2795}',
              color: const Color(0xFF66BB6A),
              locked: false,
              onTap: () => context.push('/maths-kingdom/addition'),
            ),
            const SizedBox(height: 16),
            _GameCard(
              title: 'Subtraction',
              subtitle: 'Learn to subtract numbers!',
              emoji: '\u{2796}',
              color: const Color(0xFFFF7043),
              locked: false,
              onTap: () => context.push('/maths-kingdom/subtraction'),
            ),
            const SizedBox(height: 16),
            _GameCard(
              title: 'Multiplication',
              subtitle: multiplicationLocked
                  ? 'Unlocks in Class 1!'
                  : 'Learn times tables!',
              emoji: '\u{2716}\u{FE0F}',
              color: const Color(0xFF42A5F5),
              locked: multiplicationLocked,
              onTap: () {
                if (multiplicationLocked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Unlocks in Class 1! \u{1F512}',
                        style: GoogleFonts.balooTamma2(fontSize: 16),
                      ),
                      backgroundColor: AppColors.mathsKingdom,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                } else {
                  context.push('/maths-kingdom/multiplication');
                }
              },
            ),
            const SizedBox(height: 16),
            _GameCard(
              title: 'Division',
              subtitle:
                  divisionLocked ? 'Unlocks in Class 2!' : 'Learn to divide!',
              emoji: '\u{2797}',
              color: const Color(0xFFAB47BC),
              locked: divisionLocked,
              onTap: () {
                if (divisionLocked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Unlocks in Class 2! \u{1F512}',
                        style: GoogleFonts.balooTamma2(fontSize: 16),
                      ),
                      backgroundColor: AppColors.mathsKingdom,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                } else {
                  context.push('/maths-kingdom/division');
                }
              },
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
  final bool locked;
  final VoidCallback onTap;

  const _GameCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.locked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: locked ? 0.5 : 1.0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(locked ? 26 : 77),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: color.withAlpha(locked ? 26 : 77),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withAlpha(38),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 32),
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
                        fontSize: 20,
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
              locked
                  ? Icon(
                      Icons.lock_rounded,
                      color: Colors.grey.shade400,
                      size: 24,
                    )
                  : Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: color,
                      size: 24,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
