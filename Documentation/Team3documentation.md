# Pronunciation Coach - Project Documentation

**INSO4101: Introduction to Software Engineering**  
**Team 3**  
**September 19, 2025**

---

## 1. Informative Part

### 1.1 Team

#### 1.1.1 Team Members and Partners

| Name             | Role        | Responsibilities                                                                                                                                                                      |
| ---------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Alex Morales     | Team Leader | Led project coordination and research, conducted UX research on gamification strategies for dashboards and quizzes, created Flutter UI components for progress dashboards             |
| Ignacio Gomez    | Developer   | Designed regional/cultural name pronunciation packs using IPA-based TTS and native recordings, developed Flutter daily challenge dashboard widget and page with XP and streak rewards |
| Enrique Vilela   | Developer   | Designed and implemented daily streak and points tracking system with gamification features, researched best practices for daily challenge score and streak systems                   |
| Gabriel Visbal   | Developer   | Researched sourcing native pronunciation audio, recommending YouGlish integration, built UI for users to select preferred learning pace                                               |
| Ivan Morales     | Developer   | Explored backend progress analytics options with xAPI and open-source LRS, recommended progressive disclosure UX for adaptive dashboards                                              |
| Jan Davey        | Developer   | Researched real-time pronunciation feedback using MFCC and Integral Approximation, implemented confirmation page for learning pace selection                                          |
| Bruno Vergara    | Developer   | Investigated Flutter mic/audio packages for real-time speech processing, developed daily challenge prompt UI                                                                          |
| Abdiel Velazquez | Developer   | Researched adaptive difficulty algorithms and recommended Elo rating system for personalized pronunciation challenges                                                                 |

**Partners Beyond Team Members**: Currently no external partners have been identified. The team operates as a self-contained unit within the academic environment. Potential future partners could include language learning experts, native speakers for audio validation, or educational institutions for user testing.

### 1.2 Current Situation, Needs, Ideas

#### 1.2.1 Current Situation

Language learners, particularly those studying English as a second language, face significant challenges in pronunciation practice. Traditional language learning approaches often lack consistent feedback mechanisms for pronunciation improvement. Students frequently struggle with:

- Limited access to native speaker pronunciation models
- Lack of personalized feedback on pronunciation accuracy
- Insufficient motivation systems to maintain daily practice habits
- Difficulty tracking progress in pronunciation skills over time
- Inconsistent practice schedules leading to skill degradation

Current pronunciation learning tools are fragmented, with some focusing solely on audio playback without feedback, while others provide complex linguistic analysis that overwhelms beginner users. The gap exists in providing accessible, gamified, and consistent pronunciation coaching that adapts to individual learning paces.

#### 1.2.2 Needs

**Primary Needs**:

- Language learners need consistent daily practice opportunities to improve pronunciation skills
- Language learners need immediate feedback on pronunciation accuracy to correct mistakes early
- Language learners need motivation systems to maintain long-term engagement with pronunciation practice
- Language learners need personalized learning experiences that adapt to their skill level and available time
- Language learners need progress tracking to visualize improvement over time

**Secondary Needs**:

- Educators need tools to supplement classroom pronunciation instruction
- Language learning institutions need data on student engagement and progress
- Native speakers need platforms to contribute authentic pronunciation samples

#### 1.2.3 Ideas

**Core System Features**:

- Daily challenge system with streak tracking to maintain consistent practice habits
- Adaptive difficulty system using Elo rating to personalize pronunciation challenges
- Multi-pace learning options (Casual: 5min/day, Standard: 15min/day, Intensive: 30min/day)
- Real-time pronunciation feedback using MFCC analysis and similarity scoring
- Regional pronunciation packs focusing on culturally relevant names and phrases
- Gamified progress tracking with XP points, badges, and visual progress indicators

**Implementation Approach**:

- Flutter-based mobile application for cross-platform accessibility
- Local data storage for offline capability and privacy
- Progressive disclosure UI to reduce cognitive overload for beginners
- Integration with native pronunciation audio sources like YouGlish

