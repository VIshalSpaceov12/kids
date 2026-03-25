# Rhymes YouTube Audio + Karaoke Lyrics Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace TTS-based rhyme playback with YouTube audio-only streaming and karaoke-style lyrics highlighting.

**Architecture:** Use `youtube_explode_dart` to extract audio-only stream URLs from YouTube videos, `just_audio` to play them, and a position-synced lyrics widget that highlights the current line based on timestamps. The data model changes from a flat lyrics string to structured `LyricLine` objects with start times.

**Tech Stack:** Flutter, `youtube_explode_dart`, `just_audio`, `google_fonts`

**Spec:** `docs/superpowers/specs/2026-03-25-rhymes-youtube-audio-karaoke-design.md`

---

### Task 1: Add Dependencies

**Files:**
- Modify: `chhotu_genius/pubspec.yaml:9-25`

- [ ] **Step 1: Add `just_audio` and `youtube_explode_dart` to pubspec.yaml**

Add these two lines under `dependencies` after the existing `audioplayers` line:

```yaml
  just_audio: ^0.9.40
  youtube_explode_dart: ^2.3.5
```

- [ ] **Step 2: Run `flutter pub get` to verify resolution**

Run: `cd chhotu_genius && flutter pub get`
Expected: No version conflicts, all packages resolve.

- [ ] **Step 3: Commit**

```bash
git add chhotu_genius/pubspec.yaml chhotu_genius/pubspec.lock
git commit -m "feat(rhymes): add just_audio and youtube_explode_dart dependencies"
```

---

### Task 2: Update Data Model with YouTube IDs and Timestamped Lyrics

**Files:**
- Modify: `chhotu_genius/lib/features/rhymes/data/rhymes_data.dart` (full rewrite)

- [ ] **Step 1: Rewrite `rhymes_data.dart` with new model and all 20 rhymes**

Replace the entire file. The new model:

```dart
class LyricLine {
  final String text;
  final double startTime;

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

Each of the 20 rhymes needs:
- A valid YouTube video ID for a nursery rhyme recording
- `LyricLine` entries with approximate `startTime` values (seconds) matching the YouTube audio

YouTube video IDs to use (popular nursery rhyme channels with reliable availability):

| # | Title | YouTube Video ID | Notes |
|---|-------|-----------------|-------|
| 1 | Twinkle Twinkle Little Star | yCjJyiqpAuU | ChuChu TV |
| 2 | Johnny Johnny Yes Papa | F4tHL8reNCs | ChuChu TV |
| 3 | Jack and Jill | SLMJpHihykI | ChuChu TV |
| 4 | Humpty Dumpty | nrwzpiOBBCs | ChuChu TV |
| 5 | Baa Baa Black Sheep | MR5XSOdjKMA | ChuChu TV |
| 6 | Mary Had a Little Lamb | mZVCNgnYfmU | LittleBabyBum |
| 7 | Old MacDonald Had a Farm | _6HzoUcx3eo | LittleBabyBum |
| 8 | Wheels on the Bus | e_04ZrNroTo | ChuChu TV |
| 9 | Row Row Row Your Boat | 7otAJa3jui8 | ChuChu TV |
| 10 | Itsy Bitsy Spider | w_lCBkoGniQ | ChuChu TV |
| 11 | London Bridge Is Falling Down | -csGDoSSZyc | ChuChu TV |
| 12 | Head Shoulders Knees and Toes | ZanHgPprl-0 | LittleBabyBum |
| 13 | If You're Happy and You Know It | l4WNrvVjiTw | LittleBabyBum |
| 14 | Rain Rain Go Away | LFrKYjrIDs8 | ChuChu TV |
| 15 | Hickory Dickory Dock | vAoKNJLf7R0 | LittleBabyBum |
| 16 | Five Little Monkeys | ZhODBFQ2-bQ | ChuChu TV |
| 17 | Hot Cross Buns | gJJsqGOkKYM | ChuChu TV |
| 18 | Little Bo Peep | -TjUkPHJdAI | LittleBabyBum |
| 19 | Hey Diddle Diddle | aHKEMRNMdKI | LittleBabyBum |
| 20 | One Two Buckle My Shoe | ib3Idyml-pU | ChuChu TV |

Timestamps should be estimated based on typical nursery rhyme pacing (each line ~3-5 seconds). These will need manual tuning after testing with the actual videos.

- [ ] **Step 2: Verify the file compiles**

Run: `cd chhotu_genius && flutter analyze lib/features/rhymes/data/rhymes_data.dart`
Expected: No analysis errors.

- [ ] **Step 3: Commit**

```bash
git add chhotu_genius/lib/features/rhymes/data/rhymes_data.dart
git commit -m "feat(rhymes): add YouTube video IDs and timestamped lyrics to data model"
```

---

### Task 3: Create YouTube Audio Service

**Files:**
- Create: `chhotu_genius/lib/features/rhymes/services/youtube_audio_service.dart`

- [ ] **Step 1: Create the audio service**

This service wraps `youtube_explode_dart` to extract audio-only stream URLs:

```dart
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YouTubeAudioService {
  final _yt = YoutubeExplode();

  /// Extracts the best audio-only stream URL for a YouTube video.
  /// Returns null if extraction fails.
  Future<Uri?> getAudioUrl(String videoId) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      final audioOnly = manifest.audioOnly;
      if (audioOnly.isEmpty) return null;
      // Pick highest bitrate audio stream
      final best = audioOnly.withHighestBitrate();
      return best.url;
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _yt.close();
  }
}
```

- [ ] **Step 2: Verify file compiles**

Run: `cd chhotu_genius && flutter analyze lib/features/rhymes/services/youtube_audio_service.dart`
Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add chhotu_genius/lib/features/rhymes/services/youtube_audio_service.dart
git commit -m "feat(rhymes): add YouTube audio extraction service"
```

