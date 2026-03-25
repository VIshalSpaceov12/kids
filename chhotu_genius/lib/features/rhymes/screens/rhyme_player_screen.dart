import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/rhymes_data.dart';
import '../services/youtube_audio_service.dart';

class RhymePlayerScreen extends StatefulWidget {
  final int rhymeIndex;

  const RhymePlayerScreen({super.key, required this.rhymeIndex});

  @override
  State<RhymePlayerScreen> createState() => _RhymePlayerScreenState();
}

class _RhymePlayerScreenState extends State<RhymePlayerScreen>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late YouTubeAudioService _ytService;
  late PageController _pageController;
  late ScrollController _scrollController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  late int _currentIndex;
  int _currentLineIndex = -1;
  bool _isLoading = false;
  bool _hasError = false;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _stateSub;

  static const List<Color> _colors = [
    Color(0xFFE91E63), Color(0xFF9C27B0), Color(0xFF3F51B5),
    Color(0xFF00BCD4), Color(0xFF4CAF50), Color(0xFFFF9800),
    Color(0xFFE91E63), Color(0xFF673AB7), Color(0xFF009688),
    Color(0xFFFF5722), Color(0xFF2196F3), Color(0xFF8BC34A),
    Color(0xFFF44336), Color(0xFF00ACC1), Color(0xFFFF6F00),
    Color(0xFF7B1FA2), Color(0xFF388E3C), Color(0xFFD84315),
    Color(0xFF1565C0), Color(0xFFC2185B),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.rhymeIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _scrollController = ScrollController();
    _audioPlayer = AudioPlayer();
    _ytService = YouTubeAudioService();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _positionSub = _audioPlayer.positionStream.listen((position) {
      if (!mounted) return;
      final rhyme = RhymesData.rhymes[_currentIndex];
      final currentSeconds = position.inMilliseconds / 1000.0;
      int newIndex = -1;
      for (int i = rhyme.lines.length - 1; i >= 0; i--) {
        if (rhyme.lines[i].startTime <= currentSeconds) {
          newIndex = i;
          break;
        }
      }
      if (newIndex != _currentLineIndex) {
        setState(() => _currentLineIndex = newIndex);
        if (newIndex >= 0) {
          _scrollToLine(newIndex);
        }
      }
    });

    _stateSub = _audioPlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      if (state.processingState == ProcessingState.completed) {
        setState(() => _currentLineIndex = -1);
      }
      // Trigger rebuild for play/pause state changes
      setState(() {});
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _stateSub?.cancel();
    _audioPlayer.dispose();
    _ytService.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadAndPlay(String videoId) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _currentLineIndex = -1;
    });

    final url = await _ytService.getAudioUrl(videoId);
    if (!mounted) return;

    if (url == null) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      return;
    }

    try {
      await _audioPlayer.setUrl(url.toString());
      _audioPlayer.play();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      return;
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _togglePlayPause() {
    if (_isLoading) return;

    final rhyme = RhymesData.rhymes[_currentIndex];

    if (_hasError) {
      _loadAndPlay(rhyme.youtubeVideoId);
      return;
    }

    // If no source loaded yet, or player completed, load and play
    final state = _audioPlayer.playerState;
    if (state.processingState == ProcessingState.idle ||
        state.processingState == ProcessingState.completed) {
      _loadAndPlay(rhyme.youtubeVideoId);
      return;
    }

    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void _scrollToLine(int index) {
    if (!_scrollController.hasClients) return;
    final target = (index * 48.0 - 80).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Color _getColor(int index) => _colors[index % _colors.length];

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _statusText() {
    if (_isLoading) return 'Loading...';
    if (_hasError) return "Can't play - tap to retry";
    final state = _audioPlayer.playerState;
    if (state.processingState == ProcessingState.idle ||
        state.processingState == ProcessingState.completed) {
      return 'Tap to play';
    }
    if (_audioPlayer.playing) return 'Playing...';
    return 'Paused';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            _audioPlayer.stop();
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded, size: 28),
        ),
        title: Text(
          RhymesData.rhymes[_currentIndex].title,
          style: GoogleFonts.balooTamma2(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: RhymesData.rhymes.length,
        onPageChanged: (index) {
          _audioPlayer.stop();
          setState(() {
            _currentIndex = index;
            _currentLineIndex = -1;
            _isLoading = false;
            _hasError = false;
          });
        },
        itemBuilder: (context, index) {
          final rhyme = RhymesData.rhymes[index];
          final color = _getColor(index);
          final isActive = index == _currentIndex;
          return _RhymePage(
            rhyme: rhyme,
            color: color,
            isLoading: _isLoading && isActive,
            hasError: _hasError && isActive,
            currentLineIndex: isActive ? _currentLineIndex : -1,
            audioPlayer: _audioPlayer,
            pulseAnim: _pulseAnim,
            scrollController: isActive ? _scrollController : ScrollController(),
            isPlaying: isActive && _audioPlayer.playing,
            onTogglePlayPause: _togglePlayPause,
            formatDuration: _formatDuration,
            statusText: isActive ? _statusText() : 'Tap to play',
          );
        },
      ),
    );
  }
}

