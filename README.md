# Pro-Link: Enterprise Internship & Skill Tracking

A professional Flutter application bridging the gap between **Constantine 2 University - Abdelhamid Mehri** and the corporate world.

---

## 📱 Overview

**Pro-Link** is a mobile-first enterprise internship management platform designed for three distinct actors:

| Role | Description |
|------|-------------|
| 🔑 **Admin** (HR / University Coordinator) | Manage interns, validate registrations, assign mentors |
| 🎓 **Mentor** (Professional Supervisor / Teacher) | Evaluate performance, upload modules, track attendance |
| 🧑‍💼 **Intern** (Student) | View digital ID, schedules, training files, evaluations |

---

## 🎨 Visual Identity

- **Primary Color**: Dark Navy Blue (`#0D1B2A`)
- **Accent**: Gold (`#F4A261`)
- **Typography**: Inter (via Google Fonts)
- **Design**: Responsive corporate UI — works on phone, tablet, and desktop

---

## 🏗️ Architecture

```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── constants/               # AppConstants (routes, keys, API base URL)
│   ├── providers/               # AuthProvider (Provider + ChangeNotifier)
│   ├── routes/                  # AppRouter (go_router with role-based redirect)
│   └── theme/                   # AppTheme (Material 3 dark navy theme)
├── models/
│   ├── user_model.dart          # User (admin / mentor / intern)
│   └── intern_model.dart        # Full intern data model
├── screens/
│   ├── auth/                    # Unified Login Screen
│   ├── admin/                   # Admin Dashboard
│   ├── mentor/                  # Mentor Dashboard
│   └── intern/                  # Intern Dashboard + Digital ID Card
└── widgets/
    └── common/                  # Reusable widgets (StatCard, SectionHeader, etc.)
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) ≥ 3.0.0
- Dart ≥ 3.0.0

### Setup

```bash
# Install dependencies
flutter pub get

# Run on a device or emulator
flutter run

# Run tests
flutter test

# Build release APK
flutter build apk --release
```

### Demo Credentials (Sprint 1)

| Role   | Email                  | Password   |
|--------|------------------------|------------|
| Admin  | admin@prolink.dz       | admin123   |
| Mentor | mentor@prolink.dz      | mentor123  |
| Intern | intern@prolink.dz      | intern123  |

> ⚠️ Remove demo credentials before production deployment.

---

## 🔌 Backend Integration

The app is architected for **REST API** integration with a future backend:

- **Base URL placeholder**: `https://api.pro-link.example.com/v1` (see `AppConstants.apiBaseUrl`)
- **HTTP client**: `dio` + `http` packages configured
- **Firebase**: `firebase_core`, `firebase_auth`, `cloud_firestore` dependencies prepared
- **Auth flow**: Token stored in `SharedPreferences` — replace with JWT validation on login
- **Database**: Firebase / NoSQL / SQL via REST — **SQLite is strictly forbidden**

### Authentication Flow (TODO → production)

```
POST /api/v1/auth/login
Body: { "email": "...", "password": "..." }
Response: { "token": "...", "user": { ... } }
```

---

## 📋 Sprint 1 Screens

- [x] Unified Login Page (responsive — phone + tablet layout)
- [x] Admin Dashboard (stats, quick actions, recent activity)
- [x] Mentor Dashboard (intern overview, evaluations, sessions)
- [x] Intern Dashboard (navigation grid, progress tracker)
- [x] Intern Digital Work ID (flip card with front/back faces)
- [x] Route stubs for all future screens

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x |
| State Management | Provider |
| Navigation | go_router |
| HTTP Client | dio + http |
| Local Storage | shared_preferences |
| Backend (future) | Firebase / REST API SQL |
| UI Font | Google Fonts (Inter) |

---

## 📄 License

Constantine 2 University - Abdelhamid Mehri © 2025
