import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/providers/app_state_provider.dart';
import '../../../data/providers/progress_provider.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final progressProvider = context.watch<ProgressProvider>();
    final profile = appState.profile;

    if (profile == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'No profile found',
            style: GoogleFonts.balooTamma2(fontSize: 20),
          ),
        ),
      );
    }

    final avatar = AppConstants.getAvatar(profile.avatar);
    final classLevel = AppConstants.getClassLevel(profile.classLevel);
    final totalStars = progressProvider.getTotalStars();
    final completedLessons = progressProvider.getCompletedLessonsCount();
    final daysActive = appState.getDaysActive();

    // Module progress
    final numberLandProgress =
        progressProvider.getModuleProgressPercent('number_land', 3);
    final abcForestProgress =
        progressProvider.getModuleProgressPercent('abc_forest', 2);
    final gujaratiJungleProgress =
        progressProvider.getModuleProgressPercent('gujarati_jungle', 2);
    final mathsKingdomProgress =
        progressProvider.getModuleProgressPercent('maths_kingdom', 4);

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
          'Parent Dashboard',
          style: GoogleFonts.balooTamma2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Child info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryBlue, AppColors.primaryPurple],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withAlpha(102),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        avatar.emoji,
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
                          profile.name,
                          style: GoogleFonts.balooTamma2(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${classLevel.name} | Age: ${profile.age}',
                          style: GoogleFonts.balooTamma2(
                            fontSize: 16,
                            color: Colors.white.withAlpha(204),
                          ),
                        ),
                        Text(
                          'Buddy: ${avatar.name} ${avatar.emoji}',
                          style: GoogleFonts.balooTamma2(
                            fontSize: 14,
                            color: Colors.white.withAlpha(179),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Stats row
            Text(
              'Overview',
              style: GoogleFonts.balooTamma2(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatCard(
                  emoji: '\u{2B50}',
                  value: '$totalStars',
                  label: 'Total Stars',
                  color: AppColors.starGold,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  emoji: '\u{1F4DA}',
                  value: '$completedLessons',
                  label: 'Lessons Done',
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  emoji: '\u{1F4C5}',
                  value: '$daysActive',
                  label: 'Days Active',
                  color: AppColors.primaryBlue,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Module progress
            Text(
              'Module Progress',
              style: GoogleFonts.balooTamma2(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            _ModuleProgressCard(
              title: 'Number Land',
              emoji: '\u{1F522}',
              progress: numberLandProgress,
              color: AppColors.numberLand,
              stars: progressProvider.getModuleStars('number_land'),
            ),
            const SizedBox(height: 12),
            _ModuleProgressCard(
              title: 'ABC Forest',
              emoji: '\u{1F524}',
              progress: abcForestProgress,
              color: AppColors.abcForest,
              stars: progressProvider.getModuleStars('abc_forest'),
            ),
            const SizedBox(height: 12),
            _ModuleProgressCard(
              title: 'Gujarati Jungle',
              emoji: '\u{1F985}',
              progress: gujaratiJungleProgress,
              color: AppColors.gujaratiJungle,
              stars: progressProvider.getModuleStars('gujarati_jungle'),
            ),
            const SizedBox(height: 12),
            _ModuleProgressCard(
              title: 'Maths Kingdom',
              emoji: '\u{1F451}',
              progress: mathsKingdomProgress,
              color: AppColors.mathsKingdom,
              stars: progressProvider.getModuleStars('maths_kingdom'),
            ),
            if (profile.classLevel == 'nursery' ||
                profile.classLevel == 'kg') ...[
              const SizedBox(height: 12),
              _ModuleProgressCard(
                title: 'Animals & Birds',
                emoji: '\u{1F43E}',
                progress: progressProvider.getModuleProgressPercent(
                  'animals_birds',
                  2,
                ),
                color: AppColors.animalsBirds,
                stars: progressProvider.getModuleStars('animals_birds'),
              ),
            ],
            const SizedBox(height: 32),
            // Back button
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Back to App',
                    style: GoogleFonts.balooTamma2(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(51),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.balooTamma2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.balooTamma2(
                fontSize: 11,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleProgressCard extends StatelessWidget {
  final String title;
  final String emoji;
  final double progress;
  final Color color;
  final int stars;

  const _ModuleProgressCard({
    required this.title,
    required this.emoji,
    required this.progress,
    required this.color,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withAlpha(38),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.balooTamma2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Row(
                      children: [
                        const Text('\u{2B50}',
                            style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 2),
                        Text(
                          '$stars',
                          style: GoogleFonts.balooTamma2(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.starGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: color.withAlpha(38),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(progress * 100).toInt()}% complete',
                  style: GoogleFonts.balooTamma2(
                    fontSize: 12,
                    color: AppColors.textLight,
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