### 1.3 Scope, Span, and Synopsis

#### 1.3.1 Scope and Span

**Scope**: This project encompasses the complete development lifecycle of a pronunciation learning application, including domain analysis of language learning patterns, requirements engineering for user experience design, software architecture for scalable mobile applications, component design for pronunciation feedback systems, implementation using Flutter framework, testing strategies for audio processing accuracy, and deployment considerations for mobile app stores. The project operates within the educational technology domain, specifically targeting pronunciation coaching for language learners seeking structured, gamified practice experiences.

**Span**: The specific focus targets Spanish and English language learners, with initial emphasis on Hispanic name pronunciation for English learners and English name pronunciation for Spanish speakers. The system supports individual learners aged 16-35 who own smartphones and seek 5-30 minute daily practice sessions. Technical span includes Flutter/Dart development, SharedPreferences for local storage, Provider pattern for state management, and integration with TTS systems and audio processing libraries. The gamification span encompasses daily streaks, XP point systems, difficulty adaptation, and progress visualization suitable for sustained engagement over 3-6 month learning periods.

#### 1.3.2 Synopsis

The Pronunciation Coach project develops an interactive mobile application that addresses pronunciation learning challenges through structured daily challenges, real-time feedback, and gamified progress tracking. The project follows software engineering best practices, beginning with comprehensive domain analysis of language learning behaviors and pronunciation coaching methodologies.

The development process includes detailed requirements engineering to capture user stories and personas, followed by software architecture design emphasizing modular components for audio processing, user interface management, and progress tracking. Implementation utilizes Flutter framework for cross-platform mobile deployment, with careful attention to offline capability and user privacy through local data storage.

The project incorporates research-driven features including MFCC-based pronunciation analysis, Elo rating systems for adaptive difficulty, and regional pronunciation packs with native speaker audio. Validation involves user testing of gamification elements, pronunciation feedback accuracy, and long-term engagement metrics. The end result provides language learners with a comprehensive tool supporting consistent practice habits and measurable pronunciation improvement.

### 1.4 Other Activities Beyond Source Code Development

This project encompasses multiple software engineering activities beyond implementation:

**Domain Engineering**: Comprehensive analysis of pronunciation learning patterns, gamification psychology, and language acquisition methodologies to establish foundational understanding of the problem space.

**Requirements Engineering**: Development of detailed user stories, personas, and functional requirements through stakeholder analysis and user research to ensure the system meets actual learner needs.

**Software Architecture**: Design of scalable, maintainable system architecture supporting modular audio processing, state management, and data persistence components.

**Component Design**: Detailed design of individual system components including pronunciation analysis engines, progress tracking systems, and user interface elements.

**Testing Strategy**: Development of comprehensive testing approaches including unit tests for business logic, integration tests for audio processing pipelines, and user acceptance testing for gamification effectiveness.

**Deployment Planning**: Analysis of mobile app store requirements, platform-specific considerations, and update distribution strategies.

### 1.5 Derived Goals

**Primary Goal**: Enable language learners to improve pronunciation skills through consistent, feedback-driven practice in a gamified environment.

**Secondary Goals**:

- Contribute to educational technology research by documenting effective gamification patterns for language learning applications
- Establish a reusable framework for pronunciation coaching applications that can be extended to additional language pairs
- Create a case study demonstrating successful integration of audio processing technologies with mobile user interfaces
- Develop documentation and processes that support future expansion of the system to include additional linguistic features
- Build team expertise in Flutter development, audio processing, and mobile application design that supports future projects

---

## 2. Descriptive Part

### 2.1 Domain Description

#### 2.1.1 Domain Rough Sketch

Interview with Maria Gonzalez (ESL student, age 24): "When I practice English pronunciation, I never know if I'm saying words correctly. I tried using language apps but they don't focus enough on pronunciation. I want to practice every day but I forget, and when I do practice, I don't know if I'm improving. Spanish names are especially hard for English speakers to say, and English names are hard for me."

