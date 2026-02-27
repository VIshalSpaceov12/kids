import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_state_provider.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isNameValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        _isNameValid = _nameController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onNext() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      context.read<AppStateProvider>().setOnboardingName(name);
      context.go('/onboarding/class');
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
              const Spacer(),
              // Elephant emoji
              const Text(
                '\u{1F418}',
                style: TextStyle(fontSize: 100),
              ),
              const SizedBox(height: 24),
              // Question
              Text(
                "What's your name?",
                style: GoogleFonts.balooTamma2(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Name input
              TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                style: GoogleFonts.balooTamma2(
                  fontSize: 24,
                  color: AppColors.textDark,
                ),
                decoration: InputDecoration(
                  hintText: 'Type your name...',
                  hintStyle: GoogleFonts.balooTamma2(
                    fontSize: 20,
                    color: AppColors.textLight,
                  ),
                  filled: true,
                  fillColor: AppColors.cardWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: AppColors.primaryBlue.withAlpha(77),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: AppColors.primaryBlue,
                      width: 3,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _isNameValid ? _onNext() : null,
              ),
              const Spacer(),
              // Next button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isNameValid ? _onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isNameValid
                        ? AppColors.primaryOrange
                        : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: _isNameValid ? 4 : 0,
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