class _RhymePage extends StatelessWidget {
  final RhymeItem rhyme;
  final Color color;
  final bool isLoading;
  final bool hasError;
  final int currentLineIndex;
  final AudioPlayer audioPlayer;
  final Animation<double> pulseAnim;
  final ScrollController scrollController;
  final bool isPlaying;
  final VoidCallback onTogglePlayPause;
  final String Function(Duration) formatDuration;
  final String statusText;

  const _RhymePage({
    required this.rhyme,
    required this.color,
    required this.isLoading,
    required this.hasError,
    required this.currentLineIndex,
    required this.audioPlayer,
    required this.pulseAnim,
    required this.scrollController,
    required this.isPlaying,
    required this.onTogglePlayPause,
    required this.formatDuration,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Emoji
          Text(
            rhyme.emoji,
            style: const TextStyle(fontSize: 72),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            rhyme.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.balooTamma2(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),
          // Seek bar
          StreamBuilder<Duration>(
            stream: audioPlayer.positionStream,
            builder: (context, posSnap) {
              final position = posSnap.data ?? Duration.zero;
              final duration = audioPlayer.duration ?? Duration.zero;
              final posSeconds = position.inMilliseconds / 1000.0;
              final durSeconds = duration.inMilliseconds / 1000.0;
              return Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7,
                      ),
                    ),
                    child: Slider(
                      value: durSeconds > 0
                          ? posSeconds.clamp(0.0, durSeconds)
                          : 0.0,
                      max: durSeconds > 0 ? durSeconds : 1.0,
                      activeColor: color,
                      inactiveColor: color.withAlpha(51),
                      onChanged: durSeconds > 0
                          ? (value) {
                              audioPlayer.seek(
                                Duration(milliseconds: (value * 1000).toInt()),
                              );
                            }
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatDuration(position),
                          style: GoogleFonts.balooTamma2(
                            fontSize: 13,
                            color: AppColors.textLight,
                          ),
                        ),
                        Text(
                          formatDuration(duration),
                          style: GoogleFonts.balooTamma2(
                            fontSize: 13,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          // Controls row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  final newPos = audioPlayer.position -
                      const Duration(seconds: 10);
                  audioPlayer.seek(
                    newPos < Duration.zero ? Duration.zero : newPos,
                  );
                },
                icon: Icon(
                  Icons.replay_10,
                  size: 32,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(width: 24),
              // Play/Pause button
              GestureDetector(
                onTap: onTogglePlayPause,
                child: ScaleTransition(
                  scale: isPlaying
                      ? pulseAnim
                      : const AlwaysStoppedAnimation(1.0),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withAlpha(102),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _buildPlayButtonContent(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              IconButton(
                onPressed: () {
                  final newPos = audioPlayer.position +
                      const Duration(seconds: 10);
                  final dur = audioPlayer.duration ?? Duration.zero;
                  audioPlayer.seek(newPos > dur ? dur : newPos);
                },
                icon: Icon(
                  Icons.forward_10,
                  size: 32,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Status text
          Text(
            statusText,
            style: GoogleFonts.balooTamma2(
              fontSize: 15,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 20),
          // Lyrics card
          Container(
            width: double.infinity,
            height: rhyme.lines.length * 48.0 + 32,
            constraints: const BoxConstraints(maxHeight: 320),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withAlpha(51), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(38),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: rhyme.lines.length,
                itemBuilder: (context, i) {
                  final isActive = i == currentLineIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 8,
                    ),
                    child: AnimatedScale(
                      scale: isActive ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: GoogleFonts.balooTamma2(
                          fontSize: isActive ? 22 : 18,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive ? color : AppColors.textLight,
                        ),
                        textAlign: TextAlign.center,
                        child: Text(
                          rhyme.lines[i].text,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Swipe hint
          Text(
            '\u{2B05}\u{FE0F} Swipe for more rhymes \u{27A1}\u{FE0F}',
            style: GoogleFonts.balooTamma2(
              fontSize: 15,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPlayButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
      );
    }
    if (hasError) {
      return const Icon(Icons.refresh, color: Colors.white, size: 40);
    }
    if (isPlaying) {
      return const Icon(Icons.stop_rounded, color: Colors.white, size: 40);
    }
    return const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40);
  }
}