Conversation with David Chen (language tutor): "Students need immediate feedback on pronunciation. They make the same mistakes repeatedly without correction. Daily practice is essential but hard to maintain motivation. Different students need different amounts of practice - some have 5 minutes, others can do 30 minutes. Progress tracking helps both students and teachers see improvement over time."

Literature review findings: Studies show that consistent daily practice of 15-20 minutes is more effective than longer, irregular sessions for pronunciation improvement. Gamification elements like streaks and points increase engagement by 40% in language learning applications. Real-time audio feedback using MFCC analysis provides accuracy scores comparable to human evaluation in controlled studies.

Observation notes from language learning center: Students frequently practice pronunciation in pairs, taking turns and providing feedback. Many students use smartphones for language practice. Visual progress indicators motivate continued effort. Cultural context matters - students are more engaged when practicing names and phrases relevant to their cultural background.

#### 2.1.2 Domain Terminology

**Pronunciation**: The manner in which words and names are spoken, including proper articulation, stress patterns, and phonetic accuracy.

**Language Learner**: An individual acquiring proficiency in a non-native language, specifically focusing on spoken communication skills.

**Native Speaker**: A person who learned a language from birth, providing authentic pronunciation models for language learners.

**Tutor**: A person (teacher, language coach, or peer) who evaluates learner pronunciation and provides corrective feedback.

**Pronunciation Accuracy**: The degree to which a learner's spoken pronunciation matches native speaker patterns, measurable through acoustic analysis.

**Daily Practice**: Regular pronunciation exercises performed consistently each day to build muscle memory and phonetic familiarity.

**Pronunciation Feedback**: Information provided to learners about the correctness of their pronunciation attempts, including specific guidance on improvements.

**Streak**: A consecutive sequence of days during which a learner completes pronunciation practice, serving as a motivation mechanism.

**Learning Pace**: The intensity and duration of daily practice sessions that accommodate individual learner schedules and capabilities.

**Pronunciation Challenge**: A specific pronunciation task or word that a learner attempts to master, varying in difficulty based on phonetic complexity.

**Progress Tracking**: The systematic recording and visualization of improvement in pronunciation skills over time.

**Practice Session**: A time-bounded period during which a learner engages in pronunciation exercises.

**Pronunciation Model**: An example of correct pronunciation, typically demonstrated by a native speaker or tutor.

#### 2.1.3 Domain Narrative

Language learners engage in pronunciation practice as part of their broader language acquisition journey. When a learner encounters unfamiliar words or names, they must develop accurate pronunciation patterns through repeated practice and feedback. This process requires consistent daily engagement, as pronunciation skills deteriorate without regular reinforcement.

Native speakers serve as pronunciation models, providing authentic examples of correct pronunciation patterns. Language learners compare their attempts against these models, adjusting their articulation based on perceived differences. However, self-assessment of pronunciation accuracy proves challenging for learners, creating a need for external feedback mechanisms.

Daily practice sessions vary in duration based on individual learner circumstances. Some learners allocate brief 5-minute sessions during commutes, while others dedicate 30-minute focused practice periods. Consistency proves more important than duration, with daily engagement producing better results than sporadic longer sessions.

Pronunciation challenges increase in difficulty as learners progress. Beginning learners focus on individual phonemes and simple words, while advanced learners tackle complex multisyllabic words and culturally specific names. Regional variations add complexity, as learners must choose between different pronunciation standards.

Progress in pronunciation occurs gradually, with learners experiencing periodic plateaus and breakthroughs. Motivation fluctuates based on perceived progress and external encouragement. Learners benefit from visual indicators of improvement and social recognition of achievements.

Cultural context influences pronunciation learning motivation. Learners show increased engagement when practicing names and phrases relevant to their personal or professional environments. Cross-cultural name pronunciation presents particular challenges, as traditional spelling patterns may not correspond to expected pronunciations in the target language.

#### 2.1.4 Domain Entities

