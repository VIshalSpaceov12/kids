# Rhymes Module: YouTube Audio + Karaoke Lyrics

## Problem

The current Rhymes module uses `flutter_tts` to read lyrics in a robotic monotone voice. Kids expect singing, not text-to-speech. The experience is not engaging.

## Solution

Replace TTS with YouTube audio-only playback and add karaoke-style lyrics that highlight line-by-line in sync with the audio.

## Architecture

### Packages

- **`youtube_explode_dart`** — Extract audio-only stream URLs from YouTube video IDs
- **`just_audio`** — Play audio streams with position tracking
- Keep `flutter_tts` in pubspec (used by animals_birds module)

### Data Model Changes

**File:** `lib/features/rhymes/data/rhymes_data.dart`

Replace flat `lyrics` string with structured timestamped lines:

```dart
class LyricLine {
  final String text;
  final double startTime; // seconds into the audio

  const LyricLine({required this.text, required this.startTime});
}

class RhymeItem {
  final String title;
  final String emoji;
  final String youtubeVideoId;
  final List<LyricLine> lines;

  const RhymeItem({
    required this.title,
    required this.emoji,
    required this.youtubeVideoId,
    required this.lines,
  });

  String get lyrics => lines.map((l) => l.text).join('\n');
}
```

All 20 rhymes need: a YouTube video ID and per-line start timestamps.

### Screen Layout

```
┌─────────────────────────┐
│     ◄ Twinkle Twinkle   │  AppBar
├─────────────────────────┤
│          ⭐              │  Big emoji
│   Twinkle Twinkle       │  Title
│       Little Star       │
│                         │
│     [ seek bar ]        │  Audio progress
│    ◄◄   ▶/⏸   ►►      │  Play controls
│                         │
│  ┌───────────────────┐  │
│  │ Twinkle, twinkle  │  │  dim
│  │ ★ How I wonder ★  │  │  HIGHLIGHTED (current)
│  │ Up above the...   │  │  dim
│  │ Like a diamond... │  │  dim
│  └───────────────────┘  │
│                         │
│  ◄ Swipe for more ►    │
└─────────────────────────┘
```

### Player Behavior

1. User taps play → `youtube_explode_dart` fetches audio stream URL for the video ID
2. `just_audio` starts playing the audio stream
3. A `StreamBuilder` listens to `just_audio` position stream
4. Current position is compared against `LyricLine.startTime` values to determine which line is active
5. Active line is highlighted (bold, larger font, accent color); other lines are dimmed
6. Lyrics auto-scroll to keep the active line centered
7. Swipe navigates to next/previous rhyme (stops current audio)

### Error Handling

- If YouTube audio extraction fails (no internet, video removed): show a friendly message "Can't play right now. Check your internet!" with a retry button
- Loading state: show a spinner on the play button while fetching audio URL

## Files Changed

| File | Change |
|------|--------|
| `pubspec.yaml` | Add `youtube_explode_dart`, `just_audio` |
| `lib/features/rhymes/data/rhymes_data.dart` | New data model with video IDs + timestamped lines |
| `lib/features/rhymes/screens/rhyme_player_screen.dart` | Complete rewrite: audio player + karaoke UI |
| `lib/features/rhymes/screens/rhymes_screen.dart` | No changes (list screen stays the same) |

## Out of Scope

- Offline fallback / asset audio files
- Video playback
- Progress tracking integration
- Changes to other modules
- Backend changes
