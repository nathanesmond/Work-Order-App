# Work Order Management System

A role-based work order (maintenance request) system for a hotel/facility operation, built as an
internship project. A **Laravel 12 REST API** handles authentication, roles and the work order
lifecycle; a **Flutter** mobile client gives each role its own dashboard, with Firebase Cloud
Messaging for push notifications.

> **Monorepo** — [`WorkOrderbackend/`](WorkOrderbackend/) is the API, [`workorderapp/`](workorderapp/) is the mobile app.

---
<img width="1920" height="1080" alt="WorkOrder" src="https://github.com/user-attachments/assets/219066bd-bebb-4bcd-98e4-fb39466b99fc" />

## What it does

A requester reports a problem, an engineer picks it up and works it, an admin oversees the whole
board. Every transition is permission-checked server-side and pushed to the people who care about it.

### Roles

| Role | Can do |
| --- | --- |
| **Requester** | Create work orders, track their own open requests and history, confirm a completed job |
| **Engineer** | Browse available work, self-assign, start / hold / resume / complete, view own assignment history |
| **Admin** | See every work order, cancel, paginated board, calendar + Gantt view, reports, user list |
| **Superadmin** | Everything admin can, plus create / update / delete users |

### Work order lifecycle

```
pending ──assign──> assigned ──start──> in_progress ──complete──> completed ──confirm──> (closed)
                                             │  ▲
                                           hold  resume
                                             ▼  │
                                          on_hold

  any state ──cancel (admin)──> cancelled
```

### Features

- **Token auth** with Laravel Sanctum; the app stores the token in `flutter_secure_storage`.
- **Role & permission enforcement** via `spatie/laravel-permission`, applied as route middleware so
  the API is the source of truth rather than the UI.
- **Push notifications** — the app registers its FCM token with the API, and the backend sends
  notifications through the Firebase Admin SDK (`kreait/laravel-firebase`) on assignment, status
  change and completion. An in-app notification centre tracks read/unread state.
- **Overdue sweep** — `php artisan workorders:check-overdue` flags overdue work orders and notifies
  the relevant users; wire it to cron to run on a schedule.
- **Admin reporting** — charts built with `fl_chart`, plus calendar and Gantt endpoints for
  scheduling visibility.
- **Soft-deleted users**, activity logs and threaded work order comments.

---

## Tech stack

**Backend** — PHP 8.2+ · Laravel 12 · Laravel Sanctum 4 · spatie/laravel-permission 6 ·
kreait/laravel-firebase 7 · MySQL

**Mobile** — Flutter (Dart SDK ^3.8.1) · Provider · go_router · http ·
flutter_secure_storage · firebase_core / firebase_messaging · fl_chart · table_calendar · intl

---

## Repository layout

```
.
├── WorkOrderbackend/              Laravel 12 REST API
│   ├── app/Http/Controllers/Api/  Auth, User, WorkOrder, Notification controllers
│   ├── app/Console/Commands/      workorders:check-overdue
│   ├── app/Models/                User, WorkOrder, Department, comments, logs
│   ├── database/migrations/       users, permissions, tokens, notifications
│   ├── database/sql/              workorder_app_demo.sql  <- import this
│   └── routes/api.php             all API routes
│
└── workorderapp/                  Flutter client
    ├── lib/auth/                  Provider state (auth, work orders, notifications, calendar)
    ├── lib/client/                HTTP layer, one file per API area
    ├── lib/entity/                Models
    ├── lib/screens/               admin/ · engineer/ · requester/ · login
    ├── lib/services/              FCM registration & handling
    └── lib/widgets/               Shared and feature-specific widgets
```

---

## Getting started

### Prerequisites

PHP 8.2+, Composer, MySQL 8, Flutter SDK 3.8+, and an Android emulator or device.

### 1. Backend

```bash
cd WorkOrderbackend

composer install
cp .env.example .env
php artisan key:generate
```

Create the database and import the demo dump — **it carries the full schema plus sample data**, and
several tables (`work_orders`, `departments`, `priorities`, comments, logs) exist only there rather
than as migrations:

```bash
mysql -u root -p -e "CREATE DATABASE workorder_app;"
mysql -u root -p workorder_app < database/sql/workorder_app_demo.sql
```

Point `.env` at it:

```dotenv
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=workorder_app
DB_USERNAME=root
DB_PASSWORD=
```