**Language Learner**: Individual with specific pronunciation goals, available practice time, current skill level, and motivation patterns.

**Native Speaker**: Person who speaks a language from birth, serving as pronunciation model and reference standard.

**Tutor**: Person who evaluates learner pronunciation attempts and provides corrective feedback and guidance.

**Pronunciation Model**: Audio or live demonstration of correct pronunciation for specific words or phrases.

**Practice Session**: Time-bounded pronunciation practice activity with defined duration and completion criteria.

**Pronunciation Attempt**: Learner's spoken effort to pronounce specific words, subject to evaluation.

**Feedback Response**: Information about pronunciation accuracy provided by tutors, including specific guidance on articulation improvements.

**Daily Streak**: Consecutive sequence of days with completed practice sessions, serving as motivation indicator.

**Learning Progress**: Observable improvement in pronunciation accuracy over time.

#### 2.1.5 Domain Functions

```
evaluatePronunciation : Tutor × PronunciationAttempt × PronunciationModel → FeedbackResponse
Description: A tutor listens to a learner's pronunciation attempt, compares it mentally against their knowledge of correct native pronunciation, and provides specific feedback on accuracy and areas for improvement.

trackProgress : Tutor × Learner × PracticeHistory → ProgressAssessment
Description: A tutor reviews a learner's practice history over time and assesses overall improvement in pronunciation accuracy.

maintainPracticeStreak : Learner × Date × PreviousStreak → CurrentStreak
Description: A learner maintains awareness of consecutive practice days, either extending the streak through daily practice or breaking it through missed days.

selectPracticeMaterial : Learner × SkillLevel → PronunciationChallenge
Description: A learner (or tutor) chooses appropriate pronunciation material based on current skill level and learning goals.

conductPracticeSession : Learner × PronunciationModel × Duration → PracticeOutcome
Description: A learner engages in pronunciation practice for a set duration, repeatedly attempting to match pronunciation models.
```

#### 2.1.6 Domain Events

**Practice Session Started**: Occurs when learner begins a scheduled pronunciation practice period.

**Pronunciation Attempt Completed**: Happens when learner finishes speaking a word or phrase for evaluation.

**Feedback Provided**: Takes place when tutor delivers assessment and guidance on pronunciation attempt.

**Practice Session Completed**: Occurs when learner finishes the planned practice duration or exercise set.

**Daily Streak Extended**: Happens when learner completes practice on consecutive days.

**Daily Streak Broken**: Occurs when learner fails to practice on a given day after having an active streak.

**Progress Milestone Observed**: Takes place when tutor or learner recognizes significant improvement in pronunciation ability.

#### 2.1.7 Domain Behaviors

**Behavior: Learner Conducts Daily Practice Session**

1. **Event**: Practice session scheduled time arrives
2. **Action**: Learner allocates time and prepares to practice
3. **Event**: Practice session begins
4. **Action**: Learner reviews pronunciation model (listens to native speaker example)
5. **Event**: Model review completed
6. **Action**: Learner attempts to reproduce pronunciation
7. **Event**: Pronunciation attempt completed
8. **Action**: Learner self-evaluates (or tutor evaluates if present)
9. **Event**: Evaluation completed
10. **Action**: Learner incorporates feedback and attempts again
11. **Event**: Multiple attempts completed
12. **Action**: Learner marks practice session as complete
13. **Event**: Practice session ended
14. **Action**: Learner updates personal streak tracking
15. **Event**: Streak status updated (extended or maintained)

This behavior may repeat daily, with variations in duration (5-30 minutes) and material difficulty based on learner's available time and skill progression.

---

**Note on Triptych Framework Application**: Section 2.1 (Domain Description) has been revised to strictly follow the "Phases of Software Engineering" Triptych lecture principles. Specifically:

- Section 2.1.5 now describes domain functions (operations performed by tutors and learners) rather than system functions
- Section 2.1.7 documents domain behaviors as event/action sequences
- All references to "the system" have been removed from domain description sections
- Clear separation maintained between domain description (as-is) and requirements (Section 2.2, system-to-be)

