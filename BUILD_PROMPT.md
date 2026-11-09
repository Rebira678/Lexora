# 🚀 Build Prompt: English Arena (Offline English-Learning Game)

Copy everything below the line into your Claude agent (e.g., Claude Code). Put `app.md` in the project root first.

---

## ROLE

You are a **senior Flutter engineer, game-UX designer and English teacher** working together. You are building a **personal, 100% offline Android app** called **English Arena** for one user (me). It turns English learning into fun, fast games that train **vocabulary** and **long-sentence understanding**, with a goal of **B2 → C1 → C2**.

## SOURCE OF TRUTH

Read **`app.md` completely before writing any code.** It contains the product vision, learning science, game specs, data schema (SQLite), SM-2 code, streak logic, architecture, UX rules and roadmap. If this prompt and `app.md` disagree, **`app.md` wins**, except where this prompt gives a specific build order or tech choice.

Pay special attention to:
- Section 8.4-8.6 (schema, SM-2, streaks)
- Section 9 (architecture)
- Sections 18-23 (vocabulary, long sentences, weak-point games, DB additions, plan, roadmap)
- **Section 24 (three new games: Word Siege, Paragraph Architect, Chunk Echo)**

## NON-NEGOTIABLE RULES

1. **Fully offline.** Do NOT add the `INTERNET` permission. No analytics, no ads, no remote config, no network packages.
2. **Stack:** Flutter (stable), Dart null-safety, **Drift** (SQLite), **Riverpod** (state), **just_audio** for audio, **flutter_tts** as a fallback voice, **flutter_local_notifications** for the daily reminder. Add **Vosk** (offline speech recognition) only in the speaking phase.
3. **Content is data, not code.** Words, sentences, paragraphs and passages live in JSON files under `assets/content/` and are imported into SQLite on first run (with a version number so updates can re-import safely).
4. **Every game round ends with a "What you learned" screen** (words, example sentences, audio button, save-to-Mistake-Notebook toggle).
5. **Mistakes are data.** Wrong answers show the correct answer, a one-line reason, and an example, then get re-queued in the same session and through SRS.
6. **Kind tone.** No guilt or shaming copy anywhere. Use growth-mindset messages from `app.md` section 10.3.
7. **Performance:** 60 fps in games on a mid-range Android phone, cold start under 2.5 s, no work on the UI thread that blocks frames (use isolates for heavy DB imports).
8. **Quality bar:** no placeholder screens, no "TODO" in shipped features, no fake data presented as real. If something is not built yet, it is not in the UI.

## ARCHITECTURE (follow `app.md` section 9.2)

```
lib/
  main.dart
  app/                  # theme, router, DI providers, constants
  core/
    db/                 # Drift tables, DAOs, migrations, importer
    srs/                # SM-2 scheduler (pure Dart, unit tested)
    audio/              # audio service + TTS fallback
    streak/             # streak + freeze + comeback logic
    xp/                 # XP, levels, daily goal
    planner/            # Daily Plan Builder + new-word cap
  features/
    home/               # daily plan, streak, XP, "continue" button
    games/
      anagram_wheel/
      sentence_unscrambler/
      vocab_sprint/
      word_siege/             # NEW
      paragraph_architect/    # NEW
      chunk_echo/             # NEW
      sentence_xray/          # weak-point game
      slice_it/               # weak-point game
    reading/            # passage reader with tap-to-define + "From the wild"
    mistakes/           # Mistake Notebook / Mistake Gym
    stats/              # charts, per-skill CEFR, streak calendar
    settings/           # reminder, difficulty defaults, backup/restore
assets/
  content/              # words.json, sentences.json, paragraphs.json, chunks.json, passages.json
  audio/                # offline audio files (words, sentences)
test/                   # unit + widget tests
```

Each feature has `data/`, `domain/`, `presentation/` folders. Game logic (scoring, difficulty tuning, SM-2 quality mapping) must be **pure Dart classes with unit tests**, separate from widgets.

## BUILD ORDER (work in phases, finish each before the next)

**Do not build everything at once.** After each phase, run the app, run the tests, and give me a short summary of what works and how to try it.

### Phase 0: Foundation
- Create the Flutter project, set up folders, theme (dark + light, one calm accent color, large readable fonts), and routing.
- Implement all Drift tables from `app.md` 8.4, 21.1 and **24.4**, plus the migration setup and a JSON content importer with versioning.
- Implement and **unit test** the SM-2 scheduler, streak logic (with freeze + comeback mode), XP/levels, and the new-word cap (`app.md` 21.2).
- Seed content: write a small but real starter set (**200 words** with example sentences, **60 sentences** across levels 1-6, **10 paragraphs**, **20 chunk sentences**, **5 passages**). Mark clearly that it is starter content and keep files in the documented JSON formats so I can add more.

