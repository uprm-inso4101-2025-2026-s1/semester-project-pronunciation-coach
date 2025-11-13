---
issue_number: 116
title: "[Lecture Topic / Task] Add Phenomena vs. Concepts Classification for Team 2 Documentation"
state: "open"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/116"
author: "jose-valentin"
labels: ["documentation","Team 2","Task: lecture-topic","state: being declined"]
created_at: "2025-09-30T20:26:20Z"
updated_at: "2025-10-01T01:25:27Z"
---

# [Lecture Topic / Task] Add Phenomena vs. Concepts Classification for Team 2 Documentation

- **Issue:** [116](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/116)
- **Author:** @jose-valentin
- **Labels:** ["documentation","Team 2","Task: lecture-topic","state: being declined"]
- **Created:** 2025-09-30T20:26:20Z

## Details
## 🎯 Objective  
Add Section 2.1.8 "Domain Phenomena vs. Concepts Classification" to distinguish between observable instances (phenomena) and abstract categories (concepts) in the pronunciation coaching domain.  

---

## 📝 Description  
Our current domain notes mix instances with types (is "Learner" Ana or the abstract category of all learners?). This section will clarify that:  
- **Phenomena = specific, observable instances** (Ana’s attempt at 3:45 PM, file ana_recording.wav).  
- **Concepts = general types/classes** (PronunciationAttempt, AudioRecording).  

We will also classify entities as **atomic** (phoneme, score) or **composed** (word, feedback, attempt).  

---

## ✅ Acceptance Criteria  
- [ ] Section 2.1.8 created with at least 8 elements classified as phenomenon vs. concept  
- [ ] At least 6 entities labeled as atomic or composed (with components listed)  
- [ ] Examples are clear and drawn from pronunciation coaching domain  

---

## 📚 Examples  
- **Learner** → Ana (phenomenon), Learner (concept)  
- **PronunciationAttempt** → Ana’s “hello world” attempt (phenomenon), PronunciationAttempt (concept)  
- **Phoneme** → /θ/ in “think” (phenomenon), Phoneme (concept)  
- **Feedback** → “Your th sound needs work” (phenomenon), PronunciationFeedback (concept)  
- **ProgressRecord** → Ana’s 78% score on Jan 15 (phenomenon), ProgressRecord (concept)  
- **AudioRecording** → ana_recording.wav (phenomenon), AudioRecording (concept)  

Atomic: Phoneme, Score  
Composed: Word, PronunciationAttempt, ProgressRecord, Feedback  

---

## ⏱️ Timeframe  
1–2 days  

---

## ⚡ Urgency  
- [x] Low  
- [ ] Medium  
- [ ] High  

---

## 🎚️ Difficulty  
- [ ] Easy  
- [x] Moderate  
- [ ] Hard  

---

## 👨‍💻 Recommended Assigned Developer  
@jose-valentin
