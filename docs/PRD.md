# Chhotu Genius - Product Requirements Document (PRD)

**Version:** 1.0
**Date:** 2026-02-27
**Status:** Draft

---

## 1. Product Overview

### 1.1 Product Name
**Chhotu Genius** — Learn, Play, Grow!

### 1.2 Vision
A fun, gamified educational app for kids (Nursery to Class 4, ages 3-10) that teaches Numbers, English Alphabets, Gujarati Barakhadi, and Basic Maths through interactive games. The app is completely free with no ads or in-app purchases.

### 1.3 Problem Statement
Indian parents, especially Gujarati-speaking families, lack a single, engaging app that combines:
- English alphabet and number learning
- Gujarati Barakhadi (બારાખડી) learning
- Basic mathematics
- Indian cultural context (Hindu mythology references)
- Parental controls and progress tracking

Most existing apps are either English-only, lack gamification, or require subscriptions.

### 1.4 Target Users

| User Type | Description |
|-----------|-------------|
| **Primary** | Children aged 3-10 (Nursery to Class 4) |
| **Secondary** | Parents who want to monitor and control their child's learning |
| **Admin** | App administrators who manage content and review user data |

### 1.5 Platforms
- Android (primary)
- iOS

### 1.6 Monetization
Completely free — no ads, no in-app purchases, no subscriptions.

---

## 2. Feature Modules

The app is structured as an animated **World Map** with 4 learning "lands". Each land represents a subject module. A pet companion follows the child across the map.

### 2.1 World Map Home Screen
- App opens as an animated game world with different "lands"
- Each subject = one land (Number Land, ABC Forest, Gujarati Jungle, Maths Kingdom)
- Lands are visible from the start; content within each land progresses by difficulty
- A pet companion follows the child across the map
- Visual indicators show progress in each land

### 2.2 Module 1 — Number Land (1–100)

Teaches number recognition, counting, and basic number concepts.

| Feature | Description | Difficulty Levels |
|---------|-------------|-------------------|
| Animated Number Learning | Tap a number → see animation + hear pronunciation (English/Gujarati) | Nursery: 1-10, KG: 1-20, Class 1: 1-50, Class 2+: 1-100 |
| Count Objects Game | Count objects (animals, fruits, stars) shown on screen | Simple (1-5) → Complex (up to 100) |
| Missing Number Puzzle | Fill in the blank in a number sequence: 1, 2, __, 4 | Sequences of 3 → sequences of 10 |
| Odd/Even Sorter | Drag numbers into Odd or Even baskets | Numbers 1-10 → 1-100 |
| Number Train | Arrange numbers in correct order on a moving train | 3 numbers → 10 numbers |
| Balloon Pop Challenge | Pop balloons in ascending/descending order | Small sets (5) → large sets (20) |

**Learning Outcomes:**
- Number recognition (1-100)
- Counting and quantity association
- Number sequencing and ordering
- Odd/even concept

### 2.3 Module 2 — ABC Forest (A–Z English)

Teaches English alphabets with **Hindu mythology themed** words and images.

| Feature | Description | Difficulty Levels |
|---------|-------------|-------------------|
| Letter Tracing | Trace letters with finger on guided path with visual feedback | Uppercase → Lowercase → Cursive |
| Mythology Word + Image + Sound | Each letter mapped to Hindu mythology: A for Arjun, B for Bheem, C for Chanakya, D for Durga, G for Ganesh, H for Hanuman, K for Krishna, L for Lakshmi, R for Ram, S for Shiva, V for Vishnu, etc. — with illustration and audio | Single letter → Simple words → Sentences |
| Alphabet Karaoke | Sing-along ABC song with highlighted letters and mythology images | — |
| Letter Match | Match letter to correct mythology character image | 4 options → 8 options |
| Word Builder | Drag letters to build words (R-A-M, S-I-T-A) | 3-letter → 5-letter words |
| Phonics Challenge | Listen to a sound, pick the correct letter | Single sounds → Blends (sh, ch, th) |

**Hindu Mythology Alphabet Mapping (Reference):**

