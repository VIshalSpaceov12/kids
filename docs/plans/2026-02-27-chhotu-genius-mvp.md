# Chhotu Genius MVP Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the MVP of Chhotu Genius — a kids' educational Flutter app with Node.js backend and React admin panel.

**Architecture:** Three independent tracks running in parallel: (1) Flutter mobile app with offline-first architecture, (2) Node.js/Express REST API with PostgreSQL, (3) React admin panel. The Flutter app works standalone with local data for MVP, syncing to backend when available.

**Tech Stack:** Flutter/Dart, Node.js/Express, PostgreSQL, React.js, JWT auth, Hive (local DB)

---

## Team Structure (3 Parallel Tracks)

| Track | Role | Scope |
|-------|------|-------|
| **Track 1** | Flutter Developer | Mobile app — project setup, architecture, all screens & modules |
| **Track 2** | Backend Developer | Node.js API — auth, profiles, content, progress APIs + DB |
| **Track 3** | Frontend Developer | React admin panel — user mgmt, content mgmt, analytics |

All 3 tracks start simultaneously. Track 1 uses local/mock data initially, integrates with Track 2 API later.

---

## Track 1: Flutter Mobile App

### Task 1.1: Flutter Project Setup

**Files:**
- Create: `chhotu_genius/` (Flutter project root)
- Create: `chhotu_genius/lib/main.dart`
- Create: `chhotu_genius/pubspec.yaml`

**Step 1: Create Flutter project**
```bash
cd /Users/sotsys336/Documents/Projects/Kids
flutter create chhotu_genius --org com.chhotugenius --platforms android,ios
```

**Step 2: Add core dependencies to pubspec.yaml**
```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0
  provider: ^6.1.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  google_fonts: ^6.2.0
  audioplayers: ^6.0.0
  flutter_svg: ^2.0.0
  lottie: ^3.0.0
  shared_preferences: ^2.2.0
  http: ^1.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.0
  build_runner: ^2.4.0
  flutter_lints: ^4.0.0
```

**Step 3: Run flutter pub get**
```bash
cd chhotu_genius && flutter pub get
```

**Step 4: Commit**
```bash
git init && git add . && git commit -m "chore: initialize Flutter project with dependencies"
```

---

### Task 1.2: App Architecture & Folder Structure

**Files:**
- Create: `lib/app.dart` — MaterialApp with GoRouter
- Create: `lib/core/theme/app_theme.dart` — Colors, typography, theme data
- Create: `lib/core/theme/app_colors.dart` — Color constants
- Create: `lib/core/constants/app_constants.dart` — App-wide constants
- Create: `lib/core/utils/audio_helper.dart` — Audio playback utility
- Create: `lib/data/models/child_profile.dart` — Child profile model
- Create: `lib/data/models/module_model.dart` — Module data model
- Create: `lib/data/models/progress_model.dart` — Progress tracking model
- Create: `lib/data/local/hive_service.dart` — Local DB service
- Create: `lib/data/providers/profile_provider.dart` — Profile state
- Create: `lib/data/providers/progress_provider.dart` — Progress state
- Create: `lib/features/onboarding/` — Onboarding screens
- Create: `lib/features/home/` — World map home
- Create: `lib/features/number_land/` — Number module
- Create: `lib/features/abc_forest/` — ABC module
- Create: `lib/features/parent/` — Parent dashboard
- Create: `lib/features/settings/` — Settings screens

**Step 1: Create folder structure and core files**

Create `lib/core/theme/app_colors.dart`:
```dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary palette - bright & playful
  static const Color primaryBlue = Color(0xFF4A90D9);
  static const Color primaryOrange = Color(0xFFFF8C42);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryPurple = Color(0xFF9C27B0);

  // Module colors
  static const Color numberLand = Color(0xFFFF6B6B);     // Red-coral
  static const Color abcForest = Color(0xFF4CAF50);       // Green
  static const Color gujaratiJungle = Color(0xFFFF9800);  // Orange
  static const Color mathsKingdom = Color(0xFF2196F3);    // Blue

  // UI colors
  static const Color background = Color(0xFFFFF8E1);      // Warm cream
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF757575);
  static const Color correctGreen = Color(0xFF66BB6A);
  static const Color wrongRed = Color(0xFFEF5350);
  static const Color starGold = Color(0xFFFFD700);
}
```

