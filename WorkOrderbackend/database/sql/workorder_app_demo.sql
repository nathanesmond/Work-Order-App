-- ---------------------------------------------------------------------------
-- workorder_app -- demo database dump (schema + sample data)
--
-- SANITIZED FOR PUBLIC RELEASE:
--   * All personal access (Sanctum) API tokens removed.
--   * All FCM device push tokens set to NULL.
--   * All password hashes replaced with the hash of "password".
--
-- Every seeded account in this dump therefore logs in with the password:
--   password
--
-- Import:  mysql -u root -p workorder_app < workorder_app_demo.sql
-- ---------------------------------------------------------------------------

-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Mar 27, 2026 at 02:55 AM
-- Server version: 12.1.2-MariaDB-log
-- PHP Version: 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `workorder_app`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `work_order_id` bigint(20) UNSIGNED NOT NULL,
  `action` varchar(100) DEFAULT NULL,
  `old_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attachments`
--

CREATE TABLE `attachments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `work_order_id` bigint(20) UNSIGNED NOT NULL,
  `uploaded_by` bigint(20) UNSIGNED NOT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `file_type` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'IT', '2026-02-03 05:56:35', '2026-02-03 05:56:35'),
(2, 'FO', '2026-02-03 05:56:35', '2026-02-03 05:56:35'),
(3, 'F&B', '2026-02-03 05:56:35', '2026-02-03 05:56:35'),
(4, 'Engineering', '2026-02-03 05:56:35', '2026-02-03 05:56:35'),
(5, 'Housekeeping', '2026-02-03 05:56:35', '2026-02-03 05:56:35'),
(6, 'Sales & Marketing', '2026-02-03 05:56:35', '2026-02-03 05:56:35'),
(7, 'Kitchen', NULL, NULL),
(8, 'HR', NULL, NULL),
(9, 'A&G', NULL, NULL),
(10, 'Chief Engineer', NULL, NULL),
(11, 'GM', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_01_28_080226_create_permission_tables', 1),
(5, '2026_01_28_083240_create_personal_access_tokens_table', 1),
(6, '2026_02_09_084044_add_cancel_info_to_work_orders', 2),
(7, '2026_03_12_081234_add_fcm_token_to_users_table', 3),
(8, '2026_03_18_070921_add_username_to_users_table', 4),
(9, '2026_03_24_023218_create_notifications_table', 5);

-- --------------------------------------------------------

--
-- Table structure for table `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\Models\\User', 2),
(2, 'App\\Models\\User', 3),
(3, 'App\\Models\\User', 4),
(3, 'App\\Models\\User', 5),
(3, 'App\\Models\\User', 6),
(2, 'App\\Models\\User', 7),
(1, 'App\\Models\\User', 9),
(3, 'App\\Models\\User', 15),
(5, 'App\\Models\\User', 16),
(1, 'App\\Models\\User', 19);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `work_order_id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'overdue',
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `work_order_id`, `type`, `title`, `message`, `is_read`, `created_at`, `updated_at`) VALUES
(1, 2, 23, 'overdue', 'Work Order Overdue', 'WO #23 \"PC rusak\" from FO is overdue.', 0, '2026-03-23 20:11:28', '2026-03-23 20:11:28'),
(2, 15, 23, 'overdue', 'Work Order Overdue', 'WO #23 \"PC rusak\" from FO is overdue.', 0, '2026-03-23 20:11:28', '2026-03-23 20:11:28'),
(3, 16, 23, 'overdue', 'Work Order Overdue', 'WO #23 \"PC rusak\" from FO is overdue.', 1, '2026-03-23 20:11:28', '2026-03-23 20:15:45'),
(5, 19, 23, 'overdue', 'Work Order Overdue', 'WO #23 \"PC rusak\" from FO is overdue.', 0, '2026-03-23 20:11:28', '2026-03-23 20:11:28'),
(6, 5, 23, 'overdue', 'Work Order Overdue', 'WO #23 \"PC rusak\" from FO is overdue.', 1, '2026-03-23 20:11:28', '2026-03-24 00:11:42'),
(7, 7, 23, 'overdue', 'Work Order Overdue', 'WO #23 \"PC rusak\" from FO is overdue.', 0, '2026-03-23 20:11:28', '2026-03-23 20:11:28'),
(8, 2, 58, 'overdue', 'Work Order Overdue', 'WO #58 \"tes\" from FO is overdue.', 0, '2026-03-23 20:11:29', '2026-03-23 20:11:29'),
(9, 15, 58, 'overdue', 'Work Order Overdue', 'WO #58 \"tes\" from FO is overdue.', 0, '2026-03-23 20:11:29', '2026-03-23 20:11:29'),
(10, 16, 58, 'overdue', 'Work Order Overdue', 'WO #58 \"tes\" from FO is overdue.', 1, '2026-03-23 20:11:29', '2026-03-23 20:15:40'),
(12, 19, 58, 'overdue', 'Work Order Overdue', 'WO #58 \"tes\" from FO is overdue.', 0, '2026-03-23 20:11:29', '2026-03-23 20:11:29'),
(13, 5, 58, 'overdue', 'Work Order Overdue', 'WO #58 \"tes\" from FO is overdue.', 1, '2026-03-23 20:11:29', '2026-03-24 00:11:42'),
(14, 3, 58, 'overdue', 'Work Order Overdue', 'WO #58 \"tes\" from FO is overdue.', 1, '2026-03-23 20:11:29', '2026-03-23 20:20:38'),
(15, 2, 59, 'overdue', 'Work Order Overdue', 'WO #59 \"tes engineering\" from FO is overdue.', 0, '2026-03-23 20:11:29', '2026-03-23 20:11:29'),
(16, 15, 59, 'overdue', 'Work Order Overdue', 'WO #59 \"tes engineering\" from FO is overdue.', 0, '2026-03-23 20:11:29', '2026-03-23 20:11:29'),
(17, 16, 59, 'overdue', 'Work Order Overdue', 'WO #59 \"tes engineering\" from FO is overdue.', 1, '2026-03-23 20:11:29', '2026-03-23 20:15:45'),
(19, 19, 59, 'overdue', 'Work Order Overdue', 'WO #59 \"tes engineering\" from FO is overdue.', 0, '2026-03-23 20:11:29', '2026-03-23 20:11:29'),
(20, 5, 59, 'overdue', 'Work Order Overdue', 'WO #59 \"tes engineering\" from FO is overdue.', 1, '2026-03-23 20:11:29', '2026-03-24 00:11:42'),
(21, 3, 59, 'overdue', 'Work Order Overdue', 'WO #59 \"tes engineering\" from FO is overdue.', 1, '2026-03-23 20:11:29', '2026-03-23 20:20:38'),
(22, 2, 60, 'overdue', 'Work Order Overdue', 'WO #60 \"enginerrerd\" from FO is overdue.', 0, '2026-03-23 20:11:30', '2026-03-23 20:11:30'),
(23, 15, 60, 'overdue', 'Work Order Overdue', 'WO #60 \"enginerrerd\" from FO is overdue.', 0, '2026-03-23 20:11:30', '2026-03-23 20:11:30'),
(24, 16, 60, 'overdue', 'Work Order Overdue', 'WO #60 \"enginerrerd\" from FO is overdue.', 1, '2026-03-23 20:11:30', '2026-03-23 20:15:44'),
(26, 19, 60, 'overdue', 'Work Order Overdue', 'WO #60 \"enginerrerd\" from FO is overdue.', 0, '2026-03-23 20:11:30', '2026-03-23 20:11:30'),
(27, 5, 60, 'overdue', 'Work Order Overdue', 'WO #60 \"enginerrerd\" from FO is overdue.', 1, '2026-03-23 20:11:30', '2026-03-24 00:11:42'),
(28, 2, 71, 'overdue', 'Work Order Overdue', 'WO #71 \"tes wow\" from FO is overdue.', 0, '2026-03-23 20:11:30', '2026-03-23 20:11:30'),
(29, 15, 71, 'overdue', 'Work Order Overdue', 'WO #71 \"tes wow\" from FO is overdue.', 0, '2026-03-23 20:11:30', '2026-03-23 20:11:30'),
(30, 16, 71, 'overdue', 'Work Order Overdue', 'WO #71 \"tes wow\" from FO is overdue.', 1, '2026-03-23 20:11:30', '2026-03-23 20:15:42'),
(32, 19, 71, 'overdue', 'Work Order Overdue', 'WO #71 \"tes wow\" from FO is overdue.', 0, '2026-03-23 20:11:30', '2026-03-23 20:11:30'),
(33, 5, 71, 'overdue', 'Work Order Overdue', 'WO #71 \"tes wow\" from FO is overdue.', 1, '2026-03-23 20:11:30', '2026-03-24 00:11:42'),
(34, 2, 73, 'overdue', 'Work Order Overdue', 'WO #73 \"aadw\" from FO is overdue.', 0, '2026-03-23 20:11:30', '2026-03-23 20:11:30'),
(35, 15, 73, 'overdue', 'Work Order Overdue', 'WO #73 \"aadw\" from FO is overdue.', 0, '2026-03-23 20:11:30', '2026-03-23 20:11:30'),
(36, 16, 73, 'overdue', 'Work Order Overdue', 'WO #73 \"aadw\" from FO is overdue.', 1, '2026-03-23 20:11:30', '2026-03-23 20:15:42'),
(38, 19, 73, 'overdue', 'Work Order Overdue', 'WO #73 \"aadw\" from FO is overdue.', 0, '2026-03-23 20:11:30', '2026-03-23 20:11:30'),
(39, 5, 73, 'overdue', 'Work Order Overdue', 'WO #73 \"aadw\" from FO is overdue.', 1, '2026-03-23 20:11:30', '2026-03-24 00:11:42'),
(40, 2, 68, 'overdue', 'Work Order Overdue', 'WO #68 \"zvzv\" from FO is overdue.', 0, '2026-03-25 00:24:55', '2026-03-25 00:24:55'),
(41, 15, 68, 'overdue', 'Work Order Overdue', 'WO #68 \"zvzv\" from FO is overdue.', 0, '2026-03-25 00:24:55', '2026-03-25 00:24:55'),
(42, 16, 68, 'overdue', 'Work Order Overdue', 'WO #68 \"zvzv\" from FO is overdue.', 1, '2026-03-25 00:24:56', '2026-03-25 23:07:39'),
(44, 19, 68, 'overdue', 'Work Order Overdue', 'WO #68 \"zvzv\" from FO is overdue.', 0, '2026-03-25 00:24:56', '2026-03-25 00:24:56'),
(45, 5, 68, 'overdue', 'Work Order Overdue', 'WO #68 \"zvzv\" from FO is overdue.', 1, '2026-03-25 00:24:56', '2026-03-25 00:36:50'),
(46, 3, 68, 'overdue', 'Work Order Overdue', 'WO #68 \"zvzv\" from FO is overdue.', 0, '2026-03-25 00:24:56', '2026-03-25 00:24:56');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

-- [sanitized] INSERT INTO `personal_access_tokens` removed: live API tokens are not published.

-- [sanitized] INSERT INTO `personal_access_tokens` removed: live API tokens are not published.

-- --------------------------------------------------------

--
-- Table structure for table `priorities`
--

CREATE TABLE `priorities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `sla_hours` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'web', '2026-02-02 22:58:08', '2026-02-02 22:58:08'),
(2, 'engineer', 'web', '2026-02-02 22:58:08', '2026-02-02 22:58:08'),
(3, 'requester', 'web', '2026-02-02 22:58:08', '2026-02-02 22:58:08'),
(5, 'superadmin', 'web', '2026-03-05 20:03:11', '2026-03-05 20:03:11');

