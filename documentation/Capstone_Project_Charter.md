<div align="left">
  <div style="border-left: 4px solid black; padding-left: 15px; margin-bottom: 20px;">
    <h1 style="margin: 0; font-size: 2.5em; font-weight: 800; color: #000;">Capstone Project Charter</h1>
    <p style="margin: 5px 0; font-size: 1.2em; color: #333;">Project Name: LifeProgreX</p>
    <p style="margin: 5px 0; font-size: 1.2em; color: #333;">Capstone Clark University</p>
  </div>
  <hr style="height: 2px; background-color: black; border: none; margin-bottom: 40px;">
</div>

## 1. Project Overview & Objectives
**Project Goal:** To create a unified personal growth ecosystem that leverages AI and health data to drive lasting habit change.

### 1.1 Objectives
- **Objective 1:** Build a high-performance habit-tracking engine.
- **Objective 2:** Integrate real-time health data from Apple Health.
- **Objective 3:** Implement an AI Coach (Max) using Gemini AI.

---

## 2. Deliverables
| Objective | Project Deliverable | Work Products/Description |
| :--- | :--- | :--- |
| Objective 1 | Habit Tracking Engine | CRUD operations for habits, progress logic, streak management. |
| Objective 2 | HealthKit Sync | Integration service, data mapping for steps, sleep, and heart rate. |
| Objective 3 | AI Coach Interface | Generative AI chat interface, personalized prompt system. |

### **Out of Scope**
- Third-party social media sharing (V1).
- Multi-user collaboration or team challenges.

---

## 3. Project Plan
### **Approach and Methodology**
We are using an **Agile (Scrum)** methodology with 2-week sprints.
- **Tools:** Flutter SDK, VS Code, Firebase Console, GitHub for version control.

### **Timeline**
| ID | Task Name | Start | Finish | Duration |
| :--- | :--- | :--- | :--- | :--- |
| 1 | Requirements & Design | Week 1 | Week 3 | 3 Weeks |
| 2 | Backend & Auth | Week 4 | Week 6 | 3 Weeks |
| 3 | Core Feature Dev | Week 7 | Week 11 | 5 Weeks |
| 4 | QA & Beta Testing | Week 12 | Week 13 | 2 Weeks |
| 5 | Deployment & Presentation | Week 14 | Week 15 | 2 Weeks |

---

## 4. Success Criteria
- **User Engagement:** 80% of beta testers log at least 3 habits daily.
- **Accuracy:** 100% data consistency between HealthKit and App Dashboard.
- **AI Utility:** Users rate AI Coach insights at 4/5 or higher.

---

## 5. Risk Management Plan
| Risk Factor | Probability (H-M-L) | Impact (H-M-L) | Risk Management Action |
| :--- | :---: | :---: | :--- |
| API Rate Limits | M | H | Implement caching and optimized polling. |
| Data Privacy | L | H | Encryption at rest and in transit (Firebase Standard). |
| Platform Compatibility | M | M | Use Flutter multi-platform testing suites. |

---

## 6. Technical Features
- **Flutter Framework:** For high-fidelity cross-platform UI.
- **Firebase:** Real-time database and secure authentication.
- **Gemini AI:** Personalized coaching engine.
- **SVG Graphics:** Resolution-independent iconography.

---

## 7. Project Organization and Staffing
| ROLE | NAMES & CONTACT INFORMATION | RESPONSIBILITIES |
| :--- | :--- | :--- |
| **Project Manager** | Satya Pranav Nagunoori | Project coordination, system architecture. |
| **Lead Developer** | Naga Sai Donthi | UI/UX engineering, frontend logic. |
| **QA Engineer** | Bhanu Sai Priya Gomasani | Integration testing, health data validation. |

---

## 8. Project Budget
| Budget Item | Description | Budgeted Cost |
| :--- | :--- | :--- |
| **Development Tools** | IDEs and OS licenses | $0 (Open Source) |
| **Cloud Hosting** | Firebase Spark/Blaze plan | $0 - $50 (Projected) |
| **AI Usage** | Gemini API Tokens | $0 (Trial/Free Tier) |
| **Total** | | **$50 (Max)** |

---

<p align="center">
  <i>Proprietary & Confidential - LifeProgreX Team</i>
</p>