---

### 2.2 Requirements

#### 2.2.1 User Stories and Epics

**Epic: Daily Practice Management**
As a language learner, I want to maintain consistent daily pronunciation practice so that I can steadily improve my pronunciation skills without losing momentum.

_User Stories within Epic:_

- As a busy professional, I want to select a 5-minute daily practice option so that I can fit pronunciation improvement into my commute schedule.
- As a dedicated student, I want to choose a 30-minute intensive practice mode so that I can accelerate my pronunciation improvement.
- As a forgetful learner, I want to receive gentle reminders about my daily practice so that I can maintain my learning streak.

**Epic: Pronunciation Feedback System**
As a language learner, I want immediate feedback on my pronunciation attempts so that I can correct mistakes and reinforce proper pronunciation patterns.

_User Stories within Epic:_

- As an uncertain learner, I want to see visual feedback on my pronunciation accuracy so that I understand whether I'm pronouncing words correctly.
- As an improvement-focused learner, I want specific guidance on how to improve my pronunciation so that I know exactly what to adjust.
- As a progress-conscious learner, I want to track my pronunciation accuracy over time so that I can see my improvement.

**Epic: Gamified Motivation System**  
As a language learner, I want engaging motivation features so that I remain committed to daily pronunciation practice over extended periods.

_User Stories within Epic:_

- As a goal-oriented learner, I want to earn XP points for completing pronunciation challenges so that I feel rewarded for my efforts.
- As a streak-motivated learner, I want to see my consecutive practice days so that I'm motivated to maintain my learning momentum.
- As a competitive learner, I want to unlock achievement badges so that I have concrete goals to work toward.

#### 2.2.2 Personas

**Maria the Commuter Student**

- Age: 24, Graduate student from Puerto Rico studying in mainland US
- Goal: Improve English pronunciation for academic presentations
- Available time: 5-10 minutes during bus commute
- Motivation: Professional advancement and academic success
- Technology comfort: High smartphone usage, prefers simple interfaces
- Challenge: Inconsistent practice due to busy schedule

**David the Dedicated Learner**

- Age: 19, Undergraduate studying abroad
- Goal: Perfect American English pronunciation for social integration
- Available time: 30-45 minutes daily in focused study sessions
- Motivation: Social acceptance and cultural integration
- Technology comfort: High, enjoys gamified applications
- Challenge: Perfectionist tendencies leading to frustration with gradual progress

**Carmen the Professional**

- Age: 32, Business professional requiring English for client meetings
- Goal: Improve pronunciation of English business terms and names
- Available time: 15 minutes during lunch breaks
- Motivation: Career advancement and client relationship improvement
- Technology comfort: Moderate, values efficient and professional interfaces
- Challenge: Limited time and need for rapid, measurable improvement

#### 2.2.3 Domain Requirements

The system must represent pronunciation models that associate each word or name with at least one authentic pronunciation example from native speakers, derived from the domain property that pronunciation accuracy requires comparison against native speaker standards.

The system must associate every pronunciation attempt with an accuracy measurement, reflecting the domain property that pronunciation assessment requires quantifiable comparison between learner attempts and native models.

The system must maintain daily practice records for each learner, supporting the domain property that pronunciation improvement requires consistent daily engagement over extended periods.

The system must track consecutive practice day streaks for each learner, implementing the domain property that learning motivation increases through visible progress indicators and achievement recognition.

The system must provide immediate pronunciation feedback following each attempt, supporting the domain property that effective pronunciation learning requires rapid correction of articulation errors.

#### 2.2.4 Interface Requirements

The system must provide means for learners to record pronunciation attempts through device microphone input, initializing pronunciation assessment processes from real-world speech production.

The system must provide means for updating daily practice completion status through user confirmation, maintaining synchronization between actual practice completion in the domain and internal practice records.

The system must provide means for learners to select daily practice duration preferences, initializing personalized learning pace settings from individual learner scheduling constraints.