---

### Task 4: Rewrite Rhyme Player Screen with Audio + Karaoke UI

**Files:**
- Modify: `chhotu_genius/lib/features/rhymes/screens/rhyme_player_screen.dart` (full rewrite)

- [ ] **Step 1: Rewrite `rhyme_player_screen.dart`**

The new screen replaces `flutter_tts` with `just_audio` + `YouTubeAudioService`. Key elements:

**State:**
- `AudioPlayer` from `just_audio` for playback
- `YouTubeAudioService` for URL extraction
- `_isLoading` (bool) — true while fetching audio URL
- `_hasError` (bool) — true if audio fetch fails
- `_currentLineIndex` (int) — which lyric line is active (-1 = none)
- `_currentIndex` (int) — which rhyme in the PageView
- `PageController` for swipe navigation
- `ScrollController` for auto-scrolling lyrics
- `AnimationController` for pulse animation on play button

**initState:**
- Create `AudioPlayer`, `YouTubeAudioService`, controllers
- Listen to `audioPlayer.positionStream` to update `_currentLineIndex`:
  ```dart
  _audioPlayer.positionStream.listen((position) {
    final seconds = position.inMilliseconds / 1000.0;
    final lines = RhymesData.rhymes[_currentIndex].lines;
    int newIndex = -1;
    for (int i = lines.length - 1; i >= 0; i--) {
      if (seconds >= lines[i].startTime) {
        newIndex = i;
        break;
      }
    }
    if (newIndex != _currentLineIndex) {
      setState(() => _currentLineIndex = newIndex);
      _scrollToLine(newIndex);
    }
  });
  ```
- Listen to `audioPlayer.playerStateStream` to update play/pause UI

**_loadAndPlay(String videoId):**
1. Set `_isLoading = true`, `_hasError = false`
2. Call `_ytService.getAudioUrl(videoId)`
3. If null → set `_hasError = true`
4. Else → `_audioPlayer.setUrl(url.toString())` then `_audioPlayer.play()`
5. Set `_isLoading = false`