Create `lib/core/theme/app_theme.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        background: AppColors.background,
      ),
      textTheme: GoogleFonts.balooTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
```

Create `lib/app.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/welcome_screen.dart';
import 'features/home/screens/world_map_screen.dart';
import 'features/number_land/screens/number_land_screen.dart';
import 'features/abc_forest/screens/abc_forest_screen.dart';
import 'features/parent/screens/parent_dashboard_screen.dart';

class ChhotuGeniusApp extends StatelessWidget {
  const ChhotuGeniusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chhotu Genius',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }

  static final _router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/home', builder: (_, __) => const WorldMapScreen()),
      GoRoute(path: '/number-land', builder: (_, __) => const NumberLandScreen()),
      GoRoute(path: '/abc-forest', builder: (_, __) => const AbcForestScreen()),
      GoRoute(path: '/parent', builder: (_, __) => const ParentDashboardScreen()),
    ],
  );
}
```

**Step 2: Create data models**

Create `lib/data/models/child_profile.dart`:
```dart
import 'package:hive/hive.dart';

part 'child_profile.g.dart';

@HiveType(typeId: 0)
class ChildProfile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  String classLevel; // "nursery", "kg", "class1", "class2", "class3", "class4"

  @HiveField(3)
  String avatar;

  @HiveField(4)
  String pet;

  @HiveField(5)
  String language; // "en", "gu", "hi"

  ChildProfile({
    required this.name,
    required this.age,
    required this.classLevel,
    this.avatar = 'default',
    this.pet = 'cat',
    this.language = 'en',
  });
}
```

**Step 3: Commit**
```bash
git add . && git commit -m "feat: add app architecture, theme, routing, and data models"
```

---

### Task 1.3: Onboarding Flow

**Files:**
- Create: `lib/features/onboarding/screens/welcome_screen.dart`
- Create: `lib/features/onboarding/screens/name_input_screen.dart`
- Create: `lib/features/onboarding/screens/class_select_screen.dart`
- Create: `lib/features/onboarding/screens/avatar_select_screen.dart`
- Create: `lib/features/onboarding/widgets/class_card.dart`
- Create: `lib/features/onboarding/widgets/avatar_card.dart`

Build a 4-step onboarding:
1. Welcome screen with app logo + "Let's Start!" button
2. Enter child's name (large text field, friendly keyboard)
3. Select class (Nursery, KG, Class 1-4) as tappable cards
4. Pick avatar from 6 cartoon character options

Each screen: large visuals, minimal text, bright colors, 48dp+ touch targets.

**Commit:** `feat: add onboarding flow with name, class, and avatar selection`

---

### Task 1.4: World Map Home Screen

**Files:**
- Create: `lib/features/home/screens/world_map_screen.dart`
- Create: `lib/features/home/widgets/land_card.dart`
- Create: `lib/features/home/widgets/pet_companion.dart`

Build the World Map as a scrollable screen with 4 large, colorful land cards:
- Number Land (red-coral, number icons)
- ABC Forest (green, letter icons)
- Gujarati Jungle (orange, Gujarati script icons)
- Maths Kingdom (blue, math symbols)

Each card: rounded corners, gradient background, progress indicator, tap to navigate.
Top bar: child name + avatar. Bottom: settings gear icon.

**Commit:** `feat: add world map home screen with 4 module land cards`

---

### Task 1.5: Number Land — Animated Number Learning

**Files:**
- Create: `lib/features/number_land/screens/number_land_screen.dart`
- Create: `lib/features/number_land/screens/number_learning_screen.dart`
- Create: `lib/features/number_land/widgets/number_card.dart`
- Create: `lib/features/number_land/widgets/animated_number.dart`
- Create: `lib/features/number_land/data/number_data.dart`