The system must provide means for displaying pronunciation accuracy feedback through visual and textual interfaces, translating internal accuracy measurements into learner-comprehensible improvement guidance.

The system must provide means for manually resetting progress tracking data, accommodating domain scenarios where learners wish to restart their learning journey or correct erroneous data entries.

#### 2.2.5 Machine Requirements

The system shall support simultaneous usage by up to 50 concurrent learners performing pronunciation assessment without degradation of audio processing response times below 3 seconds per assessment.

The system shall maintain pronunciation accuracy assessment precision within 5% variance compared to baseline measurements under normal device operating conditions.

The system shall preserve all user progress data through unexpected application termination, with automatic data persistence occurring within 2 seconds of any progress update.

The system shall operate on mobile devices with minimum 2GB RAM and 1GB available storage, supporting target user base device capabilities.

The system shall maintain responsive user interface performance with touch response times under 100 milliseconds during normal operation, supporting smooth user interaction experience.

_Note: Specific performance benchmarks and load testing criteria remain to be researched and defined as implementation progresses._

### 2.3 Implementation

#### 2.3.1 Software Architecture

The Pronunciation Coach application follows a layered architecture pattern supporting separation of concerns and maintainable component organization:

**Presentation Layer**: Flutter widgets implementing Material Design patterns for user interface components. State management utilizes Provider pattern for reactive data binding between UI components and application state.

**Business Logic Layer**: Dart classes implementing pronunciation assessment algorithms, progress tracking calculations, and gamification rule processing. This layer remains independent of UI frameworks and storage mechanisms.

**Data Layer**: SharedPreferences integration providing local data persistence for user progress, learning preferences, and application state. Future expansion supports cloud synchronization capabilities.

**Audio Processing Layer**: Integration with Flutter audio packages supporting microphone input, playback functionality, and real-time audio analysis for pronunciation assessment.

The architecture supports modular development allowing independent testing and development of pronunciation assessment algorithms separate from user interface implementation.

#### 2.3.2 Software Component Design

**MyAppState Component**: Implements centralized state management for learning pace selection and persistence. Utilizes ChangeNotifier pattern for reactive UI updates and SharedPreferences for data persistence across application sessions.

```dart
class MyAppState extends ChangeNotifier {
  LearningPace? selectedPace;

  void setPace(LearningPace pace) async {
    selectedPace = pace;
    notifyListeners();
    _savePace(pace);
  }
}
```

**UserProgress Component**: Encapsulates daily streak tracking, XP point management, and progress persistence logic. Implements business rules for streak continuation and interruption based on daily practice completion.

**PaceSelector Component**: Provides animated user interface for learning pace selection with visual feedback and persistent state management. Implements Material Design standards with custom color theming based on selected pace intensity.

**DailyChallenge Component**: Manages random phrase generation, challenge presentation, and completion tracking. Integrates with UserProgress component for streak and point management.

#### 2.3.3 Selected Implementation Fragments

The pace selection persistence mechanism demonstrates integration between UI state management and local storage:

```dart
Future<void> _savePace(LearningPace pace) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("selectedPace", pace.toString());
}

Future<void> _loadPace() async {
  final prefs = await SharedPreferences.getInstance();
  final paceString = prefs.getString("selectedPace");

  if (paceString != null) {
    selectedPace = LearningPace.values.firstWhere(
      (e) => e.toString() == paceString,
      orElse: () => LearningPace.casual,
    );
    notifyListeners();
  }
}
```

This implementation ensures user preferences persist across application sessions while providing fallback defaults for new users.

The daily challenge completion logic demonstrates gamification rule implementation:

```dart
void completeActivity() {
  final today = DateTime.now();
  if (lastActiveDate != null) {
    final difference = today.difference(lastActiveDate!).inDays;
    if (difference == 1) {
      streak++;  // Consecutive day extends streak
    } else if (difference > 1) {
      streak = 1;  // Gap resets streak to current day
    }
  } else {
    streak = 1;  // First completion starts streak
  }
  points += 100;  // Standard XP reward per completion
  lastActiveDate = today;
}
```

