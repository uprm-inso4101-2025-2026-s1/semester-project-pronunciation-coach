---
issue_number: 204
title: "[Lecture Topic Task]: Add XP and Achievements Display to User Profile"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/204"
author: "Brzno"
labels: ["Team 3","Task: lecture-topic","task: development","state: in progress"]
created_at: "2025-10-21T01:24:34Z"
updated_at: "2025-10-24T04:19:42Z"
---

# [Lecture Topic Task]: Add XP and Achievements Display to User Profile

- **Issue:** [204](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/204)
- **Author:** @Brzno
- **Labels:** ["Team 3","Task: lecture-topic","task: development","state: in progress"]
- **Created:** 2025-10-21T01:24:34Z

## Details
## 🎯 Objective
Implement XP (Experience Points) and achievements display system in the user profile screen to visualize gamification progress and motivate continued learning. 

---

## 📝 Description

The Pronunciation Coach app currently tracks XP points and daily streaks internally (as documented in Section 2.3.2 UserProgress Component), but doesn't display achievements or detailed XP progression to users in their profile itself. 

***Lecture Topic Connection:***
According to the "Phenomena and Concepts" lecture, entities can be atomic (carrying a single value) or composed (made of multiple parts).  Our current documentation identifies UserProgress as a composed entity containing:

- XP points (atomic - integer)
- Daily streak (atomic - integer)
- Achievements (composed - list of achievement statuses)

***Current Problem:***
While Section 2.3.2 documents the UserProgress component's internal structure, we lack visual representation of these entities in the user interface. The lecture emphasizes that understanding whether entities are atomic or composed helps design proper data structures - but users also need to see these structures represented visually.

***Proposed Solution:***
Add to profile screen:

1. Atomic entities displayed individually:

- Total XP as a prominent number
- Current streak counter
- Individual achievement unlock status

2. Composed entities shown as structured groups:

- Achievement collection showing multiple achievement entities together
- Progress bars demonstrating composition (partial progress toward total)

---

## ✅ Acceptance Criteria
- [ ] Profile screen displays total XP (atomic) and current streak (atomic)
- [ ] At least 5 achievement badges implemented with unlock conditions
- [ ] Achievement cards show: icon, title, and unlock status (locked/unlocked)
- [ ] Locked achievements show progress toward unlock (e.g., "7/30 days")
- [ ]  Unlocked achievements show earned date/timestamp

---

## 🧪 Testing Plan
- Verify total XP displays correctly (matches earned points)
- Complete daily challenge and verify XP updates in profile
- Close and reopen app, verify XP and achievements persist

---

## ⏱️ Timeframe
Estimated completion time: 3 days  

---

## ⚡ Urgency
- [ ] Low  
- [X] Medium  
- [ ] High  

---

## 🎚️ Difficulty
- [ ] Easy  
- [X] Moderate  
- [ ] Hard  

---

## 👨‍💻 Recommended Assigned Developer
Suggested developer: @Brzno 