| Letter | Character | Letter | Character |
|--------|-----------|--------|-----------|
| A | Arjun (અર્જુન) | N | Nakul (નકુલ) |
| B | Bheem (ભીમ) | O | Om (ઓમ) |
| C | Chanakya (ચાણક્ય) | P | Parshuram (પરશુરામ) |
| D | Durga (દુર્ગા) | Q | Quiver (of Arjun) |
| E | Eklavya (એકલવ્ય) | R | Ram (રામ) |
| F | Falcon (Jatayu - જટાયુ) | S | Shiva (શિવ) |
| G | Ganesh (ગણેશ) | T | Trishul (ત્રિશૂલ) |
| H | Hanuman (હનુમાન) | U | Uma (ઉમા) |
| I | Indra (ઇન્દ્ર) | V | Vishnu (વિષ્ણુ) |
| J | Janaki/Sita (જાનકી) | W | Warrior (Karna - કર્ણ) |
| K | Krishna (કૃષ્ણ) | X | Xbow (Dhanush - ધનુષ) |
| L | Lakshmi (લક્ષ્મી) | Y | Yudhishthir (યુધિષ્ઠિર) |
| M | Meera (મીરા) | Z | Zenith (Sumeru - સુમેરુ) |

> Note: Final mapping to be reviewed with content team. Some letters (Q, X, Z) use creative associations.

**Learning Outcomes:**
- Letter recognition (uppercase, lowercase)
- Letter-sound association (phonics)
- Basic word formation
- Indian cultural awareness through mythology

### 2.4 Module 3 — Gujarati Jungle (ગુજરાતી બારાખડી)

Teaches Gujarati script — vowels, consonants, and Barakhadi.

| Feature | Description | Difficulty Levels |
|---------|-------------|-------------------|
| Vowel (સ્વર) Learning | Learn અ, આ, ઇ, ઈ, ઉ, ઊ, એ, ઐ, ઓ, ઔ, અં, અઃ with audio + animation | One vowel at a time → All vowels quiz |
| Row-by-row Barakhadi | Tap-to-hear each character in Barakhadi grid (ક કા કિ કી કુ કૂ કે કૈ કો કૌ કં કઃ) | Row 1 (ક row) → All rows progressively |
| Character Tracing | Trace Gujarati characters with sparkle trail feedback | Simple characters (ક, ખ) → Complex (ક્ષ, જ્ઞ) |
| Listen & Tap | Hear a character pronunciation, tap the correct one from options | 4 options → full grid selection |
| Barakhadi Bingo | Bingo-style game with Barakhadi characters | Small 3x3 grid → full 5x5 grid |
| Voice Repeat | Speak into mic, basic pronunciation feedback | Single characters → Full words |
| Syllable to Word | Match Gujarati syllables to form complete words | 2-syllable words → 3+ syllable words |

**Learning Outcomes:**
- Gujarati vowel (સ્વર) recognition
- Gujarati consonant (વ્યંજન) recognition
- Full Barakhadi reading
- Basic Gujarati word formation
- Pronunciation practice

### 2.5 Module 4 — Maths Kingdom (+ − × ÷)

Teaches basic arithmetic through visual and interactive games.

| Feature | Description | Difficulty Levels |
|---------|-------------|-------------------|
| Visual Block Addition | Add blocks visually (2 blocks + 3 blocks = ?) | Single digit (Nursery-KG) → Double digit (Class 2-4) |
| Visual Subtraction | Remove blocks to subtract | Single digit → Double digit |
| Share the Candies | Division through candy sharing game (12 candies ÷ 3 friends) | Simple (÷2, ÷3) → Complex (÷ any single digit) |
| Times Table Chant | Rhythmic musical chant for multiplication tables | Tables 2-5 (Class 2) → Tables 2-12 (Class 3-4) |
| Spin & Solve Wheel | Spin a wheel, solve the math problem that appears | Addition only → Mixed all 4 operations |
| Math Duel | Race against a cartoon character to solve problems | Easy (single operation) → Hard (mixed, timed) |
| Treasure Chest | Answer correctly to unlock treasure with surprise rewards | Mixed difficulty, progressive |