Number Land hub: shows available games as cards.
Number Learning screen: grid of numbers (1-10/20/50/100 based on class), tap a number to see:
- Large animated number
- Object count visualization (e.g., 5 apples)
- Audio pronunciation (English + Gujarati)
- Swipe left/right for next/previous

**Commit:** `feat: add Number Land with animated number learning`

---

### Task 1.6: Number Land — Count Objects Game

**Files:**
- Create: `lib/features/number_land/screens/count_objects_screen.dart`
- Create: `lib/features/number_land/widgets/counting_objects.dart`
- Create: `lib/features/number_land/widgets/answer_buttons.dart`

Show random objects (fruits, animals, stars) on screen. Child counts and taps the correct number from 4 options. Correct = confetti + cheerful sound. Wrong = gentle "try again" encouragement. Progressive: start with 1-5, increase based on score.

**Commit:** `feat: add count objects game to Number Land`

---

### Task 1.7: Number Land — Missing Number Puzzle

**Files:**
- Create: `lib/features/number_land/screens/missing_number_screen.dart`
- Create: `lib/features/number_land/widgets/number_sequence.dart`

Show a number sequence with one blank (e.g., 3, 4, __, 6). Child picks correct number from options. Start with sequences of 3, progress to 10. Audio feedback on selection.

**Commit:** `feat: add missing number puzzle to Number Land`

---

### Task 1.8: ABC Forest — Mythology Letter Learning

**Files:**
- Create: `lib/features/abc_forest/screens/abc_forest_screen.dart`
- Create: `lib/features/abc_forest/screens/letter_learning_screen.dart`
- Create: `lib/features/abc_forest/widgets/letter_card.dart`
- Create: `lib/features/abc_forest/widgets/mythology_card.dart`
- Create: `lib/features/abc_forest/data/mythology_alphabet.dart`

ABC Forest hub with game cards. Letter Learning screen: grid of A-Z letters.
Tap a letter to see:
- Large animated letter (uppercase + lowercase)
- Hindu mythology character illustration (A = Arjun, B = Bheem, etc.)
- Character name in English + Gujarati
- Audio pronunciation
- Short fun fact about the character

Data file contains full A-Z mythology mapping with character names, descriptions, and image asset paths.

**Commit:** `feat: add ABC Forest with Hindu mythology letter learning`

---

### Task 1.9: ABC Forest — Letter Tracing

**Files:**
- Create: `lib/features/abc_forest/screens/letter_tracing_screen.dart`
- Create: `lib/features/abc_forest/widgets/tracing_canvas.dart`

