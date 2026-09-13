# Work Order App (Flutter)

Mobile client for the Work Order Management System. Each role gets its own dashboard, backed by the
Laravel API in [`../WorkOrderbackend/`](../WorkOrderbackend/).

See the [root README](../README.md) for the full project overview and setup walkthrough.

## Stack

Flutter (Dart SDK ^3.8.1) · Provider (state) · go_router (navigation) · http ·
flutter_secure_storage (token storage) · firebase_core / firebase_messaging (push) ·
fl_chart (reports) · table_calendar · intl

## Quick start

Start the backend first, then:

```bash
flutter pub get
flutter run
```

Log in with any demo account — they all use the password `password`.

## Pointing at your API

The base URL is defined in each file under `lib/client/`, plus `lib/services/fcm_service.dart`:

| Target | Base URL |
| --- | --- |
| Android emulator | `http://10.0.2.2:8000` (the emulator's alias for your machine) |
| Physical device | `http://<your-LAN-IP>:8000` |

All of these files must point at the same host, `lib/services/fcm_service.dart` included.

## Layout

| Path | Contents |
| --- | --- |
| `lib/auth/` | Provider state: auth, work orders, notifications, calendar, user |
| `lib/client/` | HTTP layer — one file per API area |
| `lib/entity/` | Model classes |
| `lib/screens/admin/` | Home, users, reports, calendar |
| `lib/screens/engineer/` | Home, tasks, profile |
| `lib/screens/requester/` | Home, requests, profile |
| `lib/services/` | FCM registration and message handling |
| `lib/widgets/` | Shared and feature-specific widgets |

## Firebase

`lib/firebase_options.dart` and `android/app/google-services.json` are committed — they hold
client-side Firebase configuration, which is safe to publish (access is governed by Firebase
security rules). To point the app at your own Firebase project:

```bash
flutterfire configure
```

That regenerates both files.
