---
issue_number: 407
title: "[Lecture Topic Task]: Implement "Singleton" Pattern for Auth Music"
state: "open"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/407"
author: "alondra-arce"
labels: [
  "Team 1",
  "Task: lecture-topic",
  "task: development",
  "state: waiting for dev",
  "state: waiting for manager"
]
created_at: "2025-11-24T04:50:04Z"
updated_at: "2025-11-24T04:52:16Z"
---

# [Lecture Topic Task]: Implement "Singleton" Pattern for Auth Music

- **Issue:** [407](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/407)
- **Author:** @alondra-arce
- **Labels:** [
  "Team 1",
  "Task: lecture-topic",
  "task: development",
  "state: waiting for dev",
  "state: waiting for manager"
]
- **Created:** 2025-11-24T04:50:04Z

## Details
## 🎯 Objective

Implement the BackgroundMusicManager using the Singleton Creational Pattern to ensure seamless, uninterrupted audio playback across the Login and Sign-up screens.

---

## 📝 Description

We need to integrate ambient background music during the authentication flow. According to the Software Design lecture on Creational Patterns, a Singleton is the correct architectural choice for this feature.


Why Singleton? The user will frequently switch between the "Login" and "Sign Up" tabs. If we use standard object instantiation, the Audio object would be recreated every time the view changes, causing the music to restart or overlap. A Singleton ensures that only one persistent instance of the audio player exists, allowing the track to loop seamlessly regardless of component unmounting/remounting.

---

## ✅ Acceptance Criteria
-[ ] A BackgroundMusicManager class is created following the Singleton pattern (private constructor, private static instance, public getInstance method).
- [ ] Background music starts automatically when the user lands on the Auth screen.
- [ ] Crucial: The audio track does not restart or glitch when the user clicks between "Login" and "Sign Up" tabs.
- [ ] Music stops or fades out immediately upon successful login or navigation to the Dashboard.
- [ ] Music volume is set to a non-intrusive background level (20-30%).
---

## 🧪 Testing Plan
- Singleton Verification: Add a log in the constructor. Navigate between Login/Signup 5 times. Ensure the log appears only once.
- Seamless Loop: Listen to the track while switching tabs to confirm the audio continuity is unbroken.
- Cleanup: Log in successfully and verify the audio resource is disposed of/stopped.

---

## ⏱️ Timeframe
Estimated completion time: 1 day
---

## ⚡ Urgency
- [ ] Low  
- [ ] Medium  
- [ ] High  

---

## 🎚️ Difficulty
- [ ] Easy  
- [ ] Moderate  
- [ ] Hard  

---

## 👨‍💻 Recommended Assigned Developer
Suggested developer: @alondra-arce 

