import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/gujarati_data.dart';

class GujaratiLearningScreen extends StatefulWidget {
  const GujaratiLearningScreen({super.key});

  @override
  State<GujaratiLearningScreen> createState() =>
      _GujaratiLearningScreenState();
}

class _GujaratiLearningScreenState extends State<GujaratiLearningScreen> {
  bool _showDetail = false;
  int _selectedIndex = 0;
  late PageController _pageController;

  static const List<Color> _letterColors = [
    Color(0xFFFF6B6B), Color(0xFF4ECDC4), Color(0xFF45B7D1),
    Color(0xFFF9CA24), Color(0xFF6C5CE7), Color(0xFFFF9FF3),
    Color(0xFF00D2D3), Color(0xFFFFA502), Color(0xFFFF6348),
    Color(0xFF7BED9F), Color(0xFFE056A0), Color(0xFF686DE0),
    Color(0xFFFFBE76), Color(0xFF3DC1D3), Color(0xFFE77F67),
    Color(0xFFCF6A87), Color(0xFF574B90), Color(0xFFF19066),
    Color(0xFF546DE5), Color(0xFFC44569), Color(0xFFF78FB3),
    Color(0xFF3B3B98), Color(0xFF0A3D62), Color(0xFF60A3BC),
    Color(0xFFB71540), Color(0xFF079992),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openDetail(int index) {
    setState(() {
      _selectedIndex = index;
      _showDetail = true;
    });
    _pageController = PageController(initialPage: index);
  }

  @override
  Widget build(BuildContext context) {
    if (_showDetail) {
      return _buildDetailView();
    }
    return _buildGridView();
  }

  Widget _buildGridView() {
    final letters = GujaratiData.allLetters;
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
          'Learn Kakko \u{1F4D6}',
          style: GoogleFonts.balooTamma2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemCount: letters.length,
          itemBuilder: (context, index) {
            final item = letters[index];
            final color = _letterColors[index % _letterColors.length];
            return GestureDetector(
              onTap: () => _openDetail(index),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(102),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.letter,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.emoji,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailView() {
    final letters = GujaratiData.allLetters;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            setState(() {
              _showDetail = false;
            });
          },
          icon: const Icon(Icons.arrow_back_rounded, size: 28),
        ),
        title: Text(
          'Letter ${letters[_selectedIndex].transliteration}',
          style: GoogleFonts.balooTamma2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: letters.length,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final item = letters[index];
          final color = _letterColors[index % _letterColors.length];
          return _LetterDetailPage(item: item, color: color);
        },
      ),
    );
  }
}

class _LetterDetailPage extends StatefulWidget {
  final GujaratiLetter item;
  final Color color;

  const _LetterDetailPage({required this.item, required this.color});

  @override
  State<_LetterDetailPage> createState() => _LetterDetailPageState();
}

class _LetterDetailPageState extends State<_LetterDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Large letter with animation
          ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withAlpha(128),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.item.letter,
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Transliteration
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: widget.color.withAlpha(38),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.item.transliteration,
              style: GoogleFonts.balooTamma2(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: widget.color,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Emoji
          Text(
            widget.item.emoji,
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 12),
          // Example word
          Text(
            widget.item.exampleWord,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          // Word meaning
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              widget.item.wordMeaning,
              textAlign: TextAlign.center,
              style: GoogleFonts.balooTamma2(
                fontSize: 22,
                color: AppColors.textDark,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Vowel/Consonant badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: widget.item.isVowel
                  ? AppColors.primaryGreen.withAlpha(38)
                  : AppColors.primaryBlue.withAlpha(38),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.item.isVowel ? 'Vowel (\u{0AB8}\u{0ACD}\u{0AB5}\u{0AB0})' : 'Consonant (\u{0AB5}\u{0ACD}\u{0AAF}\u{0A82}\u{0A9C}\u{0AA8})',
              style: GoogleFonts.balooTamma2(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.item.isVowel
                    ? AppColors.primaryGreen
                    : AppColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Swipe hint
          Text(
            '\u{2B05}\u{FE0F} Swipe to see more \u{27A1}\u{FE0F}',
            style: GoogleFonts.balooTamma2(
              fontSize: 16,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