For push notifications, download a service account key from the Firebase console
(*Project settings -> Service accounts -> Generate new private key*), save it as
`storage/app/firebase-credentials.json`, and make sure `.env` has:

```dotenv
FIREBASE_CREDENTIALS=storage/app/firebase-credentials.json
```

That file is a real credential and is gitignored — it is never committed. The rest of the app runs
fine without it; only push delivery is affected.

Serve the API so an Android emulator can reach it:

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

### 2. Mobile app

```bash
cd workorderapp
flutter pub get
flutter run
```

The API base URL is set in [`lib/client/api_client.dart`](workorderapp/lib/client/api_client.dart)
and the sibling `api_*.dart` files. The default `http://10.0.2.2:8000` is the Android emulator's
alias for your machine's `localhost`. On a physical device, swap in your computer's LAN IP
(e.g. `http://192.168.1.10:8000`) and keep every `api_*.dart` file — including
[`lib/services/fcm_service.dart`](workorderapp/lib/services/fcm_service.dart) — pointing at the
same host.

To use your own Firebase project, re-run `flutterfire configure`; it regenerates
`lib/firebase_options.dart` and `android/app/google-services.json`.

### 3. Demo accounts

Every account in the demo dump uses the password **`password`**.

| Username | Role |
| --- | --- |
| `super_admin` | superadmin |
| `admin` | admin |
| `ce` | admin |
| `engineer1`, `engineer2` | engineer |
| `requester1`, `requester2` | requester |

---

## API reference

All routes are prefixed with `/api`. Everything except `/login` and `/ping` requires a Sanctum
bearer token; the **Role** column is the role middleware enforced on the route.

### Auth & users

| Method | Endpoint | Role |
| --- | --- | --- |
| `POST` | `/login` | public |
| `GET` | `/ping` | public |
| `GET` | `/me` | any |
| `GET` | `/showUser` | any |
| `GET` | `/engineers` | any |
| `GET` | `/users` | admin, superadmin |
| `POST` | `/createUser` | superadmin |
| `PUT` | `/updateUser/{id}` | superadmin |
| `DELETE` | `/deleteUser/{id}` | superadmin |

### Work orders

| Method | Endpoint | Role |
| --- | --- | --- |
| `POST` | `/createWorkOrder` | requester |
| `GET` | `/myWorkOrders` | requester |
| `GET` | `/myWorkOrderHistory` | requester |
| `GET` | `/availableAssignments` | engineer |
| `PUT` | `/WorkOrder/{id}/assign` | engineer |
| `GET` | `/myAssignments` | engineer |
| `GET` | `/myHistory` | engineer |
| `PUT` | `/WorkOrder/{id}/start` | engineer |
| `PUT` | `/WorkOrder/{id}/complete` | engineer |
| `PUT` | `/WorkOrder/{id}/hold` | any |
| `PUT` | `/WorkOrder/{id}/resume` | any |
| `PUT` | `/WorkOrder/{id}/confirm` | requester, admin, superadmin |
| `PUT` | `/WorkOrder/{id}/cancel` | admin, superadmin |
| `GET` | `/viewAllWorkOrders` | admin, requester, superadmin |
| `DELETE` | `/deleteWorkOrder/{id}` | admin, requester, superadmin |
| `GET` | `/paginateWorkOrders` | admin, superadmin |
| `GET` | `/calendar` | admin, superadmin |
| `GET` | `/calendar/gantt` | admin, superadmin |

### Notifications

| Method | Endpoint | Role |
| --- | --- | --- |
| `POST` | `/fcm-token` | any |
| `GET` | `/notifications` | any |
| `GET` | `/notifications/unread-count` | any |
| `PUT` | `/notifications/{id}/read` | any |
| `PUT` | `/notifications/read-all` | any |

---

## Notes on this repository

- **No secrets are committed.** `.env` and the Firebase service account key are gitignored; the
  shipped `database/sql/workorder_app_demo.sql` is a sanitized dump with all API tokens removed, all
  device push tokens nulled, and every password hash replaced with the hash of `password`.
- `android/app/google-services.json` and `lib/firebase_options.dart` *are* committed. These hold
  client-side Firebase configuration, which Google documents as safe to include — access is
  governed by Firebase security rules, not by hiding these values. Point them at your own Firebase
  project with `flutterfire configure`.
- Migrations alone will not produce a working database; import the SQL dump as described above.