Custom painter-based letter tracing:
- Show letter outline with numbered starting points
- Child traces with finger
- Visual feedback trail (sparkle/color fill as they trace)
- Accuracy check (doesn't need to be pixel-perfect for kids)
- "Great job!" celebration on completion

**Commit:** `feat: add letter tracing with finger tracking to ABC Forest`

---

### Task 1.10: Parent PIN & Basic Progress

**Files:**
- Create: `lib/features/parent/screens/pin_setup_screen.dart`
- Create: `lib/features/parent/screens/pin_entry_screen.dart`
- Create: `lib/features/parent/screens/parent_dashboard_screen.dart`
- Create: `lib/features/parent/widgets/progress_chart.dart`
- Create: `lib/features/parent/widgets/module_time_card.dart`

PIN setup during onboarding (4-digit). PIN entry gate before parent section.
Dashboard shows:
- Time spent per module (bar chart)
- Lessons completed count
- Current class/level
- Language toggle

**Commit:** `feat: add parent PIN lock and basic progress dashboard`

---

## Track 2: Node.js Backend API

### Task 2.1: Backend Project Setup

**Files:**
- Create: `backend/` project root
- Create: `backend/package.json`
- Create: `backend/src/index.js`
- Create: `backend/.env.example`
- Create: `backend/src/config/database.js`
- Create: `backend/src/config/env.js`

**Step 1: Initialize Node.js project**
```bash
cd /Users/sotsys336/Documents/Projects/Kids
mkdir backend && cd backend
npm init -y
npm install express pg knex cors helmet dotenv jsonwebtoken bcryptjs joi express-rate-limit
npm install -D nodemon
```

**Step 2: Create entry point** `src/index.js`:
```javascript
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const authRoutes = require('./routes/auth');
const profileRoutes = require('./routes/profiles');
const contentRoutes = require('./routes/content');
const progressRoutes = require('./routes/progress');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(rateLimit({ windowMs: 15 * 60 * 1000, max: 100 }));

app.use('/api/auth', authRoutes);
app.use('/api/profiles', profileRoutes);
app.use('/api/content', contentRoutes);
app.use('/api/progress', progressRoutes);

app.get('/health', (req, res) => res.json({ status: 'ok' }));

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
```

**Step 3: Create database config** `src/config/database.js`:
```javascript
const knex = require('knex');
require('dotenv').config();

module.exports = knex({
  client: 'pg',
  connection: {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || 'chhotu_genius',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
  },
  pool: { min: 2, max: 10 },
});
```

**Step 4: Commit**
```bash
git add . && git commit -m "chore: initialize Node.js backend with Express"
```

---

### Task 2.2: Database Schema & Migrations

**Files:**
- Create: `backend/migrations/001_create_parents.js`
- Create: `backend/migrations/002_create_children.js`
- Create: `backend/migrations/003_create_modules.js`
- Create: `backend/migrations/004_create_lessons.js`
- Create: `backend/migrations/005_create_questions.js`
- Create: `backend/migrations/006_create_progress.js`
- Create: `backend/migrations/007_create_settings.js`
- Create: `backend/seeds/001_modules.js`

Create Knex migrations for all tables from PRD schema. Seed modules table with 4 initial modules (Number Land, ABC Forest, Gujarati Jungle, Maths Kingdom).

**Commit:** `feat: add database migrations and seed data`

---

### Task 2.3: Auth API (Register, OTP, Login)

**Files:**
- Create: `backend/src/routes/auth.js`
- Create: `backend/src/controllers/authController.js`
- Create: `backend/src/middleware/auth.js` — JWT verification middleware
- Create: `backend/src/utils/otp.js` — OTP generation (mock for MVP)

Endpoints:
- `POST /api/auth/register` — phone/email + name → generate OTP
- `POST /api/auth/verify-otp` — verify OTP → return JWT
- `POST /api/auth/refresh` — refresh JWT token
- `POST /api/auth/set-pin` — set 4-digit parent PIN

For MVP: OTP is always "1234" (mock). Real OTP service integrated later.

**Commit:** `feat: add auth API with register, OTP verify, and JWT`

---

### Task 2.4: Profile API (Parent + Child)

**Files:**
- Create: `backend/src/routes/profiles.js`
- Create: `backend/src/controllers/profileController.js`

Endpoints:
- `GET /api/profiles/me` — get parent profile
- `PUT /api/profiles/me` — update parent profile
- `POST /api/profiles/children` — create child profile
- `GET /api/profiles/children` — list children
- `PUT /api/profiles/children/:id` — update child
- `DELETE /api/profiles/children/:id` — delete child

All routes require JWT auth middleware.

**Commit:** `feat: add profile API for parent and child management`

---

### Task 2.5: Content API (Modules, Lessons, Questions)

**Files:**
- Create: `backend/src/routes/content.js`
- Create: `backend/src/controllers/contentController.js`
- Create: `backend/seeds/002_number_land_content.js`
- Create: `backend/seeds/003_abc_forest_content.js`

Endpoints:
- `GET /api/content/modules` — list all modules
- `GET /api/content/modules/:slug/lessons` — get lessons for module
- `GET /api/content/lessons/:id/questions` — get questions for lesson

Seed Number Land and ABC Forest with initial content data.

**Commit:** `feat: add content API with modules, lessons, and questions`

---

### Task 2.6: Progress API

**Files:**
- Create: `backend/src/routes/progress.js`
- Create: `backend/src/controllers/progressController.js`

Endpoints:
- `POST /api/progress` — save lesson progress (child_id, lesson_id, score, stars)
- `GET /api/progress/:childId` — get all progress for a child
- `GET /api/progress/:childId/module/:moduleId` — get module-specific progress
- `POST /api/progress/sync` — bulk sync offline progress

**Commit:** `feat: add progress API with sync support`

---

## Track 3: React Admin Panel

### Task 3.1: Admin Panel Project Setup

**Files:**
- Create: `admin/` project root (Vite + React + TypeScript)

**Step 1: Create React project**
```bash
cd /Users/sotsys336/Documents/Projects/Kids
npm create vite@latest admin -- --template react-ts
cd admin
npm install react-router-dom @tanstack/react-query axios tailwindcss @headlessui/react recharts
npm install -D @types/react @types/react-dom
```

**Step 2: Setup Tailwind CSS**

**Step 3: Create folder structure**
```
admin/src/
  components/    — Shared UI components
  pages/         — Page components
  layouts/       — Admin layout with sidebar
  services/      — API service layer
  hooks/         — Custom hooks
  types/         — TypeScript types
```

**Commit:** `chore: initialize React admin panel with Vite + Tailwind`

---

### Task 3.2: Admin Auth & Layout

**Files:**
- Create: `admin/src/layouts/AdminLayout.tsx` — Sidebar + header + content area
- Create: `admin/src/pages/LoginPage.tsx`
- Create: `admin/src/services/api.ts` — Axios instance with JWT
- Create: `admin/src/hooks/useAuth.ts`

Admin login with email + password (separate from parent auth).
Sidebar navigation: Dashboard, Users, Content, Analytics.
Protected routes — redirect to login if no token.

**Commit:** `feat: add admin auth and layout with sidebar navigation`

---

### Task 3.3: User Management Page

**Files:**
- Create: `admin/src/pages/UsersPage.tsx`
- Create: `admin/src/components/UserTable.tsx`
- Create: `admin/src/components/UserDetailModal.tsx`

Table view of all parents + children. Columns: name, email/phone, children count, last active, registration date. Click row to see parent details + their children profiles + progress summary. Filter by class level, search by name/phone.

**Commit:** `feat: add user management page with search and filters`

---

### Task 3.4: Content Management Page

**Files:**
- Create: `admin/src/pages/ContentPage.tsx`
- Create: `admin/src/components/ModuleList.tsx`
- Create: `admin/src/components/LessonEditor.tsx`
- Create: `admin/src/components/QuestionEditor.tsx`

Left sidebar: module list. Click module → shows lessons. Click lesson → shows questions.
CRUD operations for lessons and questions. Question editor supports:
- Multiple choice (4 options)
- Fill in the blank
- Ordering
- Image upload for question assets

**Commit:** `feat: add content management with lesson and question editors`

---

### Task 3.5: Dashboard & Analytics Page

**Files:**
- Create: `admin/src/pages/DashboardPage.tsx`
- Create: `admin/src/components/StatsCard.tsx`
- Create: `admin/src/components/ActivityChart.tsx`
- Create: `admin/src/components/ModuleEngagementChart.tsx`

Dashboard shows:
- Total users, active today, new this week (stat cards)
- Daily active users chart (line chart, last 30 days)
- Module engagement breakdown (pie chart)
- Recent registrations list

**Commit:** `feat: add admin dashboard with analytics charts`

---

## Integration Tasks (After Parallel Tracks)

### Task 4.1: Connect Flutter App to Backend API

**Files:**
- Create: `chhotu_genius/lib/data/remote/api_service.dart`
- Create: `chhotu_genius/lib/data/remote/auth_service.dart`
- Modify: `chhotu_genius/lib/data/providers/profile_provider.dart`
- Modify: `chhotu_genius/lib/data/providers/progress_provider.dart`

Wire up Flutter app to use backend API:
- Registration/login flow with OTP
- Sync progress on app open / lesson complete
- Fallback to local Hive DB when offline

**Commit:** `feat: integrate Flutter app with backend API`

---

### Task 4.2: End-to-End Testing

Test complete flows:
1. Register parent → create child → select class → enter app
2. Complete a Number Land lesson → progress saved to backend
3. Open parent dashboard → see progress
4. Admin panel → see user + progress data
5. Offline mode → complete lesson → come online → sync

**Commit:** `test: add end-to-end flow tests`

---

*Plan created: 2026-02-27*
