# ⚔️ Lexora (English Arena)

[![Flutter](https://img.shields.io/badge/Flutter-3.29.3-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7.2-0175C2?logo=dart)](https://dart.dev)
[![Database](https://img.shields.io/badge/SQLite-Drift%202.22-003B57?logo=sqlite)](https://drift.simonbinder.eu)
[![State Management](https://img.shields.io/badge/State-Riverpod%202.6-blue)](https://riverpod.dev)
[![Offline](https://img.shields.io/badge/Network-100%25%20Offline-success)](https://github.com/Rebira678/Lexora)
[![Tests](https://img.shields.io/badge/Tests-89%2F89%20Passing-brightgreen)](https://github.com/Rebira678/Lexora)
[![License](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

> **A high-intensity, distraction-free English acquisition engine designed to convert action-game habits into fluent English vocabulary and complex long-sentence mastery.**

Lexora is built from the ground up to feel like a **satisfying game, not a school app**. It operates **100% offline** with zero internet permissions, zero ads, zero tracking, and local-first data storage powered by SQLite and Drift.

---

## 🎯 Core Features

### 1. ⚔️ Word Siege (Flagship Action Game)
- **3-Lane Defense:** Enemy word cards march toward your gate. Defeat them before they breach!
- **Typing & Tap Modes:** Typing mode for intermediate to advanced learners, tap mode (4 option buttons) for warm-up or beginner levels.
- **Dynamic Pacing:** Walking speed and spawn intervals automatically adapt to your rolling accuracy ($0.75$–$0.85$ target sweet spot).
- **Power-Ups (Earned in battle):**
  - ❄️ **Freeze (Combo x5):** Stops enemy march for 4 seconds.
  - 🔊 **Echo (Combo x8):** Plays audio clue for the front enemy (Levels 1–4; disabled in C1 master mode).
  - 💥 **Bomb (Combo x12):** Clears an entire lane and re-queues cleared words into Wave 3.
- **Wave 3 Boss:** Confronts you with a complex multi-clause sentence containing 2 masked keywords and awards a 3x base score bonus.
- **Anti-Frustration Rule:** After 2 gate breaches in a single wave, the game gently pauses with a *"Take a breath"* prompt and offers Tap Mode.
- **Spelling Tolerance:** Accepts US and UK spelling variants (*colour/color*, *realise/realize*, *theatre/theater*, *defence/defense*) and provides Levenshtein tolerance for minor slips at lower levels.

### 2. 🎡 Anagram Wheel
- **Fluid Gesture Trail:** Swipe across circular letter nodes or tap tiles to construct words.
- **🌟 Mega Word Bonus:** Finding long words ($\ge 6$ letters) or utilizing all letters awards bonus points, bonus XP, and a special celebration banner.
- **10-Second Clue Reveal:** Automatically reveals an English definition clue if you are stuck after 10 seconds.
- **Post-Round Review:** Every round displays all discovered and missed words with IPA pronunciation and English definitions.

### 3. ⚡ Vocabulary Sprint
- **SRS-Driven Rapid Fire:** Pulls due review cards from your local SM-2 database first.
- **5 Game Modes:** `Meaning → Word`, `Word → Meaning`, `Sentence Gap`, `Synonym Strike`, and `Antonym / Contrast`.
- **Lives & Speed Multipliers:** 3 hearts; answers under 3 seconds receive a $1.5\times$ multiplier ($1.2\times$ for under 6 seconds).

### 4. 🧱 Sentence Unscrambler
- **Clause Inversion Engine:** Supports dual valid orderings across comma and connector boundaries when English syntax allows.
- **Interactive Audio Feedback:** Tap individual tiles to hear pronunciation; plays complete fluent audio upon successful completion.
- **"Why?" Grammar Modal:** One-tap contextual explanation breaking down subject, predicate, and clause roles.
- **One-Tap Reset:** Clears assembled tiles back to the bank instantly.

### 5. 🏠 Home Dashboard & Habit System
- **Implementation-Intention Anchor:** Editable and persistent daily habit cue (e.g. *"When I finish breakfast, I will play 10 minutes."*) saved to disk.
- **Streak Flame & Shield:** Displays current consecutive days, total days played, and available streak freezes (earned every 7 consecutive days, capped at 3).
- **One-Tap Mission Launcher:** Launches today's personalized 5-step daily mission directly.
- **XP & Rank Progression:** Real-time level progress bar tracking progression from *Novice Scout* to *Grandmaster*.

### 6. 📓 Mistake Gym & Notebook
- **Mistake Gym:** Immediate targeted practice for words with low SM-2 recall qualities or high lapse counts.
- **Saved Words:** Star and save words from any game session directly into your personal notebook.

### 7. 📊 Learning Analytics & Settings
- **Stats Hub:** CEFR tier estimate, XP milestones, historical streak calendar, and game session logs.
- **Offline Reminder Scheduler:** Configure daily nudges without background battery drain or cloud dependency.
- **Audio Tuning:** Adjust native TTS speech rate ($0.5\times$ to $1.2\times$) for listening comfort.

---

## 🏗️ Architecture & Tech Stack

```
lib/
├── app/
│   ├── providers.dart         # Global Riverpod providers & dependency injection
│   ├── router.dart            # Declarative GoRouter routing definitions
│   └── theme.dart             # Dark / light theme, accessible color palette
├── core/
│   ├── audio/                 # JustAudio (SFX) & FlutterTTS (pronunciation)
│   ├── db/                    # Drift SQLite database, tables, DAOs & importer
│   ├── notifications/        # flutter_local_notifications scheduler
│   ├── planner/               # Daily mission generator & difficulty auto-tuner
│   ├── scoring/               # Scoring formulas, typo tolerance & US/UK normalizer
│   ├── srs/                   # SuperMemo SM-2 interval scheduler
│   └── streak/                # Streak logic with freeze tokens & comeback mode
└── features/
    ├── games/                 # Word Siege, Anagram Wheel, Sprint, Unscrambler
    ├── home/                  # Home dashboard & habit intention
    ├── mistakes/              # Mistake Gym & Saved Words notebook
    ├── settings/              # Offline settings & speech rate slider
    └── stats/                 # Analytics & rank tiers
```

---

## 🧪 Automated Test Suite

Lexora includes an extensive automated test suite covering all algorithmic edge cases, database transactions, and UI flows:

```bash
flutter test
```

**89 / 89 tests passing (100%):**
- ✅ `SM-2 Core Algorithm` (Interval geometric growth, ease factor clamping $1.3$–$3.0$, lapse resets)
- ✅ `Word Siege Mechanics` (SM-2 quality table mapping, pace scaling, power-ups, lane bomb, boss scoring)
- ✅ `Spelling Variants & Tolerance` (US/UK spelling pairs, Levenshtein tolerance, accepted forms)
- ✅ `Streak & Freeze Logic` (Consecutive tracking, 7-day milestone freeze awards, comeback protection)
- ✅ `Daily Planner & Cap Logic` (Strict new-word intake caps based on backlog load)
- ✅ `Content Importer` (Validation of all 200 words, 60 sentences, 10 paragraphs, 20 chunks, 5 passages)
- ✅ `UI & Navigation Flows` (Home screen persistence, Mistakes tabs, Stats, Settings)

Static code analysis:
```bash
flutter analyze
# No issues found!
```

---

## 📱 How to Download and Test on Your Phone

You can run or install Lexora on any Android device in a few quick steps.

### Method 1: Build an APK and Transfer to Your Phone (No cable required)

1. **Build the APK:**
   ```bash
   flutter build apk --debug
   ```
   *(Or for an optimized release build: `flutter build apk --release`)*

2. **Locate the APK file:**
   The output APK will be generated at:
   ```
   build/app/outputs/flutter-apk/app-debug.apk
   ```

3. **Transfer to your phone:**
   - Connect your phone via USB and copy `app-debug.apk` to your phone's **Downloads** folder, **OR**
   - Upload `app-debug.apk` to your Google Drive / Telegram / WhatsApp (Saved Messages) and download it directly onto your phone.

4. **Install on phone:**
   - On your phone, tap `app-debug.apk`.
   - If prompted, enable **"Allow from this source"** in your phone settings to install offline apps.
   - Open **Lexora** and start playing!

---

### Method 2: Run Directly via USB / Wireless Debugging (Real-time Hot Reload)

1. **Enable Developer Options on your phone:**
   - Go to **Settings > About Phone**.
   - Tap **Build Number** 7 times until you see *"You are now a developer!"*.
   - In **Settings > Developer Options**, enable **USB Debugging**.

2. **Connect phone to computer:**
   - Plug your phone into your computer with a USB cable.
   - On your phone screen, tap **"Always allow from this computer"** when prompted.

3. **Verify phone detection:**
   ```bash
   flutter devices
   ```
   Your phone model will appear in the device list.

4. **Launch the app:**
   ```bash
   flutter run
   ```
   The app will compile, install, and launch immediately on your phone with live hot reload enabled (`r` to reload, `R` to restart).

---

### Method 3: Instant UI Check on Linux Desktop or Chrome

You can also inspect the UI and all game loops directly on your computer:

```bash
# Run as a native Linux desktop application
flutter run -d linux

# Run inside Google Chrome
flutter run -d chrome
```

---

## 🔒 100% Offline & Privacy Guarantee

- **No Internet Permission:** The Android release manifest contains zero internet permissions (`android.permission.INTERNET` is omitted).
- **Local SQLite Storage:** All player data, progress, and vocabulary items stay strictly on your device.
- **Built-in Speech:** Audio pronunciation utilizes the device's native on-device Text-to-Speech (TTS) engine.
