import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/animals_data.dart';

class AnimalLearningScreen extends StatefulWidget {
  const AnimalLearningScreen({super.key});

  @override
  State<AnimalLearningScreen> createState() => _AnimalLearningScreenState();
}

class _AnimalLearningScreenState extends State<AnimalLearningScreen> {
  bool _showDetail = false;
  int _selectedIndex = 0;
  late PageController _pageController;
  late FlutterTts _tts;

  static const List<Color> _itemColors = [
    Color(0xFF8D6E63), Color(0xFFFF6B6B), Color(0xFF4ECDC4),
    Color(0xFF45B7D1), Color(0xFFF9CA24), Color(0xFF6C5CE7),
    Color(0xFFFF9FF3), Color(0xFF00D2D3), Color(0xFFFFA502),
    Color(0xFFFF6348), Color(0xFF7BED9F), Color(0xFFE056A0),
    Color(0xFF686DE0), Color(0xFFFFBE76), Color(0xFF3DC1D3),
    Color(0xFFE77F67), Color(0xFFCF6A87), Color(0xFF574B90),
    Color(0xFFF19066), Color(0xFF546DE5),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tts = FlutterTts();
    _tts.setLanguage('en-US');
    _tts.setSpeechRate(0.4);
    _tts.setPitch(1.0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tts.stop();
    super.dispose();
  }

  void _speak(String text) {
    _tts.speak(text);
  }

  void _openDetail(int index) {
    _speak(AnimalsData.animals[index].name);
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
          'Learn Animals \u{1F43E}',
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
            childAspectRatio: 0.85,
          ),
          itemCount: AnimalsData.animals.length,
          itemBuilder: (context, index) {
            final item = AnimalsData.animals[index];
            final color = _itemColors[index % _itemColors.length];
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
                      item.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.name,
                      style: GoogleFonts.balooTamma2(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
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
          AnimalsData.animals[_selectedIndex].name,
          style: GoogleFonts.balooTamma2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: AnimalsData.animals.length,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _speak(AnimalsData.animals[index].name);
        },
        itemBuilder: (context, index) {
          final item = AnimalsData.animals[index];
          final color = _itemColors[index % _itemColors.length];
          return _AnimalDetailPage(
            item: item,
            color: color,
            onSpeak: _speak,
          );
        },
      ),
    );
  }
}

class _AnimalDetailPage extends StatefulWidget {
  final AnimalItem item;
  final Color color;
  final void Function(String text) onSpeak;

  const _AnimalDetailPage({
    required this.item,
    required this.color,
    required this.onSpeak,
  });

  @override
  State<_AnimalDetailPage> createState() => _AnimalDetailPageState();
}

class _AnimalDetailPageState extends State<_AnimalDetailPage>
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
          // Large emoji with animation
          ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: widget.color.withAlpha(38),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: widget.color, width: 3),
              ),
              child: Center(
                child: Text(
                  widget.item.emoji,
                  style: const TextStyle(fontSize: 80),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Name with speaker button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.item.name,
                style: GoogleFonts.balooTamma2(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => widget.onSpeak(widget.item.name),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.color.withAlpha(38),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.volume_up_rounded,
                    color: widget.color,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Hindi name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: widget.color.withAlpha(38),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.item.hindiName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: widget.item.category == 'bird'
                  ? const Color(0xFF81C784)
                  : const Color(0xFFFFB74D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.item.category == 'bird' ? '\u{1F426} Bird' : '\u{1F43E} Animal',
              style: GoogleFonts.balooTamma2(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Habitat
          Container(
            width: double.infinity,
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
            child: Column(
              children: [
                Text(
                  '\u{1F3E0} Where they live',
                  style: GoogleFonts.balooTamma2(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.item.habitat,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.balooTamma2(
                    fontSize: 16,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Fun fact
          Container(
            width: double.infinity,
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
            child: Column(
              children: [
                Text(
                  '\u{2B50} Fun Fact',
                  style: GoogleFonts.balooTamma2(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.item.funFact,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.balooTamma2(
                    fontSize: 16,
                    color: AppColors.textDark,
                    height: 1.4,
                  ),
                ),
              ],
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
