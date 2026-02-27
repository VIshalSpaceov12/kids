import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/mythology_alphabet.dart';

class LetterLearningScreen extends StatefulWidget {
  const LetterLearningScreen({super.key});

  @override
  State<LetterLearningScreen> createState() => _LetterLearningScreenState();
}

class _LetterLearningScreenState extends State<LetterLearningScreen> {
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
          'Learn Letters \u{1F524}',
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
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: MythologyAlphabet.letters.length,
          itemBuilder: (context, index) {
            final item = MythologyAlphabet.letters[index];
            final color = _letterColors[index % _letterColors.length];
            return GestureDetector(
              onTap: () => _openDetail(index),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
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
                      style: GoogleFonts.balooTamma2(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.emoji,
                      style: const TextStyle(fontSize: 18),
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
          'Letter ${MythologyAlphabet.letters[_selectedIndex].letter}',
          style: GoogleFonts.balooTamma2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: MythologyAlphabet.letters.length,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final item = MythologyAlphabet.letters[index];
          final color = _letterColors[index % _letterColors.length];
          return _LetterDetailPage(item: item, color: color);
        },
      ),
    );
  }
}

class _LetterDetailPage extends StatefulWidget {
  final MythologyLetter item;
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Uppercase
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(24),
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
                      style: GoogleFonts.balooTamma2(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Lowercase
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: widget.color.withAlpha(77),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: widget.color, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      widget.item.letter.toLowerCase(),
                      style: GoogleFonts.balooTamma2(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Mythology emoji (large)
          Text(
            widget.item.emoji,
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 16),
          // Character name
          Text(
            widget.item.characterName,
            style: GoogleFonts.balooTamma2(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          // Gujarati name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: widget.color.withAlpha(38),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.item.gujaratiName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Description
          Container(
            padding: const EdgeInsets.all(20),
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
              widget.item.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.balooTamma2(
                fontSize: 18,
                color: AppColors.textDark,
                height: 1.4,
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
