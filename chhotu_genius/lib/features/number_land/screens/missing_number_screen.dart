import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/providers/app_state_provider.dart';
import '../../../data/providers/progress_provider.dart';

class MissingNumberScreen extends StatefulWidget {
  const MissingNumberScreen({super.key});

  @override
  State<MissingNumberScreen> createState() => _MissingNumberScreenState();
}

class _MissingNumberScreenState extends State<MissingNumberScreen> {
  final Random _random = Random();
  late int _maxNumber;

  int _currentRound = 0;
  int _score = 0;
  int _missingNumber = 0;
  int _missingIndex = 0;
  List<int> _sequence = [];
  List<int> _options = [];
  bool? _isCorrect;
  bool _showSummary = false;

  static const int _totalRounds = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = context.read<AppStateProvider>().profile;
      final classLevel = AppConstants.getClassLevel(
        profile?.classLevel ?? 'nursery',
      );
      _maxNumber = classLevel.maxNumber;
      _generateRound();
    });
  }

  void _generateRound() {
    setState(() {
      _isCorrect = null;

      // Generate a sequence of 4-5 consecutive numbers
      final seqLength = _random.nextBool() ? 4 : 5;
      final maxStart = _maxNumber - seqLength;
      final start = _random.nextInt(max(1, maxStart)) + 1;

      _sequence = List.generate(seqLength, (i) => start + i);
      _missingIndex = _random.nextInt(seqLength);
      _missingNumber = _sequence[_missingIndex];

      // Generate options
      final optionSet = <int>{_missingNumber};
      while (optionSet.length < 4) {
        final delta = _random.nextInt(5) - 2;
        final option = _missingNumber + delta;
        if (option > 0 && option <= _maxNumber) {
          optionSet.add(option);
        }
      }
      _options = optionSet.toList()..shuffle(_random);
    });
  }

  void _checkAnswer(int answer) {
    if (_isCorrect != null) return;

    setState(() {
      _isCorrect = answer == _missingNumber;
      if (_isCorrect!) {
        _score++;
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_currentRound < _totalRounds - 1) {
        setState(() {
          _currentRound++;
        });
        _generateRound();
      } else {
        final stars = _score >= 9
            ? 3
            : _score >= 7
                ? 2
                : _score >= 5
                    ? 1
                    : 0;
        context
            .read<ProgressProvider>()
            .recordProgress('number_land', 'missing_number', stars);
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
          'Missing Number \u{2753}',
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
                  '${_currentRound + 1}/$_totalRounds',
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
      body: _sequence.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Score
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
                  const SizedBox(height: 24),
                  // Question text
                  Text(
                    'Find the missing number!',
                    style: GoogleFonts.balooTamma2(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Number sequence
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_sequence.length, (index) {
                      final isMissing = index == _missingIndex;
                      final showAnswer = isMissing && _isCorrect != null;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: isMissing
                                ? (showAnswer
                                    ? (_isCorrect!
                                        ? AppColors.correctGreen
                                        : AppColors.wrongRed)
                                    : AppColors.primaryOrange.withAlpha(51))
                                : AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(16),
                            border: isMissing && !showAnswer
                                ? Border.all(
                                    color: AppColors.primaryOrange,
                                    width: 3,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                  )
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(26),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              isMissing
                                  ? (showAnswer ? '$_missingNumber' : '?')
                                  : '${_sequence[index]}',
                              style: GoogleFonts.balooTamma2(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color:
                                    isMissing && !showAnswer
                                        ? AppColors.primaryOrange
                                        : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),
                  // Feedback
                  if (_isCorrect != null)
                    Text(
                      _isCorrect!
                          ? 'Correct! \u{1F389}'
                          : 'The answer was $_missingNumber',
                      style: GoogleFonts.balooTamma2(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _isCorrect!
                            ? AppColors.correctGreen
                            : AppColors.wrongRed,
                      ),
                    ),
                  const Spacer(),
                  // Options
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
                      final bool isThisCorrect = option == _missingNumber;
                      Color btnColor = AppColors.primaryPurple;
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
                  const SizedBox(height: 32),
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
                  '\u{1F3C6}',
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 16),
                Text(
                  'Amazing!',
                  style: GoogleFonts.balooTamma2(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Score: $_score / $_totalRounds',
                  style: GoogleFonts.balooTamma2(
                    fontSize: 28,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
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
                          _currentRound = 0;
                          _score = 0;
                          _showSummary = false;
                        });
                        _generateRound();
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