-- --------------------------------------------------------

--
-- Table structure for table `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `time_logs`
--

CREATE TABLE `time_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `work_order_id` bigint(20) UNSIGNED NOT NULL,
  `engineer_id` bigint(20) UNSIGNED NOT NULL,
  `started_at` datetime NOT NULL,
  `stopped_at` datetime DEFAULT NULL,
  `minutes_worked` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `fcm_token` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `department_id`, `name`, `username`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `fcm_token`) VALUES
(2, 1, 'Admin1', 'admin', NULL, '$2y$12$OdDjOvl5vzeBUArk69UaD.xMMIiafEj7wEe388G9Tmop3nCm75BlO', NULL, '2026-02-02 22:58:21', '2026-03-25 01:09:57', NULL),
(3, 4, 'engineer1', 'engineer1', NULL, '$2y$12$OdDjOvl5vzeBUArk69UaD.xMMIiafEj7wEe388G9Tmop3nCm75BlO', NULL, '2026-02-02 23:01:31', '2026-03-18 00:16:30', NULL),
(4, 9, 'admin2777', 'admin2777', NULL, '$2y$12$OdDjOvl5vzeBUArk69UaD.xMMIiafEj7wEe388G9Tmop3nCm75BlO', NULL, '2026-02-02 23:02:10', '2026-03-18 00:16:30', NULL),
(5, 2, 'requester1', 'requester1', NULL, '$2y$12$OdDjOvl5vzeBUArk69UaD.xMMIiafEj7wEe388G9Tmop3nCm75BlO', NULL, '2026-02-02 23:02:46', '2026-03-18 00:16:30', NULL),
(6, 3, 'requester2', 'requester2', NULL, '$2y$12$OdDjOvl5vzeBUArk69UaD.xMMIiafEj7wEe388G9Tmop3nCm75BlO', NULL, '2026-02-02 23:04:04', '2026-03-18 00:16:30', NULL),
(7, 4, 'engineer2', 'engineer2', NULL, '$2y$12$OdDjOvl5vzeBUArk69UaD.xMMIiafEj7wEe388G9Tmop3nCm75BlO', NULL, '2026-02-06 00:59:20', '2026-03-18 00:16:30', NULL),
(15, 1, 'tes bikin and 2', 'tes_bikin_and_2', NULL, '$2y$12$OdDjOvl5vzeBUArk69UaD.xMMIiafEj7wEe388G9Tmop3nCm75BlO', NULL, '2026-03-05 02:14:55', '2026-03-18 00:16:30', NULL),
(16, 1, 'Super Admin', 'super_admin', NULL, '$2y$12$OdDjOvl5vzeBUArk69UaD.xMMIiafEj7wEe388G9Tmop3nCm75BlO', NULL, '2026-03-05 20:08:13', '2026-03-18 00:16:30', NULL),
(19, 10, 'Chief Engineer', 'ce', NULL, '$2y$12$OdDjOvl5vzeBUArk69UaD.xMMIiafEj7wEe388G9Tmop3nCm75BlO', NULL, '2026-03-12 01:29:30', '2026-03-25 01:39:53', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `work_orders`
--

CREATE TABLE `work_orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `requester_id` bigint(20) UNSIGNED NOT NULL,
  `assigned_engineer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `priority_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('on_request','approved','assigned','in_progress','on_hold','completed','cancelled','overdue') DEFAULT 'on_request',
  `due_at` datetime DEFAULT NULL,
  `assigned_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `overdue_at` datetime DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `cancelled_by` bigint(20) UNSIGNED DEFAULT NULL,
  `cancelled_role` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `work_orders`
--

INSERT INTO `work_orders` (`id`, `title`, `description`, `requester_id`, `assigned_engineer_id`, `department_id`, `priority_id`, `status`, `due_at`, `assigned_at`, `started_at`, `completed_at`, `overdue_at`, `cancelled_at`, `created_at`, `updated_at`, `cancelled_by`, `cancelled_role`) VALUES
(23, 'PC rusak', 'mau meledak', 5, 7, 2, NULL, 'overdue', '2026-02-09 11:18:58', NULL, '2026-02-09 08:19:15', NULL, '2026-03-09 05:39:35', NULL, '2026-02-09 01:18:58', '2026-03-08 22:39:35', NULL, NULL),
(28, 'sfsf', '32234', 5, NULL, 2, NULL, 'cancelled', '2026-02-09 10:04:27', NULL, NULL, NULL, NULL, '2026-02-09 09:04:30', '2026-02-09 02:04:27', '2026-02-09 02:04:30', 5, NULL),
(29, '3', 's', 5, NULL, 2, NULL, 'cancelled', '2026-02-09 10:09:31', NULL, NULL, NULL, NULL, '2026-02-09 09:09:37', '2026-02-09 02:09:31', '2026-02-09 02:09:37', 5, NULL),
(30, 'wewe', 'wadad', 5, NULL, 2, NULL, 'cancelled', '2026-02-09 10:11:30', NULL, NULL, NULL, NULL, '2026-02-09 09:11:43', '2026-02-09 02:11:30', '2026-02-09 02:11:43', 2, NULL),
(32, 'dd', 'dd', 6, NULL, 3, NULL, 'cancelled', '2026-02-09 11:26:32', NULL, NULL, NULL, NULL, '2026-02-09 09:26:39', '2026-02-09 02:26:32', '2026-02-09 02:26:39', 6, NULL),
(34, 'Tes History', 'history tes', 5, 7, 2, NULL, 'completed', '2026-02-10 03:10:47', NULL, '2026-02-10 02:11:05', '2026-02-10 02:11:22', NULL, NULL, '2026-02-09 19:10:47', '2026-02-09 19:11:22', NULL, NULL),
(36, 'Laptop rusak', 'testetstest', 5, 3, 2, NULL, 'completed', '2026-03-06 07:59:58', NULL, '2026-03-03 08:01:30', '2026-03-03 08:01:37', NULL, NULL, '2026-03-03 00:59:58', '2026-03-03 01:01:37', NULL, NULL),
(56, 'tes', 'tes', 5, NULL, 2, NULL, 'cancelled', '2026-03-09 03:06:32', NULL, NULL, NULL, NULL, '2026-03-11 02:47:14', '2026-03-09 19:06:32', '2026-03-10 19:47:14', 16, NULL),
(58, 'tes', 'tes dulu', 5, 3, 2, NULL, 'overdue', '2026-03-11 06:41:59', NULL, '2026-03-11 03:43:03', NULL, '2026-03-12 08:34:29', NULL, '2026-03-10 20:41:59', '2026-03-12 01:34:29', NULL, NULL),
(59, 'tes engineering', 'ehe', 5, 3, 2, NULL, 'overdue', '2026-03-11 06:55:59', NULL, '2026-03-11 06:06:07', NULL, '2026-03-16 07:31:24', NULL, '2026-03-10 22:55:59', '2026-03-16 00:31:24', NULL, NULL),
(60, 'enginerrerd', 'awdwa', 5, NULL, 2, NULL, 'overdue', '2026-03-11 06:56:16', NULL, NULL, NULL, '2026-03-12 08:36:29', NULL, '2026-03-10 22:56:16', '2026-03-12 01:36:29', NULL, NULL),
(68, 'zvzv', '3r', 5, 3, 2, NULL, 'overdue', '2026-03-19 14:05:43', NULL, '2026-03-16 07:27:35', NULL, '2026-03-25 07:24:48', NULL, '2026-03-11 02:05:43', '2026-03-25 00:24:48', NULL, NULL),
(70, 'tes wow', 'jwjwji', 5, 3, 2, NULL, 'completed', '2026-03-12 14:26:26', NULL, '2026-03-12 09:27:01', '2026-03-12 09:27:07', NULL, NULL, '2026-03-12 02:26:26', '2026-03-12 02:27:07', NULL, NULL),
(71, 'tes wow', 'jwjwji', 5, NULL, 2, NULL, 'overdue', '2026-03-12 14:26:26', NULL, NULL, NULL, '2026-03-16 07:31:37', NULL, '2026-03-12 02:26:26', '2026-03-16 00:31:37', NULL, NULL),
(72, 'jnn', 'nbn', 5, NULL, 2, NULL, 'cancelled', '2026-03-16 12:53:06', NULL, NULL, NULL, NULL, '2026-03-18 08:39:40', '2026-03-16 00:53:06', '2026-03-18 01:39:40', 16, NULL),
(73, 'aadw', 'adwad', 5, NULL, 2, NULL, 'overdue', '2026-03-24 02:40:42', NULL, NULL, NULL, '2026-03-24 02:41:25', NULL, '2026-03-23 19:38:42', '2026-03-23 19:41:25', NULL, NULL),
(74, 'tes calendar', 'awikwokkk', 5, 3, 2, NULL, 'on_hold', '2026-04-07 16:12:11', NULL, '2026-03-25 07:37:35', NULL, NULL, NULL, '2026-03-24 00:12:11', '2026-03-25 01:44:31', NULL, NULL),
(75, 'tes warna', '1', 5, 3, 2, NULL, 'in_progress', '2026-03-26 09:03:09', NULL, '2026-03-26 06:03:58', NULL, NULL, NULL, '2026-03-25 23:03:09', '2026-03-25 23:03:58', NULL, NULL),
(76, 'tes warna lagi', '2', 5, 3, 2, NULL, 'in_progress', '2026-03-26 10:03:22', NULL, '2026-03-26 06:04:00', NULL, NULL, NULL, '2026-03-25 23:03:22', '2026-03-25 23:04:00', NULL, NULL),
(77, 'tes warna lagj lagi', '3', 5, NULL, 2, NULL, 'on_request', '2026-03-26 12:03:35', NULL, NULL, NULL, NULL, NULL, '2026-03-25 23:03:35', '2026-03-25 23:03:35', NULL, NULL),
(78, 'a', 'a', 5, NULL, 2, NULL, 'on_request', '2026-03-27 16:13:11', NULL, NULL, NULL, NULL, NULL, '2026-03-26 19:13:11', '2026-03-26 19:13:11', NULL, NULL),
(79, 'a', 'a', 5, NULL, 2, NULL, 'on_request', '2026-03-27 04:15:34', NULL, NULL, NULL, NULL, NULL, '2026-03-26 19:15:34', '2026-03-26 19:15:34', NULL, NULL),
(80, 'bb', 'b', 5, NULL, 2, NULL, 'on_request', '2026-03-27 04:18:43', NULL, NULL, NULL, NULL, NULL, '2026-03-26 19:18:43', '2026-03-26 19:18:43', NULL, NULL),
(81, 'c', 'c', 5, NULL, 2, NULL, 'on_request', '2026-03-27 04:19:59', NULL, NULL, NULL, NULL, NULL, '2026-03-26 19:19:59', '2026-03-26 19:19:59', NULL, NULL),
(82, 'dd', 'd', 5, NULL, 2, NULL, 'on_request', '2026-03-27 05:23:16', NULL, NULL, NULL, NULL, NULL, '2026-03-26 19:23:16', '2026-03-26 19:23:16', NULL, NULL),
(83, 'f', 'f', 5, NULL, 2, NULL, 'on_request', '2026-03-27 03:24:29', NULL, NULL, NULL, NULL, NULL, '2026-03-26 19:24:29', '2026-03-26 19:24:29', NULL, NULL),
(84, 'j', 'j', 5, NULL, 2, NULL, 'on_request', '2026-03-27 10:39:39', NULL, NULL, NULL, NULL, NULL, '2026-03-27 02:39:39', '2026-03-27 02:39:39', NULL, NULL),
(85, 'm', 'mn', 5, NULL, 2, NULL, 'on_request', '2026-03-27 09:41:08', NULL, NULL, NULL, NULL, NULL, '2026-03-27 02:41:08', '2026-03-27 02:41:08', NULL, NULL),
(86, 'z', 'z', 5, NULL, 2, NULL, 'on_request', '2026-03-27 09:41:54', NULL, NULL, NULL, NULL, NULL, '2026-03-27 02:41:54', '2026-03-27 02:41:54', NULL, NULL),
(87, 'h', 'h', 5, NULL, 2, NULL, 'on_request', '2026-03-27 10:42:44', NULL, NULL, NULL, NULL, NULL, '2026-03-27 02:42:44', '2026-03-27 02:42:44', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `work_order_comments`
--

CREATE TABLE `work_order_comments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `work_order_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `work_order_comments`
--

INSERT INTO `work_order_comments` (`id`, `work_order_id`, `user_id`, `comment`, `created_at`) VALUES
(1, 68, 3, 'makan', '2026-03-18 01:35:32'),
(2, 68, 3, 'susah', '2026-03-18 01:37:18'),
(3, 72, 16, 'wldaljdnjalw', '2026-03-18 01:39:40'),
(4, 74, 3, 'susah', '2026-03-25 00:40:08'),
(5, 74, 3, 'susah banget', '2026-03-25 00:40:15'),
(6, 74, 3, 'gabisa ini', '2026-03-25 00:40:20'),
(7, 74, 3, 'gg', '2026-03-25 01:44:31');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_log_user` (`user_id`),
  ADD KEY `fk_log_wo` (`work_order_id`);

--
-- Indexes for table `attachments`
--
ALTER TABLE `attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_attach_wo` (`work_order_id`),
  ADD KEY `fk_attach_user` (`uploaded_by`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_user_id_foreign` (`user_id`),
  ADD KEY `notifications_work_order_id_foreign` (`work_order_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `priorities`
--
ALTER TABLE `priorities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `time_logs`
--
ALTER TABLE `time_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_time_wo` (`work_order_id`),
  ADD KEY `fk_time_user` (`engineer_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD KEY `fk_users_departments` (`department_id`);

--
-- Indexes for table `work_orders`
--
ALTER TABLE `work_orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_wo_requester` (`requester_id`),
  ADD KEY `fk_wo_engineer` (`assigned_engineer_id`),
  ADD KEY `fk_wo_department` (`department_id`),
  ADD KEY `fk_wo_priority` (`priority_id`);

--
-- Indexes for table `work_order_comments`
--
ALTER TABLE `work_order_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_comment_wo` (`work_order_id`),
  ADD KEY `fk_comment_user` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `attachments`
--
ALTER TABLE `attachments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=337;

--
-- AUTO_INCREMENT for table `priorities`
--
ALTER TABLE `priorities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `time_logs`
--
ALTER TABLE `time_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `work_orders`
--
ALTER TABLE `work_orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `work_order_comments`
--
ALTER TABLE `work_order_comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `fk_log_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_log_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attachments`
--
ALTER TABLE `attachments`
  ADD CONSTRAINT `fk_attach_user` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_attach_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_work_order_id_foreign` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `time_logs`
--
ALTER TABLE `time_logs`
  ADD CONSTRAINT `fk_time_user` FOREIGN KEY (`engineer_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_time_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_departments` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `work_orders`
--
ALTER TABLE `work_orders`
  ADD CONSTRAINT `fk_wo_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  ADD CONSTRAINT `fk_wo_engineer` FOREIGN KEY (`assigned_engineer_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_wo_priority` FOREIGN KEY (`priority_id`) REFERENCES `priorities` (`id`),
  ADD CONSTRAINT `fk_wo_requester` FOREIGN KEY (`requester_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `work_order_comments`
--
ALTER TABLE `work_order_comments`
  ADD CONSTRAINT `fk_comment_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_comment_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
