---
issue_number: 360
title: "[Lecture Topic Task]: Applying Observer Pattern to User Progress and Achievement Updates"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/360"
author: "Brzno"
labels: [
  "Team 3",
  "Task: lecture-topic",
  "task: development",
  "state: concluded"
]
created_at: "2025-11-23T01:02:59Z"
updated_at: "2025-11-23T15:25:07Z"
---

# [Lecture Topic Task]: Applying Observer Pattern to User Progress and Achievement Updates

- **Issue:** [360](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/360)
- **Author:** @Brzno
- **Labels:** [
  "Team 3",
  "Task: lecture-topic",
  "task: development",
  "state: concluded"
]
- **Created:** 2025-11-23T01:02:59Z

## Details
## 🎯 Objective
Analyze and document how the Observer design pattern can be applied to the Pronunciation Coach app, enabling real-time notifications and UI updates when user progress changes (XP earned, achievements unlocked, streak updates) without tightly coupling components.

---

## 📝 Description
### Context
The Pronunciation Coach app tracks various user progress metrics that need to trigger updates across multiple parts of the application:

- XP changes: When a user completes a quiz, their XP increases and multiple UI components need updating (dashboard, profile, achievements section)
- Achievement unlocks: When progress thresholds are met, achievement badges need to display notifications
- Streak updates: Daily challenge completion affects streak counters shown in multiple screens
- Progress milestones: Reaching certain levels should trigger celebratory animations or messages

### Problem
Without a proper notification system:

- Components must constantly poll for updates or manually refresh data
- Tight coupling between the progress service and all UI components that display progress
- Difficulty adding new features that react to progress changes
- Inconsistent state across different screens when data changes
- Complex dependencies make testing and maintenance harder

### Observer Pattern Solution
The Observer pattern establishes a one-to-many dependency between objects. When the subject (user progress) changes state, all registered observers (UI components) are notified automatically. This allows:

- Automatic UI updates when progress changes
- Loose coupling between data sources and display components
- Easy addition of new observers without modifying existing code
- Centralized event management for progress-related changes

---

## ✅ Acceptance Criteria
Research & Analysis

- [ ] Document at least 3 different observer scenarios for the Pronunciation Coach app
- [ ] Create UML class diagram showing Observer pattern structure for the progress notification system
- [ ] Identify the Subject, Observer interface, and Concrete Observer classes
- [ ] Explain how the pattern applies to the Pronunciation Coach domain

### Documentation Deliverables

- [ ] Create a section analyzing the Observer pattern application (minimum 2 pages)
- [ ] Include:

- Problem statement specific to progress tracking and notifications
- Observer pattern structure diagram
- At least 3 concrete observer implementations described (e.g., AchievementObserver, DashboardObserver, NotificationObserver)
- Code examples or pseudocode showing pattern usage in Flutter/Dart
- Comparison table: benefits vs. drawbacks
- Integration points with existing ProgressService and UserProgress system



### Quality Requirements

- [ ] Document includes proper citations to course materials
- [ ] UML diagrams follow standard notation
- [ ] Analysis connects pattern theory to practical implementation in the app
- [ ] Identifies potential risks or limitations of the approach

---

## 🧪 Testing Plan

-  All sections are complete and well-structured
-  Diagrams are clear and properly labeled
-  Code examples compile/make logical sense
-  Analysis demonstrates understanding of both pattern and domain
-  Diagram Validation: Ensure UML diagram correctly represents Observer pattern structure

---

## ⏱️ Timeframe
Estimated completion time: 1 day

---

## ⚡ Urgency
- [ ] Low  
- [x] Medium  
- [ ] High  

---

## 🎚️ Difficulty
- [ ] Easy  
- [x] Moderate  
- [ ] Hard  

---

## 👨‍💻 Recommended Assigned Developer
Suggested developer: @Brzno  