**_scrollToLine(int index):**
- Use `_scrollController.animateTo()` to center the active line
- Each line is approximately 48px tall; scroll to `index * 48 - containerHeight / 2`

**build() layout:**
```
Scaffold
├── AppBar (back button, title)
└── PageView.builder (swipe between rhymes)
    └── SingleChildScrollView
        ├── Emoji (72px)
        ├── Title
        ├── Seek bar (StreamBuilder on positionStream + durationStream)
        │   └── Slider showing current position / total duration
        ├── Controls row: [Prev 10s] [Play/Pause] [Next 10s]
        │   └── Play button: loading spinner when _isLoading,
        │       error icon + "Retry" when _hasError,
        │       play/pause icon otherwise
        ├── Lyrics card (Container with rounded border)
        │   └── Column of lyric lines
        │       ├── Active line: bold, fontSize 22, color = accent
        │       └── Other lines: normal, fontSize 18, color = textLight
        └── Swipe hint text
```

**Page change handler:**
- Stop audio, reset `_currentLineIndex = -1`, clear loading/error state

**dispose:**
- `_audioPlayer.dispose()`, `_ytService.dispose()`, controllers

**Error state UI:**
- Show emoji icon, "Can't play right now" message, "Check your internet!" subtitle, and a "Try Again" button that calls `_loadAndPlay` again

- [ ] **Step 2: Verify file compiles**

Run: `cd chhotu_genius && flutter analyze lib/features/rhymes/screens/rhyme_player_screen.dart`
Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add chhotu_genius/lib/features/rhymes/screens/rhyme_player_screen.dart
git commit -m "feat(rhymes): rewrite player with YouTube audio and karaoke lyrics"
```

---

### Task 5: Update Rhymes List Screen (Minor)

**Files:**
- Modify: `chhotu_genius/lib/features/rhymes/screens/rhymes_screen.dart:6`

- [ ] **Step 1: Verify rhymes_screen.dart still works**

The list screen uses `RhymeItem.title` and `RhymeItem.emoji` — both still exist in the new model. The `lyrics` field is now a getter. The screen should compile without changes.

Run: `cd chhotu_genius && flutter analyze lib/features/rhymes/`
Expected: No errors in any rhymes files.

- [ ] **Step 2: Commit (only if changes were needed)**

---

### Task 6: Manual Testing Checklist

- [ ] **Step 1: Run the app on a device/emulator**

Run: `cd chhotu_genius && flutter run`

- [ ] **Step 2: Test rhymes list screen**
- All 20 rhymes show in the list
- Cards display title, emoji, and "Tap to listen" text

- [ ] **Step 3: Test rhyme player — happy path**
- Tap a rhyme → player screen opens
- Tap play → loading spinner shows briefly → audio starts playing
- Lyrics highlight line by line as audio plays
- Seek bar moves with audio position
- Tap pause → audio pauses, lyrics freeze on current line
- Tap play again → resumes from same position

- [ ] **Step 4: Test rhyme player — controls**
- Skip forward/back 10s buttons work
- Dragging seek bar changes audio position and lyrics update

- [ ] **Step 5: Test rhyme player — swipe navigation**
- Swipe left/right → navigates to next/prev rhyme
- Previous audio stops
- New rhyme shows fresh state (no highlighted lines, play button ready)

- [ ] **Step 6: Test rhyme player — error state**
- Turn off internet → tap play → error message shows with retry button
- Turn on internet → tap retry → audio loads and plays

- [ ] **Step 7: Test rhyme player — back navigation**
- Press back → audio stops, returns to list screen

- [ ] **Step 8: Tune timestamps**
- For each rhyme, play the YouTube audio and note when each line starts
- Update `startTime` values in `rhymes_data.dart` to match
- This is iterative — expect 2-3 passes per rhyme

- [ ] **Step 9: Final commit**

```bash
git add -A
git commit -m "feat(rhymes): tune lyric timestamps for all 20 rhymes"
```
