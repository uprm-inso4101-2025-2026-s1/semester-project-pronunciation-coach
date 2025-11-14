---
issue_number: 146
title: "[Lecture Topic Task] Sprint planning on the feedback module for Milestone #2"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/146"
author: "JorgeLuisMaya"
labels: ["documentation","Team 2","Task: lecture-topic","state: concluded"]
created_at: "2025-10-07T03:13:09Z"
updated_at: "2025-10-13T22:03:58Z"
---

# [Lecture Topic Task] Sprint planning on the feedback module for Milestone #2

- **Issue:** [146](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/146)
- **Author:** @JorgeLuisMaya
- **Labels:** ["documentation","Team 2","Task: lecture-topic","state: concluded"]
- **Created:** 2025-10-07T03:13:09Z

## Details
## 🎯 Objective
Plan and organize the upcoming sprint focused on the user feedback module (Team #2).
This sprint will coordinate all steps required for generating pronunciation feedback, from the audio input to the phoneme-level evaluation and final user insights.
It will also outline dependencies with other teams and integrate ideas for Milestone #3, ensuring compatibility and scalability across all components.

---

## 📝 Description
This issue covers the sprint planning for the implementation of the feedback workflow.
The process includes multiple stages that together form the pronunciation analysis pipeline:

1. Speech-to-Text (STT):
Use Flutter dependencies to get the transcript from the user, when no reference text is provided by the user.

2. Phoneme Alignment (MFA):
Use the Montreal Forced Aligner to align the transcript and audio, producing time-aligned phonemes for further analysis.

3. Acoustic Analysis:
Extract acoustic features (e.g., MFCCs, pitch, energy) and compare them against native benchmarks to detect pronunciation deviations.

4. NLP Feedback Model:
Use the results from previous steps to generate human-readable, personalized feedback for the user — highlighting strong phonemes and suggesting improvements.

The sprint will define the division of tasks, integration points, and expected outputs from each step, ensuring all parts communicate effectively for the final feedback feature.

---

## ✅ Acceptance Criteria
- [ ] Sprint planning completed and documented for Team 2.
- [ ] Clear task breakdown per stage (STT, MFA, Acoustic, NLP).
- [ ] Identified dependencies with other teams (data format, API endpoints, etc.).
- [ ] Established evaluation metrics (accuracy, processing time, quality of feedback).
- [ ] Timeline and milestones approved by the team.

---

## 🧪 Testing Plan
- Validate each module independently (unit testing per stage).
- Perform integration testing between stages to ensure smooth data flow.
- Conduct an end-to-end test using a sample audio → ensure feedback is generated correctly.
- Evaluate timing and performance of the pipeline under realistic conditions.
---

## ⏱️ Timeframe
Estimated completion time: _e.g., 3 days / 1 week_  

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
Suggested developer: @JorgeLuisMaya 