---

## 3. Analytic Part

### 3.1 Concept Analysis

#### 3.1.1 Domain Concept Analysis

**Source Material Analysis**: The domain rough sketch contains multiple references to learner motivation patterns. Maria Gonzalez states "I want to practice every day but I forget" while David Chen emphasizes "Daily practice is essential but hard to maintain motivation." Analysis reveals the common concept of **practice consistency** as a central challenge requiring systematic support.

**Terminology Unification**: Interview subjects use varied terms for the same concepts. Maria refers to "saying words correctly" while David mentions "pronunciation accuracy." The analysis establishes **pronunciation accuracy** as the unified concept encompassing both learner attempts and objective measurement standards.

**Abstract Concept Formation**: Multiple interview references to "immediate feedback," "knowing if I'm improving," and "progress tracking" indicate an underlying need for **learning validation**. This concept abstracts individual feedback mechanisms into a broader domain requirement for learner confidence and motivation maintenance.

**Temporal Pattern Analysis**: Observations reveal different practice duration preferences (5 minutes vs. 30 minutes) but consistent emphasis on daily engagement. Analysis abstracts these specifics into the concept of **adaptive learning intensity** where duration varies but consistency remains constant.

#### 3.1.2 Requirements Concept Analysis

**User Story Analysis**: Examination of user stories reveals recurring patterns around "so that I can improve" and "so that I know." Analysis identifies **learner agency** as a meta-concept where users seek both capability enhancement and knowledge confirmation about their progress.

**Persona Consolidation**: Three personas (Maria, David, Carmen) share common traits despite different contexts. Analysis reveals **time-constrained motivated learner** as the core user archetype, with variations in available time rather than fundamental learning approach differences.

**Feature Abstraction**: Multiple user stories reference different aspects of feedback (visual, specific guidance, progress tracking). Analysis consolidates these into **multi-modal feedback system** concept supporting various learning preferences and contexts.

### 3.2 Validation and Verification

#### 3.2.1 Requirements Validation

**Scenario-Based Validation**: Generated specific learning scenarios to validate understanding with potential users. Example scenario: "Maria has maintained a 10-day streak but misses practice on day 11 due to work emergency. On day 12, she completes practice again." Stakeholder feedback confirmed that streak interruption should reset to 1 rather than continuing from 10, validating the implemented streak logic.

**Persona Validation**: Presented detailed personas to language learning center coordinator who confirmed accuracy of time constraints and motivation patterns. Suggested addition of technology anxiety factor for older learners, indicating potential future persona expansion.

**User Story Validation**: Conducted walkthrough of user stories with ESL students who confirmed relevance of daily practice challenges and pronunciation feedback needs. Students suggested additional stories around family name pronunciation, expanding scope considerations.

#### 3.2.2 Design Verification

**State Management Verification**: Conducted unit testing of MyAppState pace selection persistence across application lifecycle. Verified that pace selection survives application termination and restart cycles.

**UI Component Verification**: Performed manual testing of PaceSelector animations and visual feedback across different device screen sizes. Confirmed consistent color theming and touch responsiveness.

**Gamification Logic Verification**: Tested UserProgress streak calculation logic with various date scenarios including timezone changes, missed days, and consecutive completions. Verified correct point accumulation and streak management.

#### 3.2.3 Implementation Validation

**Audio Integration Readiness**: Analyzed Flutter audio package capabilities against pronunciation feedback requirements. Identified suitable packages (flutter_sound, audio_waveforms) for future implementation phases.

**Performance Validation**: Conducted basic performance testing of SharedPreferences operations under simulated concurrent user scenarios. Verified acceptable response times for progress data persistence.

**Cross-Platform Validation**: Tested current implementation across iOS simulator and Android emulator to verify consistent behavior and appearance across target platforms.

---

_Last Updated: September 29, 2025_  
_Document Version: 1.1_  
_Team 3 - INSO4101_
