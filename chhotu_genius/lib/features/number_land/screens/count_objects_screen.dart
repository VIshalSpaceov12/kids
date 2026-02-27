import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/providers/app_state_provider.dart';
import '../../../data/providers/progress_provider.dart';

class CountObjectsScreen extends StatefulWidget {
  const CountObjectsScreen({super.key});

  @override
  State<CountObjectsScreen> createState() => _CountObjectsScreenState();
}

class _CountObjectsScreenState extends State<CountObjectsScreen>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  late int _maxNumber;

  int _currentQuestion = 0;
  int _score = 0;
  int _correctAnswer = 0;
  String _currentEmoji = '';
  List<int> _options = [];
  bool? _isCorrect;
  bool _showSummary = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  static const int _totalQuestions = 10;
  static const List<String> _emojis = [
    '\u{1F41F}', '\u{1F34E}', '\u{2B50}', '\u{1F98B}', '\u{1F33A}',
    '\u{1F353}', '\u{1F680}', '\u{1F34C}', '\u{26BD}', '\u{1F382}',
    '\u{1F419}', '\u{1F40C}', '\u{1F31F}', '\u{1F33B}', '\u{1F36D}',
  ];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = context.read<AppStateProvider>().profile;
      final classLevel = AppConstants.getClassLevel(
        profile?.classLevel ?? 'nursery',
      );
      _maxNumber = min(classLevel.maxNumber, 10);
      _generateQuestion();
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _generateQuestion() {
    setState(() {
      _isCorrect = null;
      _correctAnswer = _random.nextInt(_maxNumber) + 1;
      _currentEmoji = _emojis[_random.nextInt(_emojis.length)];

      // Generate 4 unique options including correct answer
      final optionSet = <int>{_correctAnswer};
      while (optionSet.length < 4) {
        final option = _random.nextInt(_maxNumber) + 1;
        optionSet.add(option);
      }
      _options = optionSet.toList()..shuffle(_random);
    });
  }

  void _checkAnswer(int answer) {
    if (_isCorrect != null) return;

    setState(() {
      _isCorrect = answer == _correctAnswer;
      if (_isCorrect!) {
        _score++;
      } else {
        _shakeController.forward().then((_) => _shakeController.reset());
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_currentQuestion < _totalQuestions - 1) {
        setState(() {
          _currentQuestion++;
        });
        _generateQuestion();
      } else {
        // Save progress
        final stars = _score >= 9
            ? 3
            : _score >= 7
                ? 2
                : _score >= 5
                    ? 1
                    : 0;
        context
            .read<ProgressProvider>()
            .recordProgress('number_land', 'count_objects', stars);
        setState(() {
          _showSummary = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSummary) {
      return _buildSummary();
    }

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
          'Count Objects \u{1F522}',
          style: GoogleFonts.balooTamma2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withAlpha(38),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentQuestion + 1}/$_totalQuestions',
                  style: GoogleFonts.balooTamma2(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _options.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Score display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '\u{2B50}',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Score: $_score',
                        style: GoogleFonts.balooTamma2(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.starGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Question
                  Text(
                    'How many $_currentEmoji ?',
                    style: GoogleFonts.balooTamma2(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Emoji objects
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            _isCorrect == false
                                ? sin(_shakeController.value * 3 * pi) *
                                    _shakeAnimation.value
                                : 0,
                            0,
                          ),
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _isCorrect == null
                              ? AppColors.cardWhite
                              : _isCorrect!
                                  ? AppColors.correctGreen.withAlpha(51)
                                  : AppColors.wrongRed.withAlpha(51),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isCorrect == null
                                ? AppColors.primaryBlue.withAlpha(51)
                                : _isCorrect!
                                    ? AppColors.correctGreen
                                    : AppColors.wrongRed,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            runSpacing: 12,
                            children: List.generate(
                              _correctAnswer,
                              (i) => Text(
                                _currentEmoji,
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Feedback text
                  if (_isCorrect != null)
                    Text(
                      _isCorrect!
                          ? 'Great! \u{1F389}'
                          : 'Try again! It was $_correctAnswer',
                      style: GoogleFonts.balooTamma2(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _isCorrect!
                            ? AppColors.correctGreen
                            : AppColors.wrongRed,
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Answer options
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _options.length,
                    itemBuilder: (context, index) {
                      final option = _options[index];
                      final bool isThisCorrect = option == _correctAnswer;
                      Color btnColor = AppColors.primaryBlue;
                      if (_isCorrect != null) {
                        if (isThisCorrect) {
                          btnColor = AppColors.correctGreen;
                        } else {
                          btnColor = Colors.grey.shade400;
                        }
                      }
                      return GestureDetector(
                        onTap: () => _checkAnswer(option),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: btnColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: btnColor.withAlpha(102),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '$option',
                              style: GoogleFonts.balooTamma2(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildSummary() {
    final stars = _score >= 9
        ? 3
        : _score >= 7
            ? 2
            : _score >= 5
                ? 1
                : 0;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '\u{1F389}',
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 16),
                Text(
                  'Well Done!',
                  style: GoogleFonts.balooTamma2(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Score: $_score / $_totalQuestions',
                  style: GoogleFonts.balooTamma2(
                    fontSize: 28,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        i < stars ? '\u{2B50}' : '\u{2606}',
                        style: TextStyle(
                          fontSize: 48,
                          color: i < stars
                              ? AppColors.starGold
                              : Colors.grey.shade300,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentQuestion = 0;
                          _score = 0;
                          _showSummary = false;
                        });
                        _generateQuestion();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                      ),
                      child: Text(
                        'Play Again',
                        style: GoogleFonts.balooTamma2(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                      ),
                      child: Text(
                        'Back',
                        style: GoogleFonts.balooTamma2(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