**Learning Outcomes:**
- Addition and subtraction (single and double digit)
- Multiplication tables (2-12)
- Basic division concepts
- Mental math speed

---

## 3. Daily Challenge Mode

| Feature | Description |
|---------|-------------|
| Daily Quiz | 5-question mixed quiz pulling from all unlocked modules |
| Weekend Mega Game | 10 questions on Saturday/Sunday with bonus points |
| Streak Tracking | Track consecutive days of completing daily challenge |

---

## 4. Parent Dashboard (PIN-locked)

Accessible via a separate PIN-protected section within the app.

| Feature | Description |
|---------|-------------|
| Time Spent Report | Bar/pie chart showing time spent per subject |
| Weak Areas Report | Highlight topics where child scores below threshold |
| Progress Chart | Daily/weekly progress visualization |
| Screen Time Limits | Set daily usage limits (e.g., 30 min, 1 hour) |
| Module Control | Enable/disable specific modules |
| Language Preference | Toggle instruction language: Gujarati / English / Hindi |
| Child Profile Management | Edit child name, age, class, avatar |

---

## 5. Settings & Personalization

| Feature | Description |
|---------|-------------|
| Avatar Selection | Pick avatar + enter name on first launch |
| Pet Companion | Choose a companion pet (future: pet evolution with rewards) |
| Font Size Control | Adjustable for readability |
| Sound ON/OFF | Toggle sound effects and audio |
| Language Toggle | Gujarati / English / Hindi for instruction audio and text |
| Offline Mode | All core content works without internet; syncs when connected |

---

## 6. Backend Architecture

### 6.1 Tech Stack

| Layer | Technology |
|-------|------------|
| Mobile App | Flutter (Dart) — Android + iOS |
| Backend API | Node.js (Express.js) |
| Database | PostgreSQL |
| Admin Panel | React.js (web-based) |
| Authentication | JWT + OTP (phone/email) |
| File Storage | AWS S3 or equivalent (audio files, images, illustrations) |
| Offline Storage | Hive or SQLite (local DB in Flutter for offline mode) |

### 6.2 Authentication Flow

```
Parent Registration:
  Phone/Email → OTP Verification → Create Account → Set PIN

Child Profile:
  Parent creates child profile → Name, Age, Class, Avatar selection

App Login:
  Phone/Email + OTP → Select Child Profile → Enter App
```

### 6.3 API Modules

| API Module | Key Endpoints |
|------------|---------------|
| **Auth** | Register, Login (OTP), Verify OTP, Refresh Token |
| **User/Profile** | Create/Update parent profile, Create/Update/Delete child profiles |
| **Progress** | Save progress, Get progress, Sync offline progress |
| **Content** | Get modules, Get lessons, Get questions, Get media URLs |
| **Daily Challenge** | Get today's challenge, Submit answers, Get streak |
| **Settings** | Update preferences, Set screen time limits |

### 6.4 Database Schema (High-Level)

```
parents
  - id, name, email, phone, password_hash, pin, created_at

children
  - id, parent_id, name, age, class, avatar, pet, created_at

modules
  - id, name, slug, description, icon, order

lessons
  - id, module_id, title, difficulty_level, class_range, content_json

questions
  - id, lesson_id, type, question_data, correct_answer, media_urls

progress
  - id, child_id, lesson_id, score, stars, completed, completed_at

daily_challenges
  - id, date, questions (JSON array of question_ids)

daily_challenge_attempts
  - id, child_id, challenge_id, score, completed_at

streaks
  - id, child_id, current_streak, longest_streak, last_active_date

settings
  - id, child_id, language, sound_enabled, font_size, screen_time_limit
```

### 6.5 Admin Panel Features

| Feature | Description |
|---------|-------------|
| Dashboard | Total users, active users, engagement metrics |
| User Management | View all parents/children, filter by age/class/location |
| Content Management | Add/edit/delete modules, lessons, questions, media |
| Analytics | Module-wise engagement, completion rates, popular content |
| Reports | Export user data, progress reports |

---

## 7. Design Guidelines

