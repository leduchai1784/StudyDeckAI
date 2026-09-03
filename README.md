# StudyDeckAI

Nền tảng học tập thông minh tích hợp AI - 3 Target dùng chung 1 codebase Flutter:
1. **Mobile App (Android/iOS)**: `lib/main_mobile.dart`
2. **Web App Người Dùng (PWA)**: `lib/main_web.dart`
3. **Web Admin Quản Trị**: `lib/main_admin.dart`

---

## Hướng Dẫn Build các Target

### 1. Build Mobile (Android/iOS)
```bash
flutter run -t lib/main_mobile.dart
flutter build apk -t lib/main_mobile.dart
flutter build ios -t lib/main_mobile.dart
```

### 2. Build Web Người Dùng (User PWA)
```bash
flutter run -t lib/main_web.dart -d chrome
flutter build web -t lib/main_web.dart --output=build/web-user
```

### 3. Build Web Admin (Quản Trị)
```bash
flutter run -t lib/main_admin.dart -d chrome
flutter build web -t lib/main_admin.dart --output=build/web-admin
```

---

## Cấu Trúc Thư Mục

```
lib/
├── main_mobile.dart         # Entry point: User Mobile
├── main_web.dart            # Entry point: User Web
├── main_admin.dart          # Entry point: Web Admin
├── app/                     # App configuration, router, theme
├── core/                    # Constants, network, storage, utils, platform helpers
├── models/                  # 20 Data Models (User, Deck, Flashcard, Quiz...)
├── services/                # API Services (Auth, Learning, Flashcard, RAG, Admin...)
├── features/                # UI Modules dùng chung Mobile + Web
├── admin/                   # UI Modules dành riêng cho Web Admin
└── shared/                  # Widgets, Responsive breakpoints & Layout scaffolds
```
