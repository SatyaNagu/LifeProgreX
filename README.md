# LifeProgreX

A Flutter app for building habits and tracking personal growth. You log what you do each day (sleep, water, workouts, reading, mood and more), keep streaks going on your habits, set goals, and see how it all adds up over time on an analytics page. An AI coach called MAX, built on Google Gemini, looks at your streaks, habits and goals and gives you suggestions.

Built by **Satya Pranav Nagunoori** ([@SatyaNagu](https://github.com/SatyaNagu)) and **Naga Sai Donthi** ([@DonthiNagaSai](https://github.com/DonthiNagaSai)).

## Features

- Sign up with email (with email verification) or Google, plus password reset
- Onboarding screens for new users
- Habits with streak tracking
- Goals you can create and complete
- Quick logs for 12 areas: sleep, water, workouts, nutrition, mood, meditation, journaling, reading, music, skills, social time and creative work
- Activity timeline of everything you've logged
- Analytics page with charts of your activity and a mood score
- Achievements you earn as you go
- Life Resume: a summary of your progress across every area
- MAX, the AI coach, using Gemini with your stats as context
- Health data from Apple Health / Health Connect (steps, active energy, heart rate, sleep)
- Local reminder notifications
- Profile, appearance, privacy and notification settings

## Tech stack

- Flutter (Dart SDK 3.11+)
- Firebase Authentication (email/password and Google Sign-In)
- Cloud Firestore for user data
- Google Gemini through the `google_generative_ai` package
- `health` package for Apple Health and Health Connect
- `flutter_local_notifications` for reminders

## Running it

1. Install Flutter and check it with `flutter doctor`.
2. Clone the repo and run `flutter pub get`.
3. Create your own Firebase project with Authentication (Email/Password and Google) and Firestore turned on. Then run `flutterfire configure`, or replace `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` with your own files.
4. Get a Gemini API key from Google AI Studio and put it in `_geminiApiKey` in `lib/screens/ai_coach_screen.dart`. Don't commit a real key.
5. Run `flutter run` on an emulator or a device.

## Project structure

```
lib/
  main.dart               app entry point
  auth_service.dart       Firebase and Google sign-in
  screens/                analytics, goals, habits, AI coach, life resume, achievements, timeline
  quicklog_edit/          one screen per quick-log category
  services/               Firestore, analytics, goals, achievements, health data, notifications
  models/                 user, habit, goal, activity, mood and achievement models
```

## Who built what

Satya worked on the database design, habit logging, the Goals section, the Gemini integration and the mood score.

Sai worked on the landing and onboarding screens, sign-up, login, email verification and password reset (including Google Sign-In on iOS), the activity log and all the quick-log screens, the Analytics page, and the Life Resume and AI coach screens.

We worked through pull requests on separate branches and merged into `main`.
