# 🎮 English Arena: Complete Product, Teaching and Engineering Report

> A personal, 100% offline English-learning game that replaces mindless action games with skill-building play, covering **Reading, Writing, Speaking and Listening**.
>
> Written from three viewpoints: **Senior English Teacher**, **Senior Mobile App Developer**, and **Learning Psychologist** (mind-strengthening).

---

## Table of Contents

1. [Vision and Core Principles](#1-vision-and-core-principles)
2. [The Science: Why This App Will Actually Work](#2-the-science-why-this-app-will-actually-work)
3. [The Psychology: Making Your Mind Strong](#3-the-psychology-making-your-mind-strong)
4. [The Four Skills, Fully Offline](#4-the-four-skills-fully-offline)
5. [Game Catalog (Existing and New)](#5-game-catalog-existing-and-new)
6. [Feature List (Prioritized)](#6-feature-list-prioritized)
7. [Progression, Rewards and Streak System](#7-progression-rewards-and-streak-system)
8. [Content Strategy and Data Model](#8-content-strategy-and-data-model)
9. [Technical Architecture](#9-technical-architecture)
10. [UX/UI Best Practices](#10-uxui-best-practices)
11. [Mobile Development Best Practices](#11-mobile-development-best-practices)
12. [Your Daily and Weekly Learning Plan](#12-your-daily-and-weekly-learning-plan)
13. [Measuring Progress](#13-measuring-progress)
14. [Roadmap](#14-roadmap)
15. [Common Pitfalls](#15-common-pitfalls)
16. [Final Checklist](#16-final-checklist)
17. [🎯 My Goal: B2 → C1 → C2](#17-my-goal-b2--c1--c2)
18. [📚 Vocabulary Boost Plan](#18-vocabulary-boost-plan)
19. [🧩 Long-Sentence Understanding Plan](#19-long-sentence-understanding-plan)
20. [🕹️ New Games for My Weak Points](#20-new-games-for-my-weak-points)
21. [🗄️ Database and Code Additions](#21-database-and-code-additions)
22. [📅 Updated 30-Minute Daily Plan and Targets](#22-updated-30-minute-daily-plan-and-targets)
23. [🗺️ Updated Roadmap for the C1/C2 Goal](#23-updated-roadmap-for-the-c1c2-goal)
24. [🆕 Three New Games: Word Siege, Paragraph Architect, Chunk Echo](#24--three-new-games-action-style-built-for-my-weak-points)

---

## 1. Vision and Core Principles

### 1.1 What the app is
A private, offline "English gym disguised as a game." You get the fun of an action game (speed, levels, combos, bosses) but every second builds real English: vocabulary, grammar, listening, speaking and writing.

### 1.2 Design principles

| # | Principle | Meaning |
|---|-----------|---------|
| 1 | **Offline-first** | Every word, audio file, model and puzzle lives on the phone. No network permission is needed. |
| 2 | **Play first, study second** | The player should feel "one more round!", never "I must study." |
| 3 | **Short sessions** | The core loop is 2-5 minutes, so it fits any spare moment. |
| 4 | **Active, not passive** | The user always produces something: types, speaks, picks, orders. Never only reads. |
| 5 | **Spaced and adaptive** | The app decides what you review today, based on what you are about to forget. |
| 6 | **Safe to fail** | Mistakes are data, not punishment. Failing is how the brain learns. |
| 7 | **All four skills** | Reading, Writing, Speaking, Listening are tracked separately and balanced. |
| 8 | **No dark patterns** | No ads, no paywalls, no guilt-trip notifications. You are the only user, so design for your long-term good. |

### 1.3 Target outcome (be specific)
**Current level (self-tested):** B / B+ (treated as **B2** for planning).
**Final goal:** **C2** (the highest CEFR level). **C1 is the first milestone**, C2 the final target.
**Known weak points:** (1) limited vocabulary, (2) difficulty understanding long sentences.

Measurable checkpoints (details in sections 17-23):
- **3 months:** +1,000 solid words, can break down 20-25 word sentences with the X-Ray method, reads graded B2 articles without much dictionary use.
- **6 months:** +2,000 words, reads news articles at normal speed, records a 2-minute spoken answer without long pauses.
- **12 months:** solid **C1** reading/listening, writes a clear 250-word argument, 7,000+ word vocabulary.
- **24-36 months:** working toward **C2**: nuance, register, style, near-effortless comprehension.

---

## 2. The Science: Why This App Will Actually Work
*(Senior Teacher's section)*

These are well-established principles in language teaching and cognitive science. Every game and feature below should map to at least one.

### 2.1 Spaced Repetition (SRS)
The brain forgets on a predictable curve (Ebbinghaus). Reviewing an item just before you'd forget it makes the memory last far longer. **This is the single most valuable feature** in a vocabulary app.
- Use **SM-2** (simple, proven, used by Anki's classic scheduler) or **FSRS** (newer, more accurate, a little more complex).
- Every word and sentence pattern gets its own schedule: 1 day → 3 days → 7 days → 16 days → 35 days...

### 2.2 Active Recall / Retrieval Practice
Pulling an answer out of memory strengthens it far more than re-reading. So prefer "type the word" or "say the sentence" over "recognize from options". Use multiple choice only for beginners or as a warm-up.

### 2.3 Desirable Difficulty
Learning should feel *slightly hard*. If you win 100% of rounds, you're not growing. Target about **75-85% accuracy**. The app should auto-adjust difficulty to stay in this zone.

### 2.4 Interleaving
Mix item types (vocab, grammar, listening) in one session instead of 30 minutes of one thing. It feels harder but gives better long-term retention.

### 2.5 Comprehensible Input (Krashen's i+1)
You learn most from material that is *just above* your level: about 90-95% of the words known, a few new ones. So graded reading and listening content by CEFR level (A1 → C1) matters.

### 2.6 The Output Hypothesis (Swain)
You must also **produce** language (speak and write) to notice gaps. That is why Speaking and Writing games are required, not optional.

### 2.7 Lexical Approach: Learn Chunks, Not Single Words
Fluent speakers use ready-made phrases: *"I'm looking forward to...", "It depends on...", "by the way"*. Teach **collocations** and **phrases**, not isolated words.
- ❌ Learn: `make`, `decision`
- ✅ Learn: `make a decision`, `make up your mind`

### 2.8 Dual Coding and Context
Words stick better with **a sentence + a sound + (optionally) an image/emoji**. Always store at least one example sentence per word.

### 2.9 Shadowing (for speaking and listening)
Listen to a sentence, then immediately repeat it, copying rhythm, stress and intonation. It trains pronunciation and listening together. Very strong, and works fully offline.

### 2.10 Dictation (for listening and spelling)
Hear a sentence, type exactly what you heard. It exposes the gap between "I think I understand" and "I really hear every word."

### 2.11 Extensive + Intensive Reading
- **Intensive:** short texts, study every word.
- **Extensive:** lots of easy text for pleasure, to build speed and intuition.

### 2.12 Fluency Strategies (Paul Nation's "Four Strands")
A balanced course has four equal parts:
1. **Meaning-focused input** (reading/listening)
2. **Meaning-focused output** (speaking/writing)
3. **Language-focused learning** (vocabulary, grammar, pronunciation)
4. **Fluency development** (speed practice on *known* material)

Your app's game list should cover all four strands. The final section of this report checks that.

---

## 3. The Psychology: Making Your Mind Strong
*(Learning Psychologist's section)*

### 3.1 Self-Determination Theory (why you keep going)
Motivation lasts when three needs are met:
- **Autonomy:** you choose the game and the goal. *(Let the user pick a mode each day.)*
- **Competence:** you feel yourself getting better. *(Visible levels, stats, "words mastered" counter.)*
- **Relatedness:** a sense of connection. *(Offline and solo, so substitute with a friendly "coach" character with encouraging messages.)*

### 3.2 Flow State
Flow happens when challenge ≈ skill. Too easy → boredom. Too hard → anxiety.
- Auto-tune difficulty after every round.
- Use clear goals ("Beat 12 words in 60s"), instant feedback (sound/haptic), and no interruptions.

### 3.3 Habit Formation (Cue → Routine → Reward)
- **Cue:** a daily reminder at a fixed time, or "after I finish breakfast / after Isha prayer / on the bus".
- **Routine:** a 5-minute minimum session. Make it *so easy* you can't refuse (BJ Fogg's "Tiny Habits").
- **Reward:** XP, streak flame, a satisfying sound and animation.
- **Implementation intention:** write it as "When [situation], I will play [X minutes]." Let the app store this sentence and show it on the home screen.

### 3.4 Streaks: Use the Power, Avoid the Trap
Loss aversion makes streaks powerful, but a broken streak can cause "what-the-hell" quitting.
- ✅ **Streak freeze** tokens (earn 1 per 7 days).
- ✅ **"Comeback" mode:** after a miss, a *gentle* message and a very easy session.
- ✅ Track **"best streak"** and **"total days played"**. Total days never resets, so progress is never lost.
- ❌ Never shame or use guilt text.

### 3.5 Growth Mindset
Show language that attributes success to **effort and strategy**:
- "You missed this 3 times, which means your brain is building the memory. Try once more!"
- Show a **"Mistakes that became mastery"** list.

### 3.6 Dopamine, Used Ethically
Variable rewards are what make action games addictive. Use them *for your benefit*:
- Surprise bonus XP, a random "lucky word" double-points round, loot-chest-style "daily gift" (new word cards, themes, badges).
- Keep it **bounded**: daily cap, calm "Great job, session complete" ending. The goal is to *build a habit*, not to trap you.

### 3.7 Goal-Gradient and Zeigarnik Effects
- People work harder when close to a goal → show progress bars ("3 more words to Level 5!").
- Unfinished tasks nag the mind → show "1 daily quest left", gently.

### 3.8 Cognitive Load Management
- One main task on screen at a time.
- Max 5-7 new words per session.
- Clean layout, large fonts, minimal text instructions.

### 3.9 Speaking Anxiety (the biggest hidden blocker)
Many learners understand English but freeze when speaking. Build a **safe speaking ladder**:
1. Read aloud (no thinking needed)
2. Shadow a sentence
3. Answer a *yes/no* question aloud
4. Describe a picture/emoji prompt in one sentence
5. Answer open questions for 30-60 seconds
6. Retell a story in your own words

Recordings are **private**. Add the line: *"No one is judging. This is your gym."*

### 3.10 Sleep, Memory and Rhythm
Memory consolidates during sleep.
- Offer an optional **"Night review"** (3 min of the hardest words before bed) and a **"Morning recall"** (test yourself on yesterday's night words). This sleep-dependent consolidation is real and helps.
- Cap sessions to avoid fatigue. A smart "You've done enough today" screen is healthy design.

### 3.11 Mental Toughness Features (the "strong mind" layer)
- **Daily intention:** pick a one-sentence goal.
- **Reflection:** after each session, one optional line: "What was hardest today?"
- **Weekly review:** "Here's what you learned, here's what to improve."
- **Challenge mode:** opt-in harder rounds (time pressure, no hints) to train calm under pressure.
- **Breathing/Focus pre-round (optional, 10 seconds):** helps focus before speaking tests.
- **Deep work block:** a 25-minute Pomodoro-style "Focus Arena" with no interruptions.

---

## 4. The Four Skills, Fully Offline

### 4.1 📖 Reading

**Goals:** speed, comprehension, vocabulary-in-context, inference.

**Offline content:**
- Graded short passages (A1 → C1), 80-400 words, bundled as JSON/Markdown.
- Sources with permissive licenses: Simple English Wikipedia (CC BY-SA), Project Gutenberg (public domain, simplify/choose easy books), Tatoeba sentences (CC BY 2.0 FR), or **your own original/AI-assisted texts** (safest for licensing, and you can write them at your exact level).

**Features:**
- **Tap-to-define** any word inside a passage (offline dictionary lookup).
- **Save to My Words** with one tap.
- **Reading speed tracker** (words per minute) plus comprehension quiz. Target ~150-200 wpm with 80%+ comprehension.
- **Graded reader library** with a "% of words you already know" indicator.
- **Cloze reading** (fill gaps in the passage).
- **Reading modes:** Normal, Timed, "Highlight what I don't know".

### 4.2 ✍️ Writing

**Goals:** accuracy, vocabulary use, structure, spelling.

**Offline approach (no internet):**
- **Guided writing prompts** with level-based scaffolds (sentence starters, word bank).
- **Self-check rubric** shown after writing (checklist: capital letters? full stops? tense consistent? used 3 target words?).
- **Model answers** shown *after* you write for comparison (noticing technique).
- **Rule-based checks in code** (works offline): spelling via bundled dictionary, repeated words, sentence length, missing capital/period, target words used.
- **Optional on-device AI feedback (advanced):** a small quantized LLM running locally (e.g. 1-3B parameter models through llama.cpp / MediaPipe LLM Inference / MLC). It can give grammar suggestions without internet, but needs a 1-2 GB model download *once*, more RAM and battery, and may make mistakes. Treat it as **optional Phase 3**, and always show it as "suggestion", not truth.
- **Writing portfolio:** save all your texts with dates, to see your growth.
- **Journal mode:** write 3 sentences a day ("Today I..."). Tiny but powerful habit.

**Writing task types:**
1. Sentence building from words
2. Paragraph from prompt (50-80 words)
3. Rewrite/paraphrase a sentence
4. Fix the errors (error-correction)
5. Email/message writing (practical English)
6. Describe a picture/emoji scene

### 4.3 🎧 Listening

**Goals:** decode fast speech, spot word boundaries, understand meaning.

**Offline audio options:**
1. **Pre-recorded audio files** bundled as assets (best quality; you can record yourself or a friend, or use free-licensed audio such as Mozilla Common Voice (CC0) or LibriVox (public domain)).
2. **On-device Text-to-Speech (TTS):** Android's `TextToSpeech` engine works offline *if the user has downloaded the voice data* (Settings → Language → Text-to-speech). iOS `AVSpeechSynthesizer` works offline natively. For nicer, consistent voices: **Piper TTS** (open-source, runs offline, small voice models ~20-80 MB).
3. Pre-generate all audio once on your PC with a good TTS, and **ship the MP3/OGG files** inside the app. This is best for reliability, speed and consistent quality.

**Features:**
- **Speed control** (0.6x, 0.8x, 1.0x, 1.2x) with pitch preserved.
- **Accent variety** (US, UK, Indian, Australian) for real-world listening.
- **Dictation** mode (type what you hear).
- **Gap-fill listening** (missing words).
- **Listen → Answer** comprehension questions.
- **Minimal pairs** (ship/sheep, bit/beat, think/sink) for sound discrimination.
- **Connected speech trainer:** teach "gonna, wanna, whaddaya, I'd've" so real speech stops sounding like a blur.
- **Replay limit** option, to simulate real tests.

### 4.4 🗣️ Speaking

**Goals:** pronunciation, fluency, confidence, spontaneous response.

**Offline speech recognition options:**
- **Vosk** (Apache-2.0, small English model ≈ 40-50 MB, runs offline on Android/iOS, light and fast).
- **Whisper.cpp** (MIT; `tiny.en` ≈ 75 MB, `base.en` ≈ 140 MB; more accurate but heavier on battery/CPU).
- **Android `SpeechRecognizer`** with offline language pack (device-dependent, may silently use the internet if the pack is missing, so test with airplane mode).
- **Sherpa-ONNX** (open-source, offline streaming ASR; good Flutter/mobile support).

**Features:**
- **Read aloud → score:** compare recognized text with target text. Show matched/missed words in green/red.
- **Shadowing:** play model sentence, record your voice, play both back to back (**A/B comparison**).
- **Record-and-self-review:** even with no AI scoring, hearing yourself is valuable. Keep a private audio diary.
- **Speak-the-word challenges:** "Say a sentence using *reluctant*."
- **Tongue twisters** (fun + articulation).
- **Role-play dialogues:** the app plays Person A (audio); you speak Person B's lines (then it advances).
- **Timed answers:** 30/45/60 sec "Say anything about this topic" (IELTS-style), with a "words per minute" and "pause count" estimate.
- **Pronunciation focus:** stress patterns, the "th" sound, vowel length, word-final consonants.
- **Phonetic transcription (IPA)** next to words (from the CMU Pronouncing Dictionary, public domain / permissive license).

---

## 5. Game Catalog (Existing and New)

Legend: 📖 Reading · ✍️ Writing · 🎧 Listening · 🗣️ Speaking · 🔤 Vocabulary · 🧩 Grammar

### 5.1 Your three core games (improved)

#### 🎡 1. Anagram Wheel 🔤✍️
- **Mechanic:** letters rotate on a wheel; swipe to form words before the timer ends. Bonus for the long "mega word."
- **Improvements:** show a definition clue after 10 s; letters can be dragged in a trail; combos (3 words in a row = x2).
- **Levels:** 4-letter words (A1) → 8-letter words (B2).
- **Learning value:** spelling, word recognition, morphology.
- **Add:** after each round, show all possible words found/missed *with meanings*, so every round teaches.

#### 🧱 2. Sentence Unscrambler 📖✍️🧩
- **Mechanic:** drag word tiles into the correct order.
- **Improvements:** use real-life sentences ("Could you tell me where the station is?"); two valid orderings are accepted when grammar allows; play audio after correct answer (listening link); tap a tile to hear it.
- **Levels:** simple (6 words) → complex (14 words with clauses).
- **Add:** "Why?" button shows the grammar rule in one line.

#### ⚡ 3. Vocabulary Sprint 🔤
- **Mechanic:** a definition/sentence flashes; pick or type the word as fast as possible.
- **Improvements:** SRS-driven (shows words due for review); speed multipliers; "lives" system; audio pronunciation after answer.
- **Modes:** Meaning→Word, Word→Meaning, Synonym, Antonym, Sentence-gap.

### 5.2 New games by skill

#### 📖 Reading Games
| Game | How it works | Skill |
|------|--------------|-------|
| **Speed Reader Rush** | A passage scrolls/flashes at your target wpm, then a 3-question quiz. | Speed + comprehension |
| **Detective Mode** | Read a short mystery; find clues by tapping sentences that answer questions. | Scanning, inference |
| **Cloze Quest** | Fill the gaps in a paragraph (choose from bank or type). | Context, grammar |
| **Headline Match** | Match headlines/titles to paragraphs. | Main idea |
| **True/False/Not Given** | IELTS-style statement checking. | Precision reading |
| **Story Branch** | Interactive offline story, choices depend on understanding the text (choose-your-own-adventure). | Motivation, comprehension |

#### ✍️ Writing Games
| Game | How it works |
|------|--------------|
| **Word Forge** | Given 3-5 target words, write one sentence using all. Self-check + model answer. |
| **Error Hunter** | A sentence has a hidden mistake. Tap it and fix it. Combos for speed. |
| **Rewrite Rumble** | Rewrite a sentence in a different tense/formal level/synonyms. |
| **Emoji Story** | 3-5 emojis prompt you to write a short story. |
| **Mini Email Boss** | Write a real-life message (ask for leave, order, complain politely). Boss level = checklist of required phrases. |
| **Daily 3 Sentences** | Journal habit with streak tracking. |
| **Spelling Bee** | Hear the word, spell it. Reuses audio from the Listening module. |

#### 🎧 Listening Games
| Game | How it works |
|------|--------------|
| **Dictation Dash** | Hear sentence, type it. Letter-level diff highlighting. |
| **Sound Sniper** | Minimal pairs: hear a word, tap the correct one (ship/sheep). Shooter-style reaction game, closest to your original action-game habit. |
| **Missing Word Radar** | Audio plays with a beep over one word; guess it. |
| **Speed Ladder** | Same audio at 0.7x → 1.5x. Beat the highest speed. |
| **Who Said It?** | Short dialogue; answer who/where/why. |
| **Accent Safari** | Same sentence by different accents; train your ear to adapt. |
| **Number & Time Ninja** | Hear phone numbers, prices, times, dates, then type them. Very practical. |

#### 🗣️ Speaking Games
| Game | How it works |
|------|--------------|
| **Shadow Boxing** | Listen → repeat immediately; score rhythm and word match. |
| **Say It Right** | Read aloud, recognition shows red/green words. |
| **Tongue Twister Tower** | Increasingly hard twisters, speed meter. |
| **60-Second Talker** | Random topic, speak for 60 s, no stopping (fluency over perfection). Record, replay, self-rate. |
| **Role-Play Cafe/Airport/Doctor/Interview** | App voice plays the other person; you reply. |
| **Picture Describe** | Show image/emoji scene; describe it. |
| **Retell Master** | Listen to a 30 s story, retell in your own words. |

#### 🧩 Grammar and Vocabulary Games
| Game | How it works |
|------|--------------|
| **Tense Tetris** | Falling verb forms; place into the right tense column. |
| **Preposition Parachute** | Fill in/on/at/by/with in sentences, quickly. |
| **Collocation Match** | Match verb + noun (make/do, take/have). |
| **Phrasal Verb Dungeon** | Learn *give up / look after / run out of* with examples; boss fight = review. |
| **Idiom Escape Room** | Solve puzzles using idioms' meanings. |
| **Word Family Tree** | Build *decide → decision → decisive → indecisive*. |
| **Synonym Stack** | Stack blocks of words with the same meaning. |
| **Odd One Out** | Choose the word that doesn't belong. |
| **Crossword / Word Search / Hangman** | Classic, themed to your vocabulary. |
| **Memory Match** | Word ↔ meaning ↔ picture/sound cards. |
| **Article Arena (a/an/the/∅)** | Quick-fire article choices (a common weak area). |
| **Confusing Words Duel** | affect/effect, their/there, lose/loose, then/than. |

#### 🆕 Newest Additions
Three more games (**Word Siege**, **Paragraph Architect**, **Chunk Echo**) are fully specified in [Section 24](#24--three-new-games-action-style-built-for-my-weak-points).

#### 🏆 Meta Modes
- **Daily Challenge:** a fixed mix (1 vocab + 1 listening + 1 speaking + 1 writing). The "core 10 minutes."
- **Boss Battle (weekly):** a mixed exam of everything learned that week; unlocks a badge.
- **Survival Mode:** endless questions, lives, rising difficulty. Closest to action games.
- **Review Mission:** only SRS-due items.
- **Mistake Gym:** replay your last 50 mistakes.
- **Mock Test Mode:** timed mini-test in all four skills with a final CEFR-style estimate.

### 5.3 Game Design Rules (apply to every game)
1. Every round ends with a **"What you learned"** summary (new words + sentence + audio).
2. Wrong answers show the **correct answer + reason + example**, then re-queue the item in the same session (retry within a few minutes).
3. Always provide **audio** for any English text (tap-to-hear).
4. **Never reuse the same easy item** endlessly; SRS decides.
5. **Mix input types:** tap, type, drag, speak.
6. Round length: **60-120 seconds**.
7. **Session cap:** soft cap around 20 minutes with a friendly "great work" screen.

---

## 6. Feature List (Prioritized)

### 6.1 MUST-HAVE (MVP)
- [ ] 3 core games (Anagram, Unscramble, Vocab Sprint)
- [ ] Offline local database (words, sentences, definitions, examples)
- [ ] **SRS scheduler** (SM-2)
- [ ] Daily streak + milestones (you already planned this)
- [ ] XP, levels and score history
- [ ] Tap-to-hear (offline TTS or bundled audio)
- [ ] Placement test (set starting level)
- [ ] Settings: sound, haptics, daily goal, dark mode
- [ ] Local backup/export (JSON file) so you never lose progress

### 6.2 SHOULD-HAVE (v1.0)
- [ ] Listening: Dictation Dash, Sound Sniper, Speed Ladder
- [ ] Reading: graded passages + tap-to-define + comprehension quiz
- [ ] Speaking: Say It Right and Shadow Boxing using offline STT (Vosk) + recorder
- [ ] Writing: Word Forge, Error Hunter, Daily 3 Sentences, journal
- [ ] "My Words" notebook with favorites, notes, and difficulty flags
- [ ] Daily Challenge and Weekly Boss
- [ ] Statistics dashboard (accuracy per skill, words mastered, minutes, heatmap calendar)
- [ ] Achievements/badges
- [ ] Daily reminder notification (local notifications, no internet needed)
- [ ] Streak freeze

### 6.3 NICE-TO-HAVE (v2.0)
- [ ] Phrasal verbs, idioms, collocations packs
- [ ] Role-play conversations
- [ ] 60-Second Talker with fluency metrics
- [ ] Story Branch (interactive fiction)
- [ ] Themes/skins, avatars, sound packs (unlockable)
- [ ] Home-screen widget (streak, "word of the day")
- [ ] Lock-screen "word of the day" notification
- [ ] Custom decks: add **your own** words/sentences (copy-paste, CSV import)
- [ ] Pronunciation heat-map (which sounds you struggle with)
- [ ] Mock tests with CEFR/IELTS-style scoring

### 6.4 ADVANCED / EXPERIMENTAL (v3.0)
- [ ] On-device small LLM for writing feedback and conversation partner (optional download)
- [ ] Phoneme-level pronunciation scoring (forced alignment with on-device models)
- [ ] Adaptive curriculum engine (auto-builds the day's plan from weak areas)
- [ ] FSRS scheduler (replace SM-2 for better retention)
- [ ] Wear OS/Apple Watch quick-review
- [ ] Optional encrypted local-network backup (still no cloud)

### 6.5 Essential "small but powerful" features people forget
| Feature | Why it matters |
|---------|----------------|
| **Mistake notebook** | Your errors are your personalized curriculum. |
| **"I already know this" button** | Removes boring items, respects your time. |
| **Mnemonics field** | Your own memory trick = strongest memory. |
| **Example sentence from your life** | Personal context = stickiness. |
| **Offline dictionary** (WordNet / Wiktionary dump / your own) | Look anything up with no internet. |
| **Daily goal in minutes AND in items** | Two ways to feel progress. |
| **Pause/resume mid-round** | Phones get interrupted (calls). |
| **Accessibility** (font size, color-blind-safe palette) | Comfort for long-term use. |
| **Haptic + sound design** | Makes it feel like a "real game." |
| **Data export (CSV/JSON)** | Own your data. |

---

## 7. Progression, Rewards and Streak System

### 7.1 XP and Levels
- XP per correct answer, bonus for speed, combo and "first-try correct."
- XP curve: `xpForLevel(n) = 100 * n^1.5` (smooth, gets slower, never impossible).
- **Ranks** (fun + motivating): Rookie → Explorer → Word Hunter → Phrase Fighter → Grammar Knight → Fluency Captain → Wordsmith → English Master.
- Show ranks beside CEFR estimate (A1…C1) so you know *real* progress.

### 7.2 Streak System
- **Daily streak:** counts if you complete the *minimum goal* (e.g., 5 minutes or 1 Daily Challenge).
- **Streak freeze:** earn by consistency; use automatically on a missed day.
- **Weekend-friendly mode:** an optional "5 of 7 days" weekly streak for less pressure.
- **Total days played** and **longest streak** are shown permanently.
- Milestones: **3, 7, 14, 30, 50, 100, 200, 365 days**, each with a badge, a themed reward, and a short congratulation.

### 7.3 Achievements (examples)
- 🌅 *Early Bird*: play before 8 AM
- 🌙 *Night Owl*: finish a night review
- 🎯 *Sharpshooter*: 20 correct in a row
- 🔥 *Streak 30*
- 📚 *Bookworm*: read 10 passages
- 🎙️ *Brave Voice*: record 20 speaking answers
- ✍️ *Wordsmith*: write 30 journal entries
- 🧠 *Memory Master*: 500 words mastered (interval ≥ 21 days)
- 🛠️ *Mistake Fixer*: re-learn 50 mistakes
- 🏆 *Boss Slayer*: beat 10 weekly bosses

### 7.4 Word Mastery Stages
`New → Learning → Reviewing → Familiar → Mastered → Retired(Archived)`
Show a **collection screen** ("Pokédex of words"). Collecting is highly motivating.

### 7.5 Daily Quest Board
3 quests per day, e.g. "Finish 1 listening game", "Learn 5 new words", "Speak 3 sentences." Completing all gives a chest (bonus XP, cosmetic, streak freeze chance).

---

## 8. Content Strategy and Data Model

### 8.1 Word lists to start with (CEFR-graded, frequency-based)
- **NGSL** (New General Service List, ~2,800 words, ≈ 90% coverage of general English)
- **NAWL** (academic words) / **AWL** (Coxhead's Academic Word List)
- **Oxford 3000 / 5000** (check its license before redistributing; for private personal use it's fine, but verify)
- **Phrasal verb and idiom lists** (create your own or use open sources)

> 💡 For personal use you have flexibility, but if you ever share the app, check each source's license. Safe open sources: **Tatoeba** (sentences), **Wiktionary/Wikidata** (CC BY-SA), **WordNet** (permissive license), **CMU Pronouncing Dictionary** (permissive), **Common Voice** (CC0).

### 8.2 How much content?
| Level | Words | Sentences | Passages | Audio clips |
|-------|-------|-----------|----------|-------------|
| A1-A2 | 1,000 | 2,000 | 50 | 1,500 |
| B1 | +1,500 | 3,000 | 80 | 2,500 |
| B2 | +2,000 | 4,000 | 100 | 3,000 |

Audio size estimate: OGG/Opus at ~24-32 kbps, ≈ 3 sec average per clip ≈ **10-12 KB/clip**. So 7,000 clips ≈ 70-90 MB. Very manageable.

### 8.3 Content quality checklist (teacher's rules)
- One word → **max 2 core meanings** at first (don't overload).
- Example sentence: natural, 6-12 words, uses the word in its **most common** sense.
- Include **part of speech**, **IPA**, **CEFR level**, **frequency rank**, **collocations**, **synonym/antonym**.
- Sentences should be **real-life useful** (shopping, work, travel, health, friends), not textbook-weird.
- Avoid culturally confusing or offensive examples.
- Have a **simple definition** in easy English (learner-dictionary style), plus optional **your native language** gloss.

### 8.4 Data schema (SQLite)

```sql
-- Words / lexical items
CREATE TABLE word (
  id INTEGER PRIMARY KEY,
  lemma TEXT NOT NULL,
  pos TEXT,                 -- noun, verb, adj, phrasal verb, idiom...
  ipa TEXT,
  cefr TEXT,                -- A1..C2
  freq_rank INTEGER,
  definition_en TEXT,
  definition_native TEXT,   -- optional (Amharic / Afaan Oromoo / etc.)
  audio_path TEXT,
  tags TEXT                 -- "travel,food,work"
);

CREATE TABLE example (
  id INTEGER PRIMARY KEY,
  word_id INTEGER REFERENCES word(id),
  sentence TEXT NOT NULL,
  translation TEXT,
  audio_path TEXT
);

-- Spaced repetition state, one row per (item, skill)
CREATE TABLE srs_card (
  id INTEGER PRIMARY KEY,
  item_type TEXT,           -- 'word' | 'sentence' | 'phrase' | 'minimal_pair'
  item_id INTEGER,
  skill TEXT,               -- 'reading' | 'writing' | 'listening' | 'speaking' | 'vocab'
  ease REAL DEFAULT 2.5,
  interval_days INTEGER DEFAULT 0,
  repetitions INTEGER DEFAULT 0,
  lapses INTEGER DEFAULT 0,
  due_at INTEGER,           -- epoch ms
  last_reviewed_at INTEGER
);

CREATE TABLE review_log (
  id INTEGER PRIMARY KEY,
  card_id INTEGER,
  game TEXT,
  correct INTEGER,
  response_ms INTEGER,
  quality INTEGER,          -- 0..5
  reviewed_at INTEGER
);

CREATE TABLE passage (
  id INTEGER PRIMARY KEY, title TEXT, body TEXT, cefr TEXT, word_count INTEGER, audio_path TEXT
);
CREATE TABLE question (
  id INTEGER PRIMARY KEY, passage_id INTEGER, type TEXT, prompt TEXT, options TEXT, answer TEXT, explanation TEXT
);

CREATE TABLE user_text (            -- writing portfolio
  id INTEGER PRIMARY KEY, prompt TEXT, body TEXT, created_at INTEGER, self_score INTEGER
);
CREATE TABLE recording (            -- speaking diary
  id INTEGER PRIMARY KEY, prompt TEXT, file_path TEXT, duration_ms INTEGER, stt_text TEXT, score REAL, created_at INTEGER
);

CREATE TABLE daily_stat (
  day TEXT PRIMARY KEY,             -- 'YYYY-MM-DD'
  minutes INTEGER, xp INTEGER, items_reviewed INTEGER, goal_met INTEGER
);
CREATE TABLE streak (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  current INTEGER, best INTEGER, freezes INTEGER, last_day TEXT, total_days INTEGER
);
CREATE TABLE achievement (code TEXT PRIMARY KEY, unlocked_at INTEGER);
```

### 8.5 SM-2 scheduler (reference implementation, Dart)

```dart
class Card {
  double ease; int interval; int reps; int lapses; DateTime due;
  Card({this.ease = 2.5, this.interval = 0, this.reps = 0, this.lapses = 0, DateTime? due})
      : due = due ?? DateTime.now();
}

/// quality: 0 (blackout) .. 5 (perfect, instant)
void review(Card c, int quality) {
  if (quality < 3) {
    c.reps = 0;
    c.interval = 1;
    c.lapses++;
  } else {
    if (c.reps == 0) c.interval = 1;
    else if (c.reps == 1) c.interval = 6;
    else c.interval = (c.interval * c.ease).round();
    c.reps++;
  }
  c.ease = (c.ease + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)))
      .clamp(1.3, 3.0);
  c.due = DateTime.now().add(Duration(days: c.interval));
}

// Map game results to quality:
// correct + fast  -> 5 | correct -> 4 | correct but slow/hint -> 3 | wrong -> 1 | no idea -> 0
```

### 8.6 Streak logic (pseudo-code)

```dart
void onSessionComplete() {
  final today = dateKey(DateTime.now());
  if (streak.lastDay == today) return;                 // already counted
  final gap = daysBetween(streak.lastDay, today);
  if (gap == 1) streak.current++;
  else if (gap == 2 && streak.freezes > 0) { streak.freezes--; streak.current++; }
  else streak.current = 1;                             // gentle restart
  streak.best = max(streak.best, streak.current);
  streak.totalDays++;
  streak.lastDay = today;
  if (streak.current % 7 == 0) streak.freezes = min(streak.freezes + 1, 3);
}
```
> ⚠️ Use the **device's local date** and handle timezone/DST and manual clock changes (store `last_day` as a string, guard against a time going backwards).

---

## 9. Technical Architecture
*(Senior Mobile Developer's section)*

### 9.1 Choose your stack

| Option | Pros | Cons | Recommendation |
|--------|------|------|----------------|
| **Flutter (Dart)** | One codebase, great animations (perfect for games), strong offline packages, fast iteration | Larger APK; native speech libs need platform channels | ⭐ **Best overall for you** |
| **Kotlin + Jetpack Compose (Android native)** | Best performance, easiest offline TTS/STT/Vosk/ONNX integration, small APK | Android only | ⭐ Best if you only use Android |
| **React Native** | JS ecosystem | Native modules for audio/ASR can be painful | OK |
| **Unity/Godot** | Real game engine, particles, physics | Overkill for text/audio learning; heavier | Only if you want 3D/arcade visuals |

**Suggested:** *Flutter* + *Drift* (SQLite) + *Riverpod* (state) + *just_audio* + *flutter_tts* (or native TTS) + *Vosk/sherpa-onnx via platform channel or FFI* + *flutter_local_notifications*.

### 9.2 Layered architecture (Clean-ish)

```
lib/
 ├─ core/            // theme, constants, utils, audio/haptics service
 ├─ data/
 │   ├─ db/          // Drift tables, DAOs, migrations
 │   ├─ assets/      // JSON seeds, audio
 │   └─ repositories/
 ├─ domain/
 │   ├─ models/      // Word, Card, Passage...
 │   ├─ srs/         // SM-2 / FSRS
 │   ├─ scoring/     // XP, combo, accuracy
 │   └─ usecases/    // BuildDailyPlan, SubmitAnswer, UpdateStreak
 ├─ features/
 │   ├─ home/ ├─ games/ (anagram, unscramble, sprint, dictation, ...)
 │   ├─ reading/ ├─ writing/ ├─ listening/ ├─ speaking/
 │   ├─ stats/ ├─ streak/ ├─ settings/ └─ onboarding/
 └─ main.dart
```

**Rule:** each game implements one interface, so adding a new game takes minutes:

```dart
abstract class GameEngine<TQuestion> {
  String get id;
  Skill get skill;
  Future<List<TQuestion>> buildRound(RoundConfig config, List<Card> dueCards);
  Widget buildQuestionUI(TQuestion q, void Function(AnswerResult) onAnswer);
  AnswerResult evaluate(TQuestion q, dynamic userInput);
}
```

### 9.3 The Daily Plan Builder (the "brain" of the app)

```
1. Fetch due SRS cards (limit by daily cap, e.g. 40)
2. Add N new items (e.g. 5-8) from the current level's frequency list
3. Balance by skill: weight toward your weakest skill (lowest accuracy last 7 days)
4. Interleave: vocab → listening → grammar → speaking → writing
5. Cap total at user's daily minutes; show progress bar
6. Add one "fun" game as dessert (user's favorite)
```

### 9.4 Offline specifics (critical)
- **Do not request the INTERNET permission** in `AndroidManifest.xml`. It's a *proof* that the app is offline, and it blocks accidental network use. (Debug builds may need it for hot reload, so add it only in `debug` manifest.)
- Bundle assets in `assets/` and seed the DB on first run (a progress screen "Preparing your arena…").
- Use `sqlite` with **WAL mode**; run DB migrations carefully (never lose user data when updating).
- Large models (Vosk/Whisper/Piper voices) → ship in the APK/AAB (use **Play Asset Delivery / on-demand asset packs** or load from `/sdcard` manually, since this is a personal app, you can sideload them to app storage).
- Test everything in **Airplane mode**.

### 9.5 Audio and speech engineering notes
- **Audio format:** OGG Opus (small, high quality) for assets; WAV 16 kHz mono for the recorder → ASR input.
- **Latency:** preload next question's audio; use a low-latency sound pool for SFX (correct/wrong/combo).
- **Recording:** request `RECORD_AUDIO` permission with a friendly explanation; handle denial gracefully.
- **Echo/feedback:** don't play TTS while the mic is recording. Wait for completion.
- **Time-stretch playback** (0.6x–1.5x, pitch preserved): ExoPlayer (Android) / AVAudioEngine (iOS) / just_audio support it.
- **ASR accuracy tips:** use grammar-restricted/"keyword-biased" decoding for read-aloud tasks, since you know the expected text; normalize case/punctuation; compare with **word error rate (WER)** and Levenshtein alignment to color words green/red.
- **Pronunciation scoring caveat:** plain ASR matching tells you "was it understood", not "was it perfect". Be honest in the UI ("Recognized: …"). Phoneme-level scoring is a later advanced step.

### 9.6 Performance and battery
- Keep game loops at 60 fps: avoid heavy work in `build()`; precompute rounds off the UI thread (Isolates in Dart / coroutines in Kotlin).
- Load only the needed DB rows; index `due_at`, `item_type+item_id`.
- Release ASR/TTS resources when leaving screens.
- Use `const` widgets and `RepaintBoundary` for animated wheels.
- Target **cold start < 2 s**, **APK size** as small as practical (use split ABIs, compressed audio).

### 9.7 Data safety (offline apps lose data when phones die!)
- **Auto-backup:** export `progress.json` + DB to a user-chosen folder weekly. Also keep it in a cloud-synced folder such as Google Drive via the *system* file picker if you want (this is *your* choice; the app itself stays offline).
- Provide **Import/Restore**.
- Keep a **schema version** and write migration tests.
- Confirm Android Auto Backup rules (`android:allowBackup`, `dataExtractionRules`) match what you want.

### 9.8 Testing strategy
| Type | What | Tools |
|------|------|-------|
| Unit | SM-2, streak, scoring, anagram generator, answer evaluators | `flutter_test` / JUnit |
| Widget/UI | Each game screen with fake data | widget tests / golden tests |
| Integration | Full daily plan flow, offline mode, DB migration | `integration_test` |
| Manual | Airplane mode, low battery, 1 GB RAM old phone, interruptions (calls), screen rotation, dark mode | real devices |
| Content QA | Script that scans the word DB for missing audio, duplicates, bad CEFR, broken sentences | Python script |

### 9.9 Developer tooling and workflow
- Git + feature branches, even solo.
- A **content pipeline** on your PC (Python): CSV → validated JSON → SQLite seed + generated audio (Piper/TTS) → copy to `assets/`. Never hand-edit the database.
- Linting (`flutter analyze`), formatting, CI optional (GitHub Actions to build the APK).
- Version your content separately (`content_version`) so you can update words without breaking progress.
- Keep a **CHANGELOG.md** and a **TODO.md**.

---

## 10. UX/UI Best Practices

### 10.1 Home screen (minimal and motivating)
```
┌──────────────────────────────┐
│ 🔥 12-day streak   ⭐ Lv 7    │
│ "After breakfast I play 10m" │
│                              │
│  [ ▶ TODAY'S MISSION ]       │  ← one big button
│  Progress ●●●○○  (3/5)       │
│                              │
│  🎡 Anagram   ⚡ Sprint      │
│  🎧 Listen    🗣️ Speak       │
│  📖 Read      ✍️ Write       │
│                              │
│ [Stats] [My Words] [Settings]│
└──────────────────────────────┘
```

### 10.2 Principles
- **One-thumb design:** primary actions in the bottom half of the screen.
- **Big tap targets** (≥ 48 dp).
- **Instant feedback:** color + sound + vibration within 100 ms.
- **Juicy animations:** combo flames, confetti on level-up, shake on error (subtle). Respect a "reduce motion" setting.
- **Dark mode** and a **eye-comfort theme**, since you'll play at night.
- **Never block with modal popups mid-flow.**
- **Clear exit:** "Pause/Quit" always visible, and save partial progress.
- **Typography:** readable sans-serif; allow font scaling; IPA font support.
- **Colors:** don't rely on red/green only (add ✔/✖ icons) for color-blind safety.
- **Onboarding:** 3 screens max → placement test → first win within 60 seconds.

### 10.3 Feedback tone (psychology-aware copy)
| Instead of | Use |
|------------|-----|
| "Wrong!" | "Almost! The answer is *reluctant*. You'll see it again soon." |
| "You failed." | "That one's tough, so it's good you tried." |
| "You lost your streak." | "Welcome back! Day 1 of a new run, and your best is still 23." |

---

## 11. Mobile Development Best Practices (Checklist)

**Architecture**
- [ ] Separate UI, logic and data
- [ ] Single source of truth for state
- [ ] Dependency injection (Riverpod/Provider/Hilt)
- [ ] Repository pattern around the DB

**Reliability**
- [ ] Handle app lifecycle (pause, resume, killed by OS)
- [ ] Persist in-progress round state
- [ ] Graceful permission handling (mic, notifications)
- [ ] Crash logging **locally** (write to a file; no network needed)
- [ ] Defensive parsing of content files

**Offline-specific**
- [ ] No network dependency anywhere; test in Airplane mode
- [ ] Verify TTS voice data presence at startup; show a guide if missing
- [ ] Verify ASR model files exist and checksum matches
- [ ] Local notifications for reminders (exact alarms permission on newer Android versions)
- [ ] Handle battery-optimization killing reminders (guide: "Allow background activity")

**Quality**
- [ ] Accessibility labels, large-text support
- [ ] Localization-ready strings (even if only English UI now, you may add Amharic/Afaan Oromoo hints)
- [ ] Unit tests for all core logic
- [ ] Time handling tested (midnight rollovers, timezone changes)
- [ ] Release build tested (not just debug), since obfuscation/shrinking can break reflection-based libs

**Privacy and Security (even for personal apps)**
- [ ] Keep recordings in app-private storage
- [ ] Optional app lock (PIN/biometric) for your journal and recordings
- [ ] No analytics SDKs, no trackers

---

## 12. Your Daily and Weekly Learning Plan
*(Senior Teacher's study design)*

### 12.1 The 20-Minute Daily Arena (balanced across all four skills)

| Min | Activity | Skill | Strand |
|-----|----------|-------|--------|
| 0-1 | Warm-up: read your daily intention, 3 deep breaths | Mindset | n/a |
| 1-6 | **SRS review** (Vocab Sprint on due words) | Vocabulary | Language-focused |
| 6-10 | **Listening:** Dictation Dash or Sound Sniper | Listening | Meaning input |
| 10-14 | **Reading:** 1 short passage + quiz | Reading | Meaning input |
| 14-17 | **Speaking:** Shadow Boxing / Say It Right (3-5 sentences) | Speaking | Meaning output |
| 17-19 | **Writing:** Daily 3 Sentences using today's new words | Writing | Meaning output |
| 19-20 | **Fun dessert:** Anagram Wheel (speed round) + reflection line | Fluency | Fluency |

**Minimum viable day (5 min):** one SRS review + 1 spoken sentence. *The streak counts. Never skip two days.*

### 12.2 Weekly Rhythm

| Day | Focus |
|-----|-------|
| Mon | Vocabulary + Reading |
| Tue | Listening + Speaking |
| Wed | Grammar + Writing |
| Thu | Mixed + Phrasal verbs/idioms |
| Fri | Speaking day: 60-Second Talker + Role-play |
| Sat | **Boss Battle** (weekly mixed test) + review mistakes |
| Sun | Light day: story, podcast-style listening, journal reflection |

### 12.3 Rules for you, the learner
1. **Consistency beats intensity.** 15 min daily > 2 hours weekly.
2. **Speak out loud every day**, even alone. The mouth needs training like a muscle.
3. **Say it, then write it, then use it in real life** (talk to yourself, message a friend).
4. **Learn words in phrases.**
5. **Don't fear mistakes.** Each error is a free lesson.
6. **Review before learning new.** Retention first, then expansion.
7. **Sleep well.** Memory is built at night.
8. **Replace, don't add:** put this app where the action game used to be (same time, same place, the habit loop stays, only the routine changes).

### 12.4 Habit-Swap Plan (action game → English Arena)
- Delete the action game's home-screen shortcut; put English Arena in its place.
- Keep the *same time of day* you used to play.
- Allow a **reward**: after your daily mission, you may play 10 minutes of a favorite game guilt-free (a bridge strategy, which you can fade out after 3-4 weeks).
- Make the app *as fast to open as the old game*, with no loading and no login.

---

## 13. Measuring Progress

### 13.1 In-app metrics
| Metric | Why it matters |
|--------|----------------|
| **Words mastered** (interval ≥ 21 d) | Real long-term vocabulary |
| **Accuracy by skill (7-day rolling)** | Finds weak skills |
| **Reading speed (wpm) & comprehension %** | Reading growth |
| **Dictation accuracy (WER)** | Listening growth |
| **Speaking: recognition rate, WPM, pause count** | Fluency |
| **Writing: words/entry, unique words used, error count (self-flagged)** | Writing growth |
| **Retention rate** (% of reviews correct after ≥ 7-day gap) | SRS health; aim 85-90% |
| **Time played / consistency heat-map** | Habit |

### 13.2 Monthly checkpoint (30-minute "exam day")
1. Re-do the placement test → compare CEFR estimate.
2. Record a 2-minute speaking sample → compare with last month (listen to both!).
3. Write a 150-word text on the same prompt as last month.
4. Read one *unseen* passage and take the quiz.
5. Dictate 10 unseen sentences.

Save results → draw a progress graph. Seeing growth in **your own voice** is the strongest motivator.

### 13.3 Honesty note
Self-made scoring (especially for speaking/writing) is an **estimate**. Once in a while, test yourself on real material (a movie scene, a BBC Learning English clip, a real conversation) to calibrate.

---

## 14. Roadmap

### Phase 0: Foundation (Week 1-2)
- Choose the stack (Flutter recommended), set up the project, theme, navigation
- DB schema + seeding pipeline (CSV → SQLite)
- Import first 500 words (A1-A2) with sentences
- Offline TTS test + audio playback

### Phase 1: MVP, "Replace the action game" (Week 3-6)
- Anagram Wheel, Sentence Unscrambler, Vocab Sprint
- SM-2 SRS, XP, levels
- Streak + milestones + local reminder
- Stats screen (basic)
- **Start using it daily yourself. Real use = best feedback.**

### Phase 2: Four Skills Expansion (Week 7-12)
- Listening: Dictation Dash, Sound Sniper, Speed Ladder
- Reading: passages + tap-to-define + quiz
- Speaking: recorder, shadowing, offline ASR (Vosk)
- Writing: Word Forge, Error Hunter, journal
- Daily Mission builder, Weekly Boss, achievements, backup/restore

### Phase 3: Depth and Polish (Month 4-6)
- Role-play, 60-Second Talker, Story Branch
- Phrasal verbs, idioms, collocations
- Mock tests, monthly checkpoint reports
- Widget, themes, sound design, custom decks, CSV import

### Phase 4: Advanced (Month 6+)
- FSRS scheduler
- On-device LLM (optional) for writing/conversation feedback
- Pronunciation scoring improvements
- Adaptive curriculum

> 🎯 **Golden rule:** Ship Phase 1 as fast as possible and *use it every day*. Your own daily usage will tell you what to build next better than any plan.

---

## 15. Common Pitfalls

| Pitfall | Fix |
|---------|-----|
| Building too many features before using the app | Release the MVP in 4-6 weeks, then iterate |
| Content too small → boredom/repeats | Prepare ≥ 1,000 items before launch; add weekly |
| Only recognition games (multiple choice) | Mix in typing + speaking + writing |
| Streak anxiety / burnout | Freezes, easy "comeback" mode, "enough for today" screen |
| Learning words without sentences or audio | Enforce sentence + audio fields in content QA |
| Ignoring speaking because "I'm alone/shy" | Private, low-pressure speaking ladder |
| Offline TTS silently missing | Startup check + guide; or ship pre-generated audio |
| ASR gives false confidence | Show recognized text; don't call it "pronunciation score" unless it is |
| Lost data on phone change | Auto-export + restore |
| Reminders killed by battery saver | Guide to whitelist; show reminder-health check |
| Making the game *too* addictive/long | Soft daily cap; purpose = learning, not time-on-app |
| Neglecting grammar | Short, rule-in-one-line explanations tied to practice |
| No progress review | Weekly + monthly checkpoint |

---

## 16. Final Checklist

### Teaching quality
- [ ] All four skills have at least 2 games each
- [ ] Spaced repetition drives review
- [ ] Active recall dominates (typing/speaking > choosing)
- [ ] Content graded by CEFR with chunks/collocations
- [ ] Every item has sentence + audio
- [ ] Mistake notebook and "Mistake Gym" exist
- [ ] Monthly checkpoint implemented

### Psychology
- [ ] Autonomy (choose mode), Competence (visible growth), Connection (coach messages)
- [ ] Streak with freezes and kind comeback
- [ ] Growth-mindset feedback language
- [ ] Safe speaking ladder
- [ ] Night review / morning recall
- [ ] Soft daily cap

### Engineering
- [ ] No INTERNET permission in release; verified in Airplane mode
- [ ] Local DB with migrations + backup/restore
- [ ] Unit tests for SRS, streak, scoring
- [ ] Performance (60 fps, fast start)
- [ ] Content pipeline + QA script
- [ ] Accessibility and dark mode

### Four-Strands Balance (Nation)
| Strand | Covered by |
|--------|-----------|
| Meaning-focused input | Reading passages, Story Branch, Listening games |
| Meaning-focused output | 60-Second Talker, Role-play, Writing journal, Email Boss |
| Language-focused learning | Vocab Sprint, Anagram, Grammar games, Phrasal verbs |
| Fluency development | Speed Reader, Speed Ladder, Survival Mode, Shadowing |

---

## 🧠 Closing Message From Your "Teacher, Developer and Psychologist"

You're replacing hours of empty action with something that **compounds**. Every round you play is a small deposit into a skill nobody can take away. Remember:

1. **Build small, use daily, improve weekly.**
2. **Speak out loud, even when it feels awkward.** That awkwardness is the feeling of growth.
3. **Mistakes are the curriculum.**
4. **Protect your streak, but protect your sleep and health more.**
5. **Measure progress against your past self, not against anyone else.**

> *"You don't rise to the level of your goals. You fall to the level of your systems."*
> This app *is* your system. Build it well, and your English will follow.

**Suggested first three actions, starting today:**
1. Pick the stack (Flutter + Drift) and create the project.
2. Prepare the first 300 words with a sentence and audio each (CSV → SQLite).
3. Build Vocabulary Sprint with SM-2, play it for 5 minutes a day, and let that daily use guide everything else.

Good luck, and enjoy the game. 🚀

---

## 17. My Goal: B2 → C1 → C2

### 17.1 Level map

| Level | Rough meaning | Rough active vocabulary* |
|-------|---------------|--------------------------|
| **B2 (now)** | Follows most conversations/texts, argues a point, still makes errors | ~4,000-5,000 |
| **C1 (milestone)** | Fluent, flexible, understands implied meaning, writes well-structured long texts | ~7,000-9,000 |
| **C2 (final goal)** | Near-effortless with almost any text or speech; precise nuance and style | ~10,000+ |

*Estimates vary by source; use them as direction, not as a strict test.

> C2 does not mean "native speaker" (many natives never reach it). It means very advanced, precise and effortless English. **Plan: reach C1 first, then push to C2.** Two milestones are easier to stay motivated for than one distant goal.

### 17.2 Realistic timeline
Cambridge-style estimates are around **200 learning hours per level**. At about 1 hour per day (app + real English input):
- **B2 → C1:** about 8-14 months
- **C1 → C2:** another 12-24 months (progress is slower and harder to notice)

### 17.3 What changes at B2+ (the intermediate plateau)
At this stage you stop learning "more words" and start learning **precision, naturalness and speed**. The biggest enemy is the plateau: you understand and communicate, so you stop improving.

1. **Vocabulary:** from single words to collocations, connotation, register (formal vs informal), idioms. Example: *thrifty, frugal, stingy, cheap* differ in tone.
2. **Listening:** native-speed content, many accents, mumbling, slang, lectures.
3. **Reading:** authentic material (news, essays, novels), 30+ minutes a day.
4. **Writing:** cohesion, argument structure, style, removing fossilized mistakes.
5. **Speaking:** 2-5 minute answers with no long pauses, paraphrasing when you forget a word, abstract topics.
6. **Error elimination:** the Mistake Notebook becomes the main tool. Fixing recurring errors matters more than adding new content.

### 17.4 Time split for C1 progress
- About **60%** real English input (listening and reading authentic material)
- About **40%** app games and drills (vocabulary, structure, speaking, writing)

### 17.5 Real-world habits to add (games alone won't reach C2)
- **30 minutes of listening daily** (podcasts, documentaries, TED talks). Watch with English subtitles, then without.
- **Read daily** and save new phrases to a **"From the wild" deck** (each phrase stored with the sentence where you found it).
- **Shadow** native speakers for 5-10 minutes a day.
- **Write one paragraph and record 2 minutes of speech daily** on a random topic.
- **One human check** every 1-2 weeks if possible (teacher, language partner, native friend), because blind spots are invisible to you and to an app.

### 17.6 B2+/C1 content and defaults to switch on
- **Content lists:** Academic Word List (AWL), NAWL, B2-C1 collocations, phrasal verbs, idioms, word families. Add **nuance notes** such as "formal / informal / emphatic / negative connotation".
- **Harder defaults:** native-speed audio, no replay in Challenge mode, typing instead of multiple choice.
- **Mock tests:** monthly, using real Cambridge C1 Advanced practice papers or free online CEFR tests, since self-tests tend to overrate you.
- **Per-skill level tracking:** store a separate estimated CEFR for reading, writing, listening and speaking. Many learners are B2 in reading but B1 in speaking, so focus where the lowest skill is.

### 17.7 Advanced games for the C1/C2 stage

| Game | How it works | Trains |
|------|--------------|--------|
| **Nuance Duel** | Choose the best word among near-synonyms in a given context | Precision, connotation |
| **Register Shifter** | Rewrite a casual message in a formal style (and back) | Register, style |
| **Paraphrase Blitz** | Say or write the same idea in 3 different ways | Flexibility, fluency |
| **Collocation Forge** | Complete natural word pairs under time pressure | Natural phrasing |
| **Lecture Notes** | Listen to a 3-5 minute talk, answer questions, then summarize from memory | Academic listening |
| **Debate Mode** | Speak 90 seconds for or against an opinion | Argument, fluency |
| **Cohesion Fixer** | Repair a paragraph with poor linking between ideas | Writing structure |

---

## 18. Vocabulary Boost Plan

### 18.1 Why vocabulary comes first
Research on reading suggests you need to know roughly **95-98% of the words** in a text to follow it comfortably. At 90%, one word in ten is unknown, which is enough to lose the meaning of a long sentence. So **a bigger vocabulary directly fixes much of the long-sentence problem** (see section 19).

### 18.2 Step 1: Find your gaps
- Start with the **NGSL** (about 2,800 words). Mark the ones you do **not really know** (can't explain or use). Expect roughly **300-800 gaps**; these give the biggest return.
- Then study the **Academic Word List (570 word families)**, then B2-C1 lists.
- **Self-test method:** show a word; you must (a) say the meaning in your own words and (b) say or write a sentence with it. If you can't do both, it's not "known."

### 18.3 Step 2: Learn in a way that sticks
- **Always learn inside a sentence, with audio.**
- **Learn word families:** *decide → decision → decisive → undecided* (one word becomes four).
- **Learn collocations:** *reach a conclusion, heavy rain, strongly believe*.
- **Learn prefixes, suffixes and roots:** about 30 common ones (*un-, re-, mis-, pre-, -tion, -able, -ment, -ful, -less*) unlock hundreds of words.
- **Personal memory hook:** write your own mnemonic or a sentence about your life for hard words.
- **Mix input and output:** recognise it (read), hear it (listen), then use it (speak or write).

### 18.4 Step 3: A realistic pace
- **8-12 new words per day** + SRS reviews, which is about **3,000+ words per year**.
- **Review first, then learn new.** If 40 reviews are due, finish them before adding new words.
- **Retire words you truly know** ("I already know this" button), so review stays short.
- Cap new words when reviews pile up (e.g., if more than 60 reviews are due, add 0-3 new words only).

### 18.5 Step 4: Learn from real material
Every time you read or listen to anything, **save 3-5 unknown words with the original sentence**. This beats random lists because the word already has context in your brain. Add a **source tag** (e.g., BBC article, podcast name).

### 18.6 Word card design (what each card should contain)
- Word + part of speech + IPA + audio
- Simple English definition (learner-dictionary style)
- 1-2 natural example sentences (6-14 words)
- **Word family** list
- **Collocations** (2-4 common ones)
- **Register tag** (formal / neutral / informal)
- **Nuance note** (if there are near-synonyms)
- Your own sentence and mnemonic (optional but powerful)
- Source (where you found it)

### 18.7 Vocabulary milestones

| Time | New solid words | Notes |
|------|-----------------|-------|
| 4 weeks | 300+ | Gaps in NGSL filled |
| 3 months | ~1,000 | Graded B2 articles readable with little dictionary use |
| 6 months | ~2,000 | News articles at normal speed |
| 12 months | ~3,000+ | C1-level reading range begins |

---

## 19. Long-Sentence Understanding Plan

### 19.1 Why long sentences feel hard
1. **Unknown words break the chain.** (see 18.1)
2. **You can't see the structure.** A long sentence is usually a short core (who did what) with layers attached: *which, although, because, having done...*. Without finding the core, everything seems equally important.
3. **Working memory overload.** Reading word by word means you forget the start by the end. Skilled readers read in **chunks of 3-6 words**.

### 19.2 The "X-Ray" method (paper or in-app)
1. **Find the main verb and its subject.** Ask "Who did what?"
2. **Cut off the extras:** time (*when*), reason (*because*), contrast (*although, whereas*), extra information (*which, who, that...*).
3. **Chunk** the sentence into short meaningful pieces.
4. **Reassemble** by adding one layer at a time.

**Worked example:**
> *The committee, which had been criticized for its slow response, finally announced that it would review the policy, although several members remained skeptical.*

| Part | Meaning |
|------|---------|
| **Core** | The committee announced (that it would review the policy). |
| Extra 1 | *which had been criticized for its slow response* (extra information about the committee) |
| Extra 2 | *finally* (time/manner) |
| Extra 3 | *although several members remained skeptical* (contrast) |

**Meaning in simple words:** *The committee announced a policy review. It had been criticized earlier, and some members still doubted it.*

### 19.3 Signal words to master (connectors)
| Function | Words |
|----------|-------|
| Contrast | but, however, although, whereas, despite, in spite of, nevertheless |
| Reason / result | because, since, therefore, as a result, so that, consequently |
| Addition | moreover, in addition, besides, furthermore |
| Condition | if, unless, provided that, as long as |
| Reference | which, this, those, it, they (always ask: "what does it refer to?") |
| Time | while, before, after, until, as soon as, meanwhile |

### 19.4 Habits that help immediately
- **Read in chunks**, moving your eyes in short phrases, not word by word.
- **Don't look up every unknown word.** Skip, finish the sentence, guess from context. Look up only if the word blocks the meaning.
- **Read + listen together.** Reading with matching audio trains your brain to hear sentence rhythm and chunk boundaries.
- **Paraphrase aloud:** after a sentence, say it in your own simple words. If you can't, you didn't fully understand it.
- **Re-read the same text a second time.** Understanding rises sharply on the second pass.
- **Slow down on purpose** for 2-3 hard sentences a day instead of rushing through a whole page.
- **Mark the signal words** (highlight connectors) before reading the rest.

### 19.5 Sentence difficulty ladder (for the app's content)
| Level | Sentence type | Example pattern |
|-------|---------------|-----------------|
| 1 | Simple (8-10 words) | Subject + verb + object |
| 2 | Compound (12-15 words) | Two ideas joined by *and / but / so* |
| 3 | One relative clause | *The man who called you...* |
| 4 | Concession or reason clause | *Although..., ... / ..., because...* |
| 5 | Two or more layers | Relative + concession + participle |
| 6 | Academic/legal style (25-40 words) | Nominalisation, passives, nested clauses |

Move up a level only after **80%+ accuracy** on the current one.

---

## 20. New Games for My Weak Points

### 20.1 Long-sentence games

| Game | How it works | Fixes |
|------|--------------|-------|
| **Sentence X-Ray** | A long sentence appears. Tap the main subject, then the main verb, then the extras. Instant feedback with the correct breakdown. | Finding the core |
| **Layer Builder** | Start with a short sentence ("The man left."). Add one layer at a time (*who, where, why, although...*) to build a long one. | Structure and writing |
| **Slice It** | Drag cut-lines to chunk a sentence into meaning groups. | Chunking |
| **Connector Match** | Fill the gap: *however / therefore / although / whereas*. | Logical flow |
| **Reference Hunter** | Tap what "this / which / it / they" points to. | Tracking meaning |
| **Summarize in 10 Words** | Read a long sentence, write its meaning in 10 words or fewer. | Comprehension |
| **Sentence Race (read + audio)** | Sentence is read aloud while words highlight; answer a quick question. | Chunking, listening link |

### 20.2 Vocabulary games

| Game | How it works | Fixes |
|------|--------------|-------|
| **Context Detective** | Guess a hidden word's meaning from the surrounding sentence. | Unknown words while reading |
| **Prefix and Suffix Lab** | Build and break words (*un-happy, happi-ness*). | Word-building |
| **Word Family Tree** | Fill all forms: *decide / decision / decisive*. | Vocabulary multiplier |
| **Collocation Forge** | Complete natural word pairs under time pressure. | Natural phrasing |
| **Nuance Duel** | Pick the best near-synonym in context. | Precision |
| **From-the-Wild Review** | Review words you saved from real articles/podcasts, showing the original sentence. | Real-world transfer |
| **Define It Yourself** | See a word, explain it in your own English words, then compare with the dictionary. | Active recall |

### 20.3 Rules for these games
1. After every wrong answer, show the **breakdown** (core, layers, connectors), not just the correct answer.
2. Re-queue missed sentences within the same session and again via SRS.
3. Always give **audio** of the whole sentence, with word-by-word highlighting.
4. Track **accuracy by sentence level** (1-6) to auto-adjust difficulty.
5. Cap each game round at 60-120 seconds.

---

## 21. Database and Code Additions

### 21.1 Extra tables

```sql
-- Word families (decide / decision / decisive / undecided)
CREATE TABLE word_family (
  id INTEGER PRIMARY KEY,
  root TEXT NOT NULL,
  member_word_id INTEGER REFERENCES word(id),
  form_type TEXT            -- noun, verb, adjective, adverb, negative
);

CREATE TABLE collocation (
  id INTEGER PRIMARY KEY,
  word_id INTEGER REFERENCES word(id),
  phrase TEXT NOT NULL,     -- e.g. "reach a conclusion"
  register TEXT             -- formal / neutral / informal
);

-- Extra fields for the word table (add via migration)
-- ALTER TABLE word ADD COLUMN register TEXT;
-- ALTER TABLE word ADD COLUMN nuance_note TEXT;
-- ALTER TABLE word ADD COLUMN source TEXT;          -- "BBC article", "podcast X"
-- ALTER TABLE word ADD COLUMN user_mnemonic TEXT;
-- ALTER TABLE word ADD COLUMN user_sentence TEXT;

-- Long sentences with structure annotation
CREATE TABLE sentence_structure (
  id INTEGER PRIMARY KEY,
  sentence TEXT NOT NULL,
  level INTEGER,                 -- difficulty ladder 1..6
  word_count INTEGER,
  subject_span TEXT,             -- e.g. "0-1"  (token indices)
  verb_span TEXT,                -- e.g. "13-14"
  chunks_json TEXT,              -- ["The committee,", "which had been criticized...", ...]
  layers_json TEXT,              -- [{"type":"relative","span":"2-9"}, {"type":"concession","span":"..."}]
  connectors_json TEXT,          -- ["although"]
  simple_meaning TEXT,           -- paraphrase shown after answering
  audio_path TEXT
);

-- Saved "from the wild" items
CREATE TABLE wild_item (
  id INTEGER PRIMARY KEY,
  word_id INTEGER,
  sentence TEXT,
  source TEXT,
  saved_at INTEGER
);

-- Per-skill estimated CEFR over time
CREATE TABLE skill_level (
  id INTEGER PRIMARY KEY,
  skill TEXT,                    -- reading/writing/listening/speaking/vocab
  cefr_estimate TEXT,            -- B2, B2+, C1...
  score REAL,
  measured_at INTEGER,
  source TEXT                    -- 'monthly_mock' | 'placement' | 'self_report'
);
```

### 21.2 "New-word cap" logic (protects you from review overload)

```dart
int newWordsAllowedToday(int dueReviews, int dailyTarget) {
  if (dueReviews > 80) return 0;
  if (dueReviews > 60) return 3;
  if (dueReviews > 40) return (dailyTarget * 0.5).round();
  return dailyTarget;               // e.g. 8-12
}
```

### 21.3 Auto-adjust sentence difficulty (keep accuracy about 75-85%)

```dart
int nextSentenceLevel(int current, double acc, int roundsAtLevel) {
  if (acc >= 0.85 && roundsAtLevel >= 3 && current < 6) return current + 1;
  if (acc <  0.60 && current > 1) return current - 1;
  return current;
}
```

### 21.4 Scoring the X-Ray game
```dart
// Student taps subject / verb / extras. Compare with annotated spans.
double xrayScore(Set<int> tappedSubject, Set<int> correctSubject,
                 Set<int> tappedVerb,    Set<int> correctVerb,
                 Set<int> tappedExtras,  Set<int> correctExtras) {
  double j(Set<int> a, Set<int> b) =>
      (a.intersection(b).length) / (a.union(b).isEmpty ? 1 : a.union(b).length);
  return 0.35 * j(tappedSubject, correctSubject)
       + 0.35 * j(tappedVerb, correctVerb)
       + 0.30 * j(tappedExtras, correctExtras);   // Jaccard similarity
}
```

### 21.5 Content pipeline note
Annotating sentence structure by hand is slow. Efficient options:
1. Start with **100-200 hand-annotated sentences** (levels 3-6) from your own reading.
2. Use an **offline NLP tool on your PC** (e.g., spaCy dependency parser) to auto-draft subject/verb/clauses, then **manually check** before putting it into the app's database.
3. The app itself only reads the final JSON; no NLP model needs to run on the phone.

---

## 22. Updated 30-Minute Daily Plan and Targets

### 22.1 Daily plan (vocabulary + long-sentence focus)

| Min | Activity | Skill |
|-----|----------|-------|
| 8 | **SRS review** (due words first, shown in sentences) | Vocabulary |
| 5 | **Learn 8-10 new words** (sentence, audio, word family, collocation) | Vocabulary |
| 8 | **Read one passage**; apply X-Ray on 2-3 hard sentences; save unknown words to "From the wild" | Reading |
| 5 | **Listen to the same passage** (audio), then shadow 3 sentences | Listening + Speaking |
| 4 | **Write 2 sentences** with today's words, then expand one using Layer Builder | Writing |

**Minimum day (5 min):** SRS review + one X-Ray sentence. The streak still counts.

### 22.2 Add-on blocks for real-world input (outside the app)
- **30 min** listening (podcast/TED/documentary) a day, or split into two 15-min sessions.
- **15-30 min** reading (news article/novel chapter).
- **2 min** speaking recording on a random topic.
- Log each in the app's **"Real English Log"** (minutes + one new phrase learned) so these count toward your streak.

### 22.3 Weekly routine
| Day | Extra focus |
|-----|-------------|
| Mon | New words + Prefix/Suffix Lab |
| Tue | Long-sentence games (X-Ray, Slice It) |
| Wed | Collocations + Writing |
| Thu | Listening (Lecture Notes) |
| Fri | Speaking (Debate Mode / 60-Second Talker) |
| Sat | Weekly Boss + **Mistake Notebook review (30 min)** |
| Sun | Light: read for pleasure, re-read last week's text and notice how much easier it is |

### 22.4 Targets and checks

| Time | Vocabulary | Long sentences | Check |
|------|------------|----------------|-------|
| 4 weeks | +300 words | X-Ray works on 20-25 word sentences | Placement re-test |
| 3 months | +1,000 words | Level 4 sentences at 80%+ | Monthly mock + 2-min speech sample |
| 6 months | +2,000 words | Level 5 sentences at 80%+ | Mock vs. C1 sample paper |
| 12 months | +3,000 words | Level 6 sentences at 75%+ | Full mock (all 4 skills) |

### 22.5 Monthly checkpoint (30 minutes)
1. Re-take the placement test and compare the CEFR estimate **per skill**.
2. Record a 2-minute speech on the same prompt as last month; listen to both.
3. Write a 150-250 word text on the same prompt as last month.
4. Read one unseen passage and take the quiz; record your reading speed.
5. Dictate 10 unseen sentences.
6. Update the `skill_level` table and look at the graph.

---

## 23. Updated Roadmap for the C1/C2 Goal

### Phase 1: MVP (Week 1-6): *replace the action game*
- Anagram Wheel, Sentence Unscrambler, Vocabulary Sprint (with SM-2)
- XP, levels, streak, reminder
- **Import NGSL + gap finder** (mark known/unknown words)
- Word cards with word family and collocations

### Phase 2: Fix the weak points (Week 7-12)
- **Sentence X-Ray, Slice It, Connector Match, Layer Builder**
- **Context Detective, Prefix and Suffix Lab, Word Family Tree**
- Reading module with tap-to-define and "save to From the wild"
- New-word cap logic, "I already know this" button
- Listening: Dictation Dash, Sound Sniper
- **Word Siege** (replaces the SRS review screen as the fun way to clear reviews)
- **Chunk Echo** (long-sentence listening and memory)

### Phase 3: Four-skill expansion (Month 4-6)
- Speaking: recorder, shadowing, offline ASR (Vosk), 60-Second Talker
- Writing: Word Forge, Error Hunter, Daily 3 Sentences, journal
- Mock tests + monthly checkpoint + per-skill CEFR graph
- Weekly Boss, achievements, backup/restore

### Phase 4: C1 push (Month 7-12)
- Nuance Duel, Register Shifter, Paraphrase Blitz, Collocation Forge
- Lecture Notes, Debate Mode, Cohesion Fixer
- **Paragraph Architect** (levels 4-6), cohesion map
- Authentic-speed audio, no-replay Challenge mode
- Real English Log, AWL/NAWL/C1 content packs

### Phase 5: C2 push (Year 2+)
- Advanced idioms, literary and academic registers, style analysis
- FSRS scheduler
- Optional on-device LLM for writing and conversation feedback
- Long-form reading goals (novels, essays) with vocabulary tracking
- Regular human feedback sessions for speaking and writing

> 🎯 **Golden rule (unchanged):** ship Phase 1 fast, use it every day, and let your real weak points (vocabulary and long sentences) guide what you build next.

### Final checklist for this update
- [ ] Gap-finder run on the NGSL; unknown words imported to SRS
- [ ] Word cards include family, collocations, register, source
- [ ] At least 100 annotated long sentences (levels 3-6)
- [ ] X-Ray and Slice It games working
- [ ] New-word cap protects against review overload
- [ ] "From the wild" saving flow built into the reading screen
- [ ] Per-skill CEFR estimates tracked monthly
- [ ] Real English Log (listening/reading minutes) counts toward the streak
- [ ] Monthly mock test on a real C1 sample
- [ ] Word Siege, Paragraph Architect and Chunk Echo playable offline (see 24.6)

---

---

## 24. 🆕 Three New Games (Action-Style, Built for My Weak Points)

> These three games were added to give the app more **"real game" energy** (enemies, waves, combos, speed) while still hitting my two weak points: **vocabulary** and **long sentences**. Each one reuses the existing SRS, XP, streak and Mistake Notebook systems, so no new learning engine is needed.

| # | Game | Skills | Fixes | Feels like |
|---|------|--------|-------|------------|
| 1 | ⚔️ **Word Siege** | 🔤 Vocabulary, ✍️ Spelling | Limited vocabulary | Tower defense / typing shooter |
| 2 | 📑 **Paragraph Architect** | 📖 Reading, 🧩 Grammar | Long text, cohesion, connectors | Drag-and-drop puzzle builder |
| 3 | 🔊 **Chunk Echo** | 🎧 Listening, 📖 Reading | Long sentences, working memory | Memory / rhythm game |

---

### 24.1 ⚔️ Word Siege (Vocabulary, action style)

**Idea:** Enemy "word cards" march toward your gate. Each enemy shows a **definition, a sentence with a gap, or a synonym clue**. Defeat it by giving the correct word before it reaches the gate. This is the closest thing in the app to my old action game.

**Screen layout (portrait):**
- Top bar: gate HP (hearts), wave number, score, combo meter.
- Middle: 3 lanes. Enemies walk down the lanes at different speeds.
- Bottom: input area. **Typing mode** (C1 default) shows a keyboard; **Tap mode** (warm-up) shows 4 word buttons for the front enemy.

**Core loop (one round = 3 waves, about 90-120 seconds):**
1. Wave starts. 4-6 enemies spawn, drawn from **SRS due words first**, then new words, then "From the wild" words.
2. The player answers the **front-most** enemy (closest to the gate) first.
3. Correct = enemy explodes, +XP, combo +1, audio plays the word and its example sentence in a short, non-blocking toast.
4. Wrong = the enemy flashes red, the correct word is shown for 1.5 s, the enemy stays alive and speeds up slightly.
5. An enemy reaching the gate = −1 HP, and the word is added to the **Mistake Notebook** and re-queued in wave 3 of the same round.
6. Wave 3 contains a **Boss**: a long sentence with 2 gaps (trains vocabulary inside long sentences).

**Modes (pick before the round, or let Daily Plan choose):**
| Mode | Clue shown | Answer |
|------|-----------|--------|
| Meaning → Word | English definition | The word |
| Sentence Gap | Sentence with `____` | The word in the right form |
| Synonym Strike | A synonym or near-synonym | The target word |
| Collocation Siege | `make a ____` / `heavy ____` | The missing partner word |
| Word Family | `decide → (noun) ____` | `decision` |

**Power-ups (earned, not bought):**
- ❄️ **Freeze** (earn at combo x5): enemies stop for 4 s.
- 🔊 **Echo** (earn at combo x8): plays audio of the front enemy's answer. Counts as a **hint**.
- 💥 **Bomb** (earn at combo x12): clears one lane. The cleared words are marked "seen, not recalled" and re-queued.

**Difficulty auto-tuning (keep accuracy about 75-85%):**
- Spawn interval and walking speed are scaled by recent accuracy (see code below).
- Level 1-2: tap mode, A2-B1 words. Level 3-4: typing mode, B2 words. Level 5-6: typing mode, C1 words, boss every wave, no Echo allowed.

**SRS integration (important):**
| Result | SM-2 quality |
|--------|--------------|
| Typed correctly in under 3 s, no hint | 5 |
| Typed correctly in 3-6 s | 4 |
| Correct but slow (>6 s) or tap mode | 3 |
| Correct with Echo hint | 3 |
| Wrong answer then corrected | 2 |
| Enemy reached the gate | 1 |
| Bomb used on this word | 1 |

**Anti-frustration rules:**
- Wave pace never makes the player feel unfairly rushed: at most **2 enemies can reach the gate in one wave** before the game pauses with "Take a breath" and offers Tap mode.
- Accept **minor spelling slips** in Level 1-3 (1 letter off) but show the correct spelling. In Level 5-6, require exact spelling.
- Accept valid alternatives (US/UK spelling: *colour/color*).

**"What you learned" end screen:** all words from the round, each with the example sentence, audio button, and a ⭐ "save to Mistake Notebook" toggle. Show words defeated vs. words that reached the gate.

**Scoring:**
```
points = base(level) * speedMultiplier * (1 + 0.1 * min(combo, 10)) - hintPenalty
speedMultiplier: <3s = 1.5, 3-6s = 1.2, >6s = 1.0
hintPenalty: Echo = 30% of base
Boss correct = 3x base
```

**Dart reference code:**
```dart
enum SiegeMode { meaningToWord, sentenceGap, synonymStrike, collocation, wordFamily }

class SiegeEnemy {
  final int cardId;
  final String clue;          // shown to the player
  final String answer;        // canonical answer
  final List<String> accepted; // alternate spellings/forms
  final bool isBoss;
  double y = 0;               // 0 = spawn, 1 = gate
  SiegeEnemy(this.cardId, this.clue, this.answer,
      {this.accepted = const [], this.isBoss = false});
}

// Pace control: higher accuracy -> faster waves
double enemySpeed(double recentAcc, int level) {
  final base = 0.06 + 0.012 * level;           // screen heights per second
  if (recentAcc > 0.85) return base * 1.15;
  if (recentAcc < 0.60) return base * 0.80;
  return base;
}

int srsQuality({required bool correct, required int ms,
    required bool tapMode, required bool usedHint, required bool reachedGate}) {
  if (reachedGate) return 1;
  if (!correct) return 2;
  if (usedHint || tapMode || ms > 6000) return 3;
  return ms < 3000 ? 5 : 4;
}

bool isAnswerOk(String input, SiegeEnemy e, int level) {
  final s = input.trim().toLowerCase();
  final all = [e.answer, ...e.accepted].map((x) => x.toLowerCase());
  if (all.contains(s)) return true;
  if (level <= 3) return all.any((a) => levenshtein(a, s) <= 1); // forgiving
  return false;
}
```

**Content format (JSON, loaded at first run):**
```json
{
  "cardId": 1042,
  "mode": "collocation",
  "clue": "make a ____ (choose between options)",
  "answer": "decision",
  "accepted": [],
  "example": "She had to make a decision before Friday.",
  "cefr": "B2"
}
```

---

### 24.2 📑 Paragraph Architect (Reading, cohesion, long text)

**Idea:** A paragraph arrives **cut into shuffled sentences**. Drag them into the order that makes the best logical flow. The player learns to use **connectors, pronouns, time order and topic sentences**, which is exactly what is needed to follow long, dense text at C1.

**Core loop (one round = 1 paragraph, about 90-150 seconds):**
1. Show 4-8 sentence cards in a shuffled list.
2. The player drags cards into order. Tap a card to hear it (TTS or recorded audio).
3. Press **Check**. Each adjacent pair is checked, not only the final order.
4. Result screen shows a **Cohesion Map**: arrows connecting sentences, labelled with the cue that links them (*"This" refers to the previous idea*, *However = contrast*, *First → Then*).
5. Wrong placements are re-queued as a new shuffled paragraph later (same session and via SRS).

**Levels:**
| Level | Sentences | Cues | Example topic |
|-------|-----------|------|---------------|
| 1 | 4 | Obvious time words (*first, then, finally*) | A daily routine |
| 2 | 5 | Pronoun chains (*Maria... She... Her*) | Short biography |
| 3 | 5-6 | Connectors (*however, therefore*) | A news story |
| 4 | 6 | Reference words (*this, such, the latter*) | A science explainer |
| 5 | 7 | Subtle cues: given → new information, definite articles | Opinion paragraph |
| 6 | 8 | Few explicit cues; needs logic and topic flow | Academic or literary paragraph |

**Helper tools (each costs XP, never blocked):**
- 🔦 **Highlight connectors:** underlines linking words in all cards (−10% XP).
- 📌 **Pin the opener:** reveals which sentence starts the paragraph (−20% XP).
- 🔗 **Show one link:** reveals one correct adjacent pair (−15% XP).

**Bonus mini-task after a correct order (optional, +XP):** a one-tap question: *"What does 'this' in sentence 4 refer to?"* This reinforces reference tracking (links to Reference Hunter).

**Scoring:**
```
pairScore = correct adjacent pairs / (n - 1)
exactBonus = +25% if the full order is exactly right
accepted orders: store 1-3 valid orders per paragraph in the data
```

**Dart reference code:**
```dart
// order = list of sentence ids in the player's order
// validOrders = list of acceptable correct orders
double paragraphScore(List<int> order, List<List<int>> validOrders) {
  double best = 0;
  for (final v in validOrders) {
    int ok = 0;
    for (int i = 0; i < order.length - 1; i++) {
      final a = order[i], b = order[i + 1];
      final ia = v.indexOf(a);
      if (ia >= 0 && ia + 1 < v.length && v[ia + 1] == b) ok++;
    }
    final pair = ok / (order.length - 1);
    final exact = _listEq(order, v) ? 0.25 : 0.0;
    best = [best, (pair + exact).clamp(0.0, 1.0)].reduce((a, b) => a > b ? a : b);
  }
  return best;
}
```

**Content format (JSON):**
```json
{
  "id": 301,
  "level": 3,
  "topic": "technology",
  "sentences": [
    {"id": 1, "text": "Many companies have moved their meetings online."},
    {"id": 2, "text": "However, this change has not suited everyone."},
    {"id": 3, "text": "Some employees feel isolated when they work from home."},
    {"id": 4, "text": "As a result, several firms now offer hybrid schedules."}
  ],
  "validOrders": [[1, 2, 3, 4]],
  "links": [
    {"from": 1, "to": 2, "cue": "However", "type": "contrast"},
    {"from": 2, "to": 3, "cue": "this change", "type": "reference"},
    {"from": 3, "to": 4, "cue": "As a result", "type": "result"}
  ]
}
```

**Content pipeline:** take real paragraphs from graded readers and news articles you already read, split into sentences, keep the original order as the valid order, and hand-write the `links`. Start with **60 paragraphs (10 per level)**, grow to 200.

---

### 24.3 🔊 Chunk Echo (Listening + long-sentence memory)

**Idea:** Hear a **long sentence once** (or twice at lower levels), then rebuild it from **meaning chunks** (not single words). It trains the exact skill missing for long sentences: holding a 15-25 word sentence in your head and seeing its chunk structure. It is Dictation's smarter cousin and also builds working memory (a "strong mind" feature).

**Core loop (one round = 5 sentences, about 2 minutes):**
1. **Listen:** audio plays the sentence at the chosen speed. The screen shows only a waveform, no text.
2. **Rebuild:** 3-6 chunk tiles appear shuffled (e.g., `Although it was raining` / `the team decided` / `to finish the match` / `without any delay`). The player drags them into order.
3. **Check:** the correct order plays again as audio with the chunks highlighting in rhythm.
4. **Echo (optional, +XP):** the player says the sentence aloud (shadowing). The offline ASR gives a word match %, or the player self-rates if ASR is off.
5. Wrong answers: show the correct chunking and re-queue the sentence at the same level, with **1 extra replay** allowed (see replay rule below).

**Levels (ties to the sentence ladder in section 19.5):**
| Level | Sentence length | Chunks | Replays | Speed |
|-------|-----------------|--------|---------|-------|
| 1 | 8-10 words | 3 | 3 | 0.8x |
| 2 | 11-14 words | 3-4 | 2 | 0.9x |
| 3 | 15-18 words | 4 | 2 | 1.0x |
| 4 | 19-22 words | 4-5 | 1 | 1.0x |
| 5 | 23-26 words | 5 | 1 | 1.1x |
| 6 | 27-32 words | 5-6 | 0 (Challenge) | native speed |

**Replay rule:** a replay costs 10% of the round's XP. Missing a sentence gives the **next attempt** one extra replay so the player is never stuck.

**Modes:**
- **Chunk Rebuild** (default): as above.
- **Gap Echo:** after listening, 2 chunks are blanked and the player types them from memory (higher difficulty, uses active recall).
- **Memory Ladder:** the sentence gets longer each turn by one chunk (*"The man left." → "The man left early." → "The man who lives next door left early."*). It ends when the player fails. A "best ladder" score is stored.

**Scoring:**
```
chunkScore = correct chunk positions / total chunks
roundScore = chunkScore * levelMultiplier - 0.10 * replaysUsed
Echo bonus = +0.2 if ASR match >= 80%
```

**Dart reference code:**
```dart
double chunkScore(List<String> playerOrder, List<String> correctOrder) {
  int ok = 0;
  for (int i = 0; i < correctOrder.length; i++) {
    if (i < playerOrder.length && playerOrder[i] == correctOrder[i]) ok++;
  }
  return ok / correctOrder.length;
}

int replaysAllowed(int level, bool lastWrong) {
  const base = [3, 2, 2, 1, 1, 0];
  return base[(level - 1).clamp(0, 5)] + (lastWrong ? 1 : 0);
}
```

**Content format (JSON):**
```json
{
  "id": 705,
  "level": 3,
  "text": "Although it was raining, the team decided to finish the match without any delay.",
  "chunks": [
    "Although it was raining,",
    "the team decided",
    "to finish the match",
    "without any delay."
  ],
  "audio": "audio/sentences/705_us.mp3",
  "audioSlow": "audio/sentences/705_us_slow.mp3",
  "chunkTimingsMs": [0, 1500, 2600, 3700, 4600]
}
```
`chunkTimingsMs` lets the app highlight each chunk while the audio plays. If you generate audio with an offline TTS on your PC, create these timings during the same step.

---

### 24.4 Database additions for the three games

```sql
-- Paragraph Architect content
CREATE TABLE paragraph (
  id INTEGER PRIMARY KEY,
  level INTEGER,                -- 1..6
  topic TEXT,
  sentences_json TEXT,          -- [{id, text, audio_path}]
  valid_orders_json TEXT,       -- [[1,2,3,4], ...]
  links_json TEXT               -- cohesion map
);

-- Chunk Echo content
CREATE TABLE chunk_sentence (
  id INTEGER PRIMARY KEY,
  level INTEGER,
  text TEXT,
  chunks_json TEXT,
  audio_path TEXT,
  audio_slow_path TEXT,
  chunk_timings_json TEXT
);

-- One row per round of ANY game (feeds charts and the difficulty tuner)
CREATE TABLE game_session (
  id INTEGER PRIMARY KEY,
  game TEXT,                    -- 'word_siege' | 'paragraph_architect' | 'chunk_echo' | ...
  mode TEXT,
  level INTEGER,
  started_at INTEGER,
  duration_ms INTEGER,
  accuracy REAL,
  score INTEGER,
  xp_earned INTEGER,
  hints_used INTEGER,
  extra_json TEXT               -- e.g. best memory ladder, max combo
);

-- Personal bests per game and mode
CREATE TABLE personal_best (
  game TEXT, mode TEXT, metric TEXT, value REAL, set_at INTEGER,
  PRIMARY KEY (game, mode, metric)
);
```
- `srs_card.item_type` gains two new values: `'paragraph'` and `'chunk_sentence'`.
- `review_log.game` uses the new game codes above.

---

### 24.5 Where these games fit in my plan

| Day | Game to prioritize | Replaces / extends |
|-----|--------------------|--------------------|
| Mon | ⚔️ Word Siege (Meaning → Word, Word Family) | The 8-min SRS review block (Siege can run the review) |
| Tue | 🔊 Chunk Echo (levels 3-4) | Long-sentence games block |
| Wed | ⚔️ Word Siege (Collocation Siege) + 📑 Paragraph Architect | Collocations + Writing day |
| Thu | 🔊 Chunk Echo (Memory Ladder) | Listening day |
| Fri | 📑 Paragraph Architect (levels 4-5) | Reading day, plus a speaking round |
| Sat | Weekly Boss includes one round of each game | Boss + Mistake Notebook |
| Sun | Optional light play | Rest |

**Daily Plan Builder rule:** if SRS due cards > 40, **always route the review through Word Siege** (it is the most fun way to clear a backlog). If the player's long-sentence accuracy is the lowest skill, add one Chunk Echo round automatically.

### 24.6 Success checks for the new games
- [ ] Word Siege: 60 fps on a mid-range phone, input latency under 100 ms, accuracy stays in 75-85% over 7 days.
- [ ] Paragraph Architect: at least 60 paragraphs (10 per level) with hand-written link maps.
- [ ] Chunk Echo: at least 100 sentences with audio and chunk timings; levels 1-6 all populated.
- [ ] All three write `game_session` rows and update SRS via `review_log`.
- [ ] Every round ends with the "What you learned" screen.
- [ ] Each game can be played with **zero internet** and **no permission** except microphone (Chunk Echo's optional Echo step).

---

*Updated report: includes C1/C2 goal planning, vocabulary boost, long-sentence understanding, new games (including Word Siege, Paragraph Architect and Chunk Echo), database changes, and a revised roadmap.*
