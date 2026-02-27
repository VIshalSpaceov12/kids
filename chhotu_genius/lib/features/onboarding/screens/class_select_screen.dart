import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/providers/app_state_provider.dart';

class ClassSelectScreen extends StatefulWidget {
  const ClassSelectScreen({super.key});

  @override
  State<ClassSelectScreen> createState() => _ClassSelectScreenState();
}

class _ClassSelectScreenState extends State<ClassSelectScreen> {
  String? _selectedClass;

  static const List<Color> _cardColors = [
    AppColors.primaryBlue,
    AppColors.primaryGreen,
    AppColors.primaryOrange,
    AppColors.primaryPurple,
    AppColors.numberLand,
    AppColors.mathsKingdom,
  ];

  static const List<String> _classEmojis = [
    '\u{1F476}', // baby
    '\u{1F467}', // girl
    '\u{1F4D6}', // book
    '\u{270F}\u{FE0F}', // pencil
    '\u{1F393}', // graduation cap
    '\u{1F31F}', // star
  ];

  void _onNext() {
    if (_selectedClass != null) {
      context.read<AppStateProvider>().setOnboardingClassLevel(_selectedClass!);
      context.go('/onboarding/avatar');
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
                'Which class are you in?',
                style: GoogleFonts.balooTamma2(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '\u{1F3EB}',
                style: TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 24),
              // 2-column grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: AppConstants.classLevels.length,
                  itemBuilder: (context, index) {
                    final classLevel = AppConstants.classLevels[index];
                    final isSelected = _selectedClass == classLevel.id;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedClass = classLevel.id;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: _cardColors[index].withAlpha(isSelected ? 255 : 51),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? _cardColors[index]
                                : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: _cardColors[index].withAlpha(102),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(26),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _classEmojis[index],
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              classLevel.name,
                              style: GoogleFonts.balooTamma2(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textDark,
                              ),
                            ),
                            if (isSelected)
                              const Text(
                                '\u{2705}',
                                style: TextStyle(fontSize: 20),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Next button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedClass != null ? _onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedClass != null
                        ? AppColors.primaryOrange
                        : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: _selectedClass != null ? 4 : 0,
                  ),
                  child: Text(
                    'Next \u{27A1}',
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
