# Nexus AI Backend - Database Table Design Specifications

**Document Version:** 1.0.0  
**Author:** Principal Database Architect & Senior Backend Engineer  
**Last Updated:** July 25, 2026  

---

## Table of Contents
1. [Document Purpose](#1-document-purpose)
2. [Document Scope](#2-document-scope)
3. [Domain Table Specifications Overview](#3-domain-table-specifications-overview)
4. [Auth Domain Tables](#4-auth-domain-tables)
   - [4.1 `auth_users`](#41-auth_users)
   - [4.2 `auth_refresh_tokens`](#42-auth_refresh_tokens)
   - [4.3 `auth_sessions`](#43-auth_sessions)
5. [Profile Domain Tables](#5-profile-domain-tables)
   - [5.1 `user_profiles`](#51-user_profiles)
   - [5.2 `user_education`](#52-user_education)
   - [5.3 `user_skills`](#53-user_skills)
   - [5.4 `career_goals`](#54-career_goals)
   - [5.5 `user_preferences`](#55-user_preferences)
6. [Planner Domain Tables](#6-planner-domain-tables)
   - [6.1 `planner_tasks`](#61-planner_tasks)
   - [6.2 `planner_categories`](#62-planner_categories)
   - [6.3 `planner_reminders`](#63-planner_reminders)
   - [6.4 `planner_study_schedules`](#64-planner_study_schedules)
7. [Finance Domain Tables](#7-finance-domain-tables)
   - [7.1 `finance_budgets`](#71-finance_budgets)
   - [7.2 `finance_expenses`](#72-finance_expenses)
   - [7.3 `finance_categories`](#73-finance_categories)
   - [7.4 `finance_monthly_summaries`](#74-finance_monthly_summaries)
   - [7.5 `finance_saving_goals`](#75-finance_saving_goals)
8. [AI Domain Tables](#8-ai-domain-tables)
   - [8.1 `ai_conversations`](#81-ai_conversations)
   - [8.2 `ai_messages`](#82-ai_messages)
   - [8.3 `ai_recommendations`](#83-ai_recommendations)
   - [8.4 `ai_decision_history`](#84-ai_decision_history)
9. [Notifications, Uploads & Payments Tables](#9-notifications-uploads--payments-tables)
   - [9.1 `notifications`](#91-notifications)
   - [9.2 `notification_preferences`](#92-notification_preferences)
   - [9.3 `uploaded_files`](#93-uploaded_files)
   - [9.4 `payments`](#94-payments)
   - [9.5 `subscriptions`](#95-subscriptions)
10. [Analytics & Future Expansion Tables](#10-analytics--future-expansion-tables)
    - [10.1 `productivity_metrics`](#101-productivity_metrics)
    - [10.2 `financial_metrics`](#102-financial_metrics)
    - [10.3 `teams`](#103-teams)
    - [10.4 `organisations`](#104-organisations)
    - [10.5 `activity_timeline`](#105-activity_timeline)
11. [Architectural Rationale & Trade-Off Analysis](#11-architectural-rationale--trade-off-analysis)
12. [Enterprise Best Practices](#12-enterprise-best-practices)
13. [Future Considerations](#13-future-considerations)
14. [Cross References](#14-cross-references)

---

## 1. Document Purpose

This document provides complete table design specifications for all 28 conceptual relational entities comprising the Nexus AI database. It details table purpose, module ownership, initial vs 3-year row growth estimates, required indexes, audit columns, soft-delete policies, business constraints, and future expansion fields without writing SQL or entity code.

---

## 2. Document Scope

This specification applies to all database tables across the 10 core modules and future expansion components.

---

## 3. Domain Table Specifications Overview

All tables follow lower-case `snake_case` naming conventions, feature a UUID v4 primary key (`id`), and implement standard audit tracking columns (`created_at`, `updated_at`, `deleted_at`, `created_by`).

---

## 4. Auth Domain Tables

### 4.1 `auth_users`
* **Purpose:** Core identity anchor for student users.
* **Module Owner:** `AuthModule`
* **Expected Row Count:** Initial: 10,000 | 3-Year Projection: 1,000,000
* **Required Indexes:** Unique B-Tree index on `email`, Partial index on `is_active WHERE deleted_at IS NULL`.
* **Audit Policy:** Soft delete enabled (`deleted_at`).
* **Business Constraints:** Email must be lowercase; password hash must be non-null bcrypt string.
* **Future Expansion Fields:** `two_factor_secret`, `sso_provider_id`.

### 4.2 `auth_refresh_tokens`
* **Purpose:** Stores Bcrypt hashed refresh token families for JWT session rotation.
* **Module Owner:** `AuthModule`
* **Expected Row Count:** Initial: 30,000 | 3-Year Projection: 3,000,000
* **Required Indexes:** Secondary B-Tree index on `user_id`, Index on `expires_at` for cron cleanup.
* **Audit Policy:** Hard delete allowed upon expiration or explicit logout.

### 4.3 `auth_sessions`
* **Purpose:** Tracks active device logins, IP addresses, and user-agent details.
* **Module Owner:** `AuthModule`
* **Expected Row Count:** 3-Year Projection: 2,000,000

---

## 5. Profile Domain Tables

### 5.1 `user_profiles`
* **Purpose:** Stores student academic bio, specialization, and profile avatar link.
* **Module Owner:** `ProfileModule`
* **Expected Row Count:** 1:1 relationship with `auth_users` (1,000,000 rows at 3 years).
* **Required Indexes:** Unique index on `user_id`.

### 5.2 `user_education`
* **Purpose:** Stores academic institution history and degree tracks.
* **Module Owner:** `ProfileModule`

### 5.3 `user_skills`
* **Purpose:** Stores student skill tags (e.g., Python, Financial Accounting).
* **Module Owner:** `ProfileModule`

### 5.4 `career_goals`
* **Purpose:** Stores long-term career aspirations and AI-generated milestone roadmaps.
* **Module Owner:** `ProfileModule`

### 5.5 `user_preferences`
* **Purpose:** Stores UI theme preferences, timezone settings, and locale options.
* **Module Owner:** `ProfileModule`

---

## 6. Planner Domain Tables

### 6.1 `planner_tasks`
* **Purpose:** Primary table storing student assignments, tasks, and exam study plans.
* **Module Owner:** `PlannerModule`
* **Expected Row Count:** Initial: 500,000 | 3-Year Projection: 50,000,000
* **Growth Sizing:** ~100 bytes per row (~5GB at 50M rows).
* **Required Indexes:** Compound B-Tree index on `(user_id, due_date)`, Partial index on `(user_id) WHERE status = 'PENDING'`.
* **Audit Policy:** Soft delete enabled.

### 6.2 `planner_categories`
* **Purpose:** User-defined color-coded course categories (e.g., CS201, Math301).
* **Module Owner:** `PlannerModule`

### 6.3 `planner_reminders`
* **Purpose:** Time-based push notification reminder triggers associated with tasks.
* **Module Owner:** `PlannerModule`

### 6.4 `planner_study_schedules`
* **Purpose:** AI-optimized daily time blocks allocated for specific assignments.
* **Module Owner:** `PlannerModule`

---

## 7. Finance Domain Tables

### 7.1 `finance_budgets`
* **Purpose:** Stores monthly income/pocket money allowances and overall budget caps.
* **Module Owner:** `FinanceModule`

### 7.2 `finance_expenses`
* **Purpose:** High-volume transaction table logging daily student expenditures.
* **Module Owner:** `FinanceModule`
* **Expected Row Count:** Initial: 1,000,000 | 3-Year Projection: 100,000,000
* **Required Indexes:** Compound index on `(user_id, spent_at)`, Secondary index on `category_id`.
* **Partitioning Strategy:** Range partitioned by `spent_at` date when row count exceeds 10M.

### 7.3 `finance_categories`
* **Purpose:** Pre-populated and custom expense classification categories (Food, Academic, Transport).
* **Module Owner:** `FinanceModule`

### 7.4 `finance_monthly_summaries`
* **Purpose:** Denormalized read-model storing pre-computed end-of-month spend metrics.
* **Module Owner:** `FinanceModule`

### 7.5 `finance_saving_goals`
* **Purpose:** Tracks target savings allocations for emergency funds or specific student purchases.
* **Module Owner:** `FinanceModule`

---

## 8. AI Domain Tables

### 8.1 `ai_conversations`
* **Purpose:** Stores AI Mentor chat session metadata.
* **Module Owner:** `AIMentorModule`

### 8.2 `ai_messages`
* **Purpose:** Stores individual prompt/response chat turns between student and Gemini API.
* **Module Owner:** `AIMentorModule`
* **Expected Row Count:** 3-Year Projection: 20,000,000

### 8.3 `ai_recommendations`
* **Purpose:** Contextual tips generated for dashboard feeds and planner optimization.
* **Module Owner:** `AIMentorModule`

### 8.4 `ai_decision_history`
* **Purpose:** Logs system prompt inputs, temperature parameters, and token counts for AI tuning.
* **Module Owner:** `AIMentorModule`

---

## 9. Notifications, Uploads & Payments Tables

### 9.1 `notifications`
* **Purpose:** Stores delivered and pending push notifications (`user_id`, `title`, `body`, `is_read`).
* **Expected Row Count:** 3-Year Projection: 30,000,000

### 9.2 `notification_preferences`
* **Purpose:** Toggle preferences for user push notification channels.

### 9.3 `uploaded_files`
* **Purpose:** Metadata records for images and PDFs stored in Cloudinary CDN.

### 9.4 `payments`
* **Purpose:** Billing transaction history for Razorpay test mode payments.

### 9.5 `subscriptions`
* **Purpose:** Tracks active premium tier memberships and renewal dates.

---

## 10. Analytics & Future Expansion Tables

### 10.1 `productivity_metrics`
* **Purpose:** Daily aggregated productivity scores and task completion metrics.

### 10.2 `financial_metrics`
* **Purpose:** Daily burn rate indexes and safe daily spend compliance trends.

### 10.3 `teams`
* **Purpose:** Future entity for student study group collaboration rooms.

### 10.4 `organisations`
* **Purpose:** Future entity for B2B university department licensing.

### 10.5 `activity_timeline`
* **Purpose:** Centralized user activity event stream log.

---

## 11. Architectural Rationale & Trade-Off Analysis

### Decision: Dedicated Financial Category Table vs Free-Form String Category

| Evaluation Vector | Free-Form String (`category: string`) | Relational Category Table (`finance_categories`) |
| :--- | :--- | :--- |
| **Architectural Rationale** | Easy for quick prototypes; leads to spelling variations ("Food" vs "food" vs "Foods"). | Chosen for Nexus AI. Guarantees clean category aggregation and analytics reporting. |
| **Advantages** | Simple insertion without foreign keys. | Strict consistency, easy category renaming, accurate analytical grouping. |
| **Disadvantages** | Data inconsistency; impossible to group reliably in analytics. | Requires foreign key validation on expense creation. |
| **Performance Impact** | Fast writes; slow aggregated reads. | Sub-millisecond indexed joins. |
| **Scalability Impact** | Severe analytics reporting debt. | High scalability. |
| **Maintainability Impact**| Low maintainability. | Extremely High. |

---

## 12. Enterprise Best Practices

1. **Pre-Calculate Row Sizes:** Compute average row byte sizes to estimate disk space growth prior to database provisioning.
2. **Isolate High-Volume Tables:** Design tables expected to exceed 10M rows (`finance_expenses`, `ai_messages`) with date-based partitioning keys from day one.

---

## 13. Future Considerations

* Integration of `pgvector` columns (`vector(768)`) into `ai_messages` for localized semantic search across chat history.

---

## 14. Cross References

* [07-module-breakdown.md](file:///d:/Nexus-AI/backend/docs/07-module-breakdown.md)
* [22-entity-relationship-design.md](file:///d:/Nexus-AI/backend/docs/22-entity-relationship-design.md)
* [25-indexing-strategy.md](file:///d:/Nexus-AI/backend/docs/25-indexing-strategy.md)
