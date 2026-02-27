import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/providers/app_state_provider.dart';
import '../../../data/providers/progress_provider.dart';
import '../widgets/land_card.dart';

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final progressProvider = context.watch<ProgressProvider>();
    final profile = appState.profile;

    if (profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final avatar = AppConstants.getAvatar(profile.avatar);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  // Avatar circle
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withAlpha(51),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryBlue,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        avatar.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Greeting
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, ${profile.name}!',
                          style: GoogleFonts.balooTamma2(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              '\u{2B50}',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${progressProvider.getTotalStars()} stars',
                              style: GoogleFonts.balooTamma2(
                                fontSize: 14,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Parent lock button
                  GestureDetector(
                    onTap: () => context.push('/parent'),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(26),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '\u{1F512}',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              'Explore the World! \u{1F30D}',
              style: GoogleFonts.balooTamma2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            // Land cards
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    LandCard(
                      title: 'Number Land',
                      subtitle: 'Count, learn & play with numbers!',
                      emoji: '\u{1F522}',
                      gradientColors: const [
                        AppColors.numberLand,
                        Color(0xFFFF8A80),
                      ],
                      progress: progressProvider.getModuleProgressPercent(
                        'number_land',
                        3,
                      ),
                      onTap: () => context.push('/number-land'),
                    ),
                    const SizedBox(height: 16),
                    LandCard(
                      title: 'ABC Forest',
                      subtitle: 'Learn letters with Indian heroes!',
                      emoji: '\u{1F524}',
                      gradientColors: const [
                        AppColors.abcForest,
                        Color(0xFF81C784),
                      ],
                      progress: progressProvider.getModuleProgressPercent(
                        'abc_forest',
                        2,
                      ),
                      onTap: () => context.push('/abc-forest'),
                    ),
                    const SizedBox(height: 16),
                    LandCard(
                      title: 'Gujarati Jungle',
                      subtitle: 'Learn Gujarati letters!',
                      emoji: '\u{1F985}',
                      gradientColors: const [
                        AppColors.gujaratiJungle,
                        Color(0xFFFFB74D),
                      ],
                      progress: progressProvider.getModuleProgressPercent(
                        'gujarati_jungle',
                        2,
                      ),
                      onTap: () => context.push('/gujarati-jungle'),
                    ),
                    const SizedBox(height: 16),
                    LandCard(
                      title: 'Maths Kingdom',
                      subtitle: 'Add, subtract & more!',
                      emoji: '\u{1F451}',
                      gradientColors: const [
                        AppColors.mathsKingdom,
                        Color(0xFF64B5F6),
                      ],
                      progress: progressProvider.getModuleProgressPercent(
                        'maths_kingdom',
                        4,
                      ),
                      onTap: () => context.push('/maths-kingdom'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