### 7.1 Visual Style
- Bright, playful colors (primary palette: vibrant blue, orange, green, purple)
- Large tap targets (minimum 48x48dp) for small fingers
- Rounded bold fonts: **Baloo** (English), **Noto Sans Gujarati** (Gujarati)
- Gujarati cultural themes: kites, garba dancers, rangoli, matki, peacock
- Hindu mythology illustrations for ABC module
- No text-heavy screens — icons + audio do the talking

### 7.2 UX Principles
- Portrait lock only
- Phone + tablet responsive layouts
- Maximum 2 taps to reach any game from home screen
- Audio instructions for every screen (child may not read)
- Immediate positive feedback on correct answers
- Gentle encouragement on wrong answers (no negative sounds)
- Large, clear back/home navigation buttons

### 7.3 Accessibility
- Audio-first design (children may not read)
- High contrast between text and background
- Adjustable font sizes
- Haptic feedback on interactions

---

## 8. Non-Functional Requirements

| Requirement | Specification |
|-------------|---------------|
| **Offline Support** | Core content (lessons, games, audio) available offline. Progress syncs when online. |
| **Performance** | App launch < 3 seconds, game load < 1 second |
| **App Size** | Initial download < 100 MB (additional content downloaded on demand) |
| **Security** | Parent PIN protection, JWT auth, encrypted data at rest, COPPA-aware design |
| **Localization** | Support 3 languages: Gujarati, English, Hindi (for instructions/UI) |
| **Analytics** | Track module usage, session duration, completion rates (server-side) |

---

## 9. Build Roadmap

### Phase 1 — MVP (3 months)
- World Map home screen (static, all lands visible)
- Number Land (1-20, basic games: animated learning, count objects, missing number)
- ABC Forest (A-Z with mythology mapping, letter tracing, word + image + sound)
- Parent PIN setup + basic progress view
- User registration (phone + OTP)
- Backend API (auth, profiles, basic progress)
- Offline mode for bundled content
- Android + iOS builds

### Phase 2 — v1.1 (2 months)
- Gujarati Jungle (vowels + first 5 consonant rows of Barakhadi)
- Voice repeat challenge
- Number Land expansion (1-50, odd/even, number train)
- Daily Challenge mode
- Admin Panel v1 (user management, basic analytics)

### Phase 3 — v1.2 (2 months)
- Maths Kingdom (addition + subtraction, visual blocks)
- Full Barakhadi completion
- CMS for content management
- Parent Dashboard (full reports, screen time limits)
- Admin Panel v2 (content management, reports)

### Phase 4 — v2.0 (2 months)
- Maths Kingdom expansion (multiplication, division, times table chant)
- Gamification system (stars, badges, streaks, trophies)
- Pet companion system (evolution, dress up)
- Weekend mega challenges
- Performance optimization and polish

---

## 10. Future Scope (Post v2.0)

- Hindi alphabet module (हिंदी बारहखड़ी)
- Science module (basic science concepts)
- GK (General Knowledge) quiz module
- Story time (animated Indian mythology stories)
- Multiplayer mode (challenge friends)
- Leaderboard (class/school level)
- Teacher dashboard (for schools)
- Ad-supported model or premium features (if monetization needed)
- Push notifications for daily reminders
- Widgets for quick daily challenge access

---

## 11. Success Metrics

| Metric | Target |
|--------|--------|
| Daily Active Users (DAU) | 1,000+ within 3 months of launch |
| Session Duration | Average 15-20 minutes per session |
| Module Completion Rate | > 60% of started modules completed |
| Parent Dashboard Usage | > 30% of parents check weekly |
| App Store Rating | > 4.2 stars |
| Retention (Day 7) | > 40% |
| Retention (Day 30) | > 20% |

---

## Appendix A: Glossary

| Term | Meaning |
|------|---------|
| Barakhadi (બારાખડી) | Gujarati alphabet chart combining consonants with vowel marks |
| Svar (સ્વર) | Gujarati vowels |
| Vyanjan (વ્યંજન) | Gujarati consonants |
| OTP | One-Time Password for phone/email verification |
| CMS | Content Management System |
| COPPA | Children's Online Privacy Protection Act |

---

*Document created: 2026-02-27*
*Last updated: 2026-02-27*
