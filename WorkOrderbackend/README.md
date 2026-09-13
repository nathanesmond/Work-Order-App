# Work Order API (Laravel 12)

REST API behind the Work Order Management System. Handles authentication, role enforcement, the
work order lifecycle and push notification delivery.

See the [root README](../README.md) for the full project overview, setup walkthrough and the
complete endpoint reference.

## Stack

PHP 8.2+ · Laravel 12 · Laravel Sanctum 4 (token auth) · spatie/laravel-permission 6 (roles) ·
kreait/laravel-firebase 7 (FCM) · MySQL

## Quick start

```bash
composer install
cp .env.example .env
php artisan key:generate

mysql -u root -p -e "CREATE DATABASE workorder_app;"
mysql -u root -p workorder_app < database/sql/workorder_app_demo.sql

php artisan serve --host=0.0.0.0 --port=8000
```

Binding to `0.0.0.0` is what lets an Android emulator or a phone on the same network reach the API.

> The migrations in `database/migrations/` cover only users, permissions, tokens and notifications.
> The work order tables themselves live in `database/sql/workorder_app_demo.sql`, so importing that
> dump is required — `migrate` alone will not give you a working database.

## Layout

| Path | Contents |
| --- | --- |
| `routes/api.php` | Every API route, with its role middleware |
| `app/Http/Controllers/Api/` | `AuthController`, `UserController`, `WorkOrderController`, `NotificationController` |
| `app/Models/` | `User`, `WorkOrder`, `Department`, comments, activity and time logs |
| `app/Console/Commands/` | `CheckOverdueWorkOrders` |
| `database/sql/` | Sanitized demo dump (schema + sample data) |

## Roles

`superadmin`, `admin`, `engineer`, `requester` — enforced with `role:` middleware on the routes
rather than in the client, so the API stays authoritative.

## Commands

```bash
php artisan workorders:check-overdue   # flag overdue work orders and notify their owners
```

Schedule it with cron (or Laravel's scheduler) to run on an interval.

## Firebase

Server-side push needs a service account key:

1. Firebase console → *Project settings → Service accounts → Generate new private key*.
2. Save it as `storage/app/firebase-credentials.json`.
3. Confirm `.env` contains `FIREBASE_CREDENTIALS=storage/app/firebase-credentials.json`.

The key is gitignored and must stay that way. Without it everything still runs; only push delivery
is affected.

## Demo accounts

All demo accounts in the dump use the password `password` — see the
[root README](../README.md#3-demo-accounts) for the list.