### Phase 1: MVP (replace the action game)
Build these with full polish (animations, haptics, sound hooks, "What you learned" screen):
1. **Anagram Wheel** (`app.md` 5.1)
2. **Sentence Unscrambler** (`app.md` 5.1)
3. **Vocabulary Sprint** (`app.md` 5.1, SRS-driven)
4. **⚔️ Word Siege** (`app.md` 24.1), the flagship action game
5. Home screen (`app.md` 10.1): today's plan, streak flame, XP bar, "Start" button, my implementation-intention sentence
6. Daily reminder notification + streak freeze system

### Phase 2: Fix the weak points
1. **Sentence X-Ray** and **Slice It** (`app.md` 20.1, scoring in 21.4)
2. **📑 Paragraph Architect** (`app.md` 24.2) including the Cohesion Map result screen
3. **🔊 Chunk Echo** (`app.md` 24.3) including Memory Ladder mode and chunk-highlighting during audio
4. Reading screen with tap-to-define and **"From the wild"** word saving
5. Mistake Notebook / Mistake Gym
6. Difficulty auto-tuner (`app.md` 21.3) wired into every game

### Phase 3: Stats and polish
- Stats screen: words mastered, accuracy by game and by sentence level, streak calendar, minutes per day, per-skill CEFR estimate.
- Backup/restore (export and import a single file) as in `app.md` 9.7.
- Achievements, weekly boss, sounds, final animation pass.

(Speaking with Vosk, Writing games and Mock Tests come after this. Do not start them unless I ask.)

## SPECIFIC REQUIREMENTS FOR THE THREE NEW GAMES

### ⚔️ Word Siege
- 3 lanes, enemies walking down, front-most enemy is the active target.
- Typing mode (default for B2+) and tap mode (levels 1-2).
- Modes: Meaning→Word, Sentence Gap, Synonym Strike, Collocation Siege, Word Family.
- Waves: 3 per round; wave 3 has a Boss (long sentence with 2 gaps).
- Power-ups: Freeze (combo x5), Echo (x8, counts as hint), Bomb (x12).
- Use the SM-2 quality table from `app.md` 24.1 exactly.
- Pace adapts with `enemySpeed()` from the doc; at most 2 gate breaches per wave before a "Take a breath" pause.
- Accepts minor typos at levels 1-3 and exact spelling at levels 5-6; accepts US/UK spelling variants.

### 📑 Paragraph Architect
- Drag-and-drop reorder list with smooth animations; tap a card to hear it.
- Pair-based scoring plus exact-order bonus, support multiple valid orders.
- Helper buttons (Highlight connectors, Pin the opener, Show one link) with XP penalties from the doc.
- Result screen draws the **Cohesion Map** (arrows between sentences labelled with the cue word and link type).
- Optional follow-up question on reference words ("What does *this* refer to?").

### 🔊 Chunk Echo
- Audio-first: only a waveform shows while the sentence plays, no text.
- Chunk tiles are rebuilt in order; replay limits per level from the table in `app.md` 24.3.
- While the correct answer replays, highlight each chunk using `chunkTimingsMs`.
- Modes: Chunk Rebuild, Gap Echo, Memory Ladder (store best ladder in `personal_best`).
- The optional "say it aloud" step is built as a self-rating for now (Vosk comes later); design the interface so ASR can be plugged in.

## UX AND DESIGN DIRECTION

- Feels like a **game, not a school app**: bold typography, juicy micro-animations (correct = burst, combo = glow, level-up = confetti), haptic feedback, short satisfying sounds.
- Calm, focused color palette; high contrast; minimum 16 sp body text, 48 dp touch targets.
- One-handed, portrait-first layouts. The primary action is always reachable by the thumb.
- Never interrupt a round with dialogs. Feedback appears inline.
- Respect system dark mode and "reduce motion" accessibility setting.

## DEFINITION OF DONE (for each feature)

- [ ] Works fully offline (verify the manifest has no INTERNET permission).
- [ ] Logic is in pure Dart classes with unit tests (scoring, SRS quality mapping, difficulty tuning).
- [ ] Writes `review_log`, `game_session`, `daily_stat` rows correctly.
- [ ] Updates streak and XP correctly, including freeze and comeback behavior.
- [ ] "What you learned" screen is present and correct.
- [ ] No analyzer warnings (`flutter analyze` clean) and all tests pass (`flutter test`).
- [ ] Tested on a small and a large screen size, in both light and dark theme.

## HOW TO WORK

1. First, **read `app.md` fully**, then reply with a **short plan**: the files you will create in Phase 0 and any questions that block you. Ask only questions that truly block progress; otherwise make a sensible decision and note it.
2. Build in the phase order above. After each phase, give me: what was built, how to run it, what to test manually, and what comes next.
3. Keep commits small and meaningful (e.g., `feat(srs): add SM-2 scheduler with tests`).
4. When you make a decision that differs from `app.md`, write it down in a `DECISIONS.md` file with the reason.
5. If content (words, sentences, audio) is missing, create clearly labelled starter content and tell me exactly which files to extend and in what format. **Never invent audio files that do not exist**: use the TTS fallback until I add real audio.
6. Do not add features that are not in `app.md` or this prompt without asking first.

## START NOW

Begin with step 1: read `app.md`, then post your Phase 0 plan.
