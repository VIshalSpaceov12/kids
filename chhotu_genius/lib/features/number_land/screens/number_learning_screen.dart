import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/providers/app_state_provider.dart';
import '../data/number_data.dart';

class NumberLearningScreen extends StatefulWidget {
  const NumberLearningScreen({super.key});

  @override
  State<NumberLearningScreen> createState() => _NumberLearningScreenState();
}

class _NumberLearningScreenState extends State<NumberLearningScreen> {
  bool _showDetail = false;
  int _selectedIndex = 0;
  late PageController _pageController;
  late List<NumberItem> _numbers;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profile = context.read<AppStateProvider>().profile;
    final classLevel = AppConstants.getClassLevel(
      profile?.classLevel ?? 'nursery',
    );
    _numbers = NumberData.getNumbersForClass(classLevel.maxNumber);
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

  static const List<Color> _tileColors = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFF45B7D1),
    Color(0xFFF9CA24),
    Color(0xFF6C5CE7),
    Color(0xFFFF9FF3),
    Color(0xFF00D2D3),
    Color(0xFFFFA502),
    Color(0xFFFF6348),
    Color(0xFF7BED9F),
  ];

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
          'Learn Numbers \u{1F4DA}',
          style: GoogleFonts.balooTamma2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: _numbers.length,
          itemBuilder: (context, index) {
            final item = _numbers[index];
            final color = _tileColors[index % _tileColors.length];
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
                child: Center(
                  child: Text(
                    '${item.number}',
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
          'Number ${_numbers[_selectedIndex].number}',
          style: GoogleFonts.balooTamma2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _numbers.length,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final item = _numbers[index];
          final color = _tileColors[index % _tileColors.length];
          return _NumberDetailPage(item: item, color: color);
        },
      ),
    );
  }
}

class _NumberDetailPage extends StatefulWidget {
  final NumberItem item;
  final Color color;

  const _NumberDetailPage({required this.item, required this.color});

  @override
  State<_NumberDetailPage> createState() => _NumberDetailPageState();
}

class _NumberDetailPageState extends State<_NumberDetailPage>
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
          const SizedBox(height: 24),
          // Large number with animation
          ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withAlpha(128),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${widget.item.number}',
                  style: GoogleFonts.balooTamma2(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Emoji objects representing the count
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              widget.item.number,
              (i) => Text(
                widget.item.emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // English name
          Text(
            widget.item.englishName,
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
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Emoji name
          Text(
            '${widget.item.number} ${widget.item.emojiName}${widget.item.number > 1 ? 's' : ''}',
            style: GoogleFonts.balooTamma2(
              fontSize: 20,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          // Swipe hint
          Text(
            '\u{2B05}\u{FE0F} Swipe to see more \u{27A1}\u{FE0F}',
            style: GoogleFonts.balooTamma2(
              fontSize: 16,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
