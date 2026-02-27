import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/providers/app_state_provider.dart';

class AvatarSelectScreen extends StatefulWidget {
  const AvatarSelectScreen({super.key});

  @override
  State<AvatarSelectScreen> createState() => _AvatarSelectScreenState();
}

class _AvatarSelectScreenState extends State<AvatarSelectScreen> {
  String? _selectedAvatar;

  static const List<Color> _avatarColors = [
    Color(0xFFFFCDD2), // lion - light red
    Color(0xFFFFE0B2), // tiger - light orange
    Color(0xFFC8E6C9), // elephant - light green
    Color(0xFFB3E5FC), // peacock - light blue
    Color(0xFFF8BBD0), // monkey - light pink
    Color(0xFFE1BEE7), // parrot - light purple
  ];

  Future<void> _onStart() async {
    if (_selectedAvatar == null) return;

    final appState = context.read<AppStateProvider>();
    appState.setOnboardingAvatar(_selectedAvatar!);
    await appState.completeOnboarding();

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'Pick your buddy!',
                style: GoogleFonts.balooTamma2(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a friend for your adventure',
                style: GoogleFonts.balooTamma2(
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 32),
              // 2x3 grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: AppConstants.avatarOptions.length,
                  itemBuilder: (context, index) {
                    final avatar = AppConstants.avatarOptions[index];
                    final isSelected = _selectedAvatar == avatar.id;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatar = avatar.id;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _avatarColors[index]
                              : AppColors.cardWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryOrange
                                : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? AppColors.primaryOrange.withAlpha(77)
                                  : Colors.black.withAlpha(26),
                              blurRadius: isSelected ? 12 : 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              scale: isSelected ? 1.2 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                avatar.emoji,
                                style: const TextStyle(fontSize: 56),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              avatar.name,
                              style: GoogleFonts.balooTamma2(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            if (isSelected)
                              const Text(
                                '\u{2705}',
                                style: TextStyle(fontSize: 16),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Start button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedAvatar != null ? _onStart : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAvatar != null
                        ? AppColors.primaryGreen
                        : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: _selectedAvatar != null ? 4 : 0,
                  ),
                  child: Text(
                    'Start Learning! \u{1F389}',
                    style: GoogleFonts.balooTamma2(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
