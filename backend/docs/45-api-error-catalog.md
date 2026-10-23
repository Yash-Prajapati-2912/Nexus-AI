# Nexus AI Backend - Master API Error Catalog & Troubleshooting Guide

**Document Version:** 1.0.0  
**Author:** Principal API Architect & Senior Backend Engineer  
**Last Updated:** July 25, 2026  

---

## Table of Contents
1. [Document Purpose](#1-document-purpose)
2. [Document Scope](#2-document-scope)
3. [Error Catalog Taxonomy & Code Structure](#3-error-catalog-taxonomy--code-structure)
4. [Authentication & Authorization Errors (`ERR_AUTH_*`)](#4-authentication--authorization-errors-err_auth_)
5. [Validation & Request Errors (`ERR_VAL_*`)](#5-validation--request-errors-err_val_)
6. [Smart Planner Errors (`ERR_PLAN_*`)](#6-smart-planner-errors-err_plan_)
7. [Smart Finance Errors (`ERR_FIN_*`)](#7-smart-finance-errors-err_fin_)
8. [AI Mentor Gateway Errors (`ERR_AI_*`)](#8-ai-mentor-gateway-errors-err_ai_)
9. [User Profile & Preferences Errors (`ERR_PROF_*`)](#9-user-profile--preferences-errors-err_prof_)
10. [Notification & Device Token Errors (`ERR_NOTIF_*`)](#10-notification--device-token-errors-err_notif_)
11. [Uploads & Media Errors (`ERR_UPL_*`)](#11-uploads--media-errors-err_upl_)
12. [Payments & Subscription Errors (`ERR_PAY_*`)](#12-payments--subscription-errors-err_pay_)
13. [Database & System Infrastructure Errors (`ERR_SYS_*`)](#13-database--system-infrastructure-errors-err_sys_)
14. [Client Implementation Rules & Retry Strategies](#14-client-implementation-rules--retry-strategies)
15. [Cross References](#15-cross-references)

---

## 1. Document Purpose

This document provides the definitive Master API Error Catalog for the Nexus AI backend. It enumerates every custom internal error code, HTTP status mapping, root cause reason, recommended client UI action, and automated retry behavior for mobile and web developers.

---

## 2. Document Scope

Applies to all error codes emitted by the NestJS Global Exception Filter across all core user modules and infrastructure gateways.

---

## 3. Error Catalog Taxonomy & Code Structure

Custom error codes follow a strict prefix naming pattern:  
`ERR_<MODULE>_<NUMERIC_ID>`

* **`ERR_AUTH_*`**: Authentication & JWT Session Errors
* **`ERR_VAL_*`**: Input Validation & Payload Errors
* **`ERR_PLAN_*`**: Smart Planner Domain Errors
* **`ERR_FIN_*`**: Smart Finance Domain Errors
* **`ERR_AI_*`**: AI Mentor Gateway & Gemini API Errors
* **`ERR_PROF_*`**: Profile & Settings Domain Errors
* **`ERR_NOTIF_*`**: Push Notification Errors
* **`ERR_UPL_*`**: Media Upload & Cloudinary Errors
* **`ERR_PAY_*`**: Payment Gateway & Webhook Errors
* **`ERR_SYS_*`**: PostgreSQL & Server Infrastructure Errors

---

## 4. Authentication & Authorization Errors (`ERR_AUTH_*`)

| Error Code | HTTP Status | Description | Root Cause Reason | Recommended Client Action | Retryable? |
| :--- | :---: | :--- | :--- | :--- | :---: |
| `ERR_AUTH_001` | 401 | Invalid Credentials | Email or password incorrect. | Prompt user to check login details. | No |
| `ERR_AUTH_002` | 401 | Token Expired | Access Token 15-minute TTL elapsed. | Automatically invoke `/auth/refresh`. | Yes |
| `ERR_AUTH_003` | 401 | Invalid Refresh Token | Refresh Token invalid or revoked. | Clear local storage & redirect to Login. | No |
| `ERR_AUTH_004` | 403 | Forbidden Role Access | User lacks required RBAC role. | Display "Access Denied" dialog. | No |
| `ERR_AUTH_005` | 409 | Email Already Registered | Registration email exists in DB. | Prompt user to log in or reset password.| No |

---

## 5. Validation & Request Errors (`ERR_VAL_*`)

| Error Code | HTTP Status | Description | Root Cause Reason | Recommended Client Action | Retryable? |
| :--- | :---: | :--- | :--- | :--- | :---: |
| `ERR_VAL_001` | 400 | Payload Validation Failed | Request body violated DTO constraints. | Highlight invalid form fields in UI. | No |
| `ERR_VAL_002` | 400 | Malformed JSON | Syntax error in incoming HTTP body. | Verify JSON serializer formatting. | No |

---

## 6. Smart Planner Errors (`ERR_PLAN_*`)

| Error Code | HTTP Status | Description | Root Cause Reason | Recommended Client Action | Retryable? |
| :--- | :---: | :--- | :--- | :--- | :---: |
| `ERR_PLAN_001` | 404 | Task Not Found | Target task UUID does not exist. | Refresh task list feed. | No |
| `ERR_PLAN_002` | 422 | Invalid Due Date | Task due date is in the past. | Prompt student to select valid date. | No |

---

## 7. Smart Finance Errors (`ERR_FIN_*`)

| Error Code | HTTP Status | Description | Root Cause Reason | Recommended Client Action | Retryable? |
| :--- | :---: | :--- | :--- | :--- | :---: |
| `ERR_FIN_001` | 400 | Budget Exceeded | Expense amount exceeds remaining cap. | Display insolvency warning dialog. | No |
| `ERR_FIN_002` | 404 | Category Not Found | Target expense category ID invalid. | Refresh expense categories list. | No |

---

## 8. AI Mentor Gateway Errors (`ERR_AI_*`)

| Error Code | HTTP Status | Description | Root Cause Reason | Recommended Client Action | Retryable? |
| :--- | :---: | :--- | :--- | :--- | :---: |
| `ERR_AI_001` | 503 | Gemini Gateway Timeout | Gemini API failed to respond in <5s. | Display retry button with backoff. | Yes |
| `ERR_AI_002` | 429 | AI Rate Limit Exceeded | User hit 10 requests/hour Freemium cap. | Prompt student to upgrade plan. | No |

---

## 9. User Profile & Preferences Errors (`ERR_PROF_*`)

| Error Code | HTTP Status | Description | Root Cause Reason | Recommended Client Action | Retryable? |
| :--- | :---: | :--- | :--- | :--- | :---: |
| `ERR_PROF_001` | 404 | Profile Not Found | User profile record missing. | Re-authenticate user. | No |

---

## 10. Notification & Device Token Errors (`ERR_NOTIF_*`)

| Error Code | HTTP Status | Description | Root Cause Reason | Recommended Client Action | Retryable? |
| :--- | :---: | :--- | :--- | :--- | :---: |
| `ERR_NOTIF_001`| 400 | Invalid FCM Token | FCM device token string malformed. | Re-register FCM token via Flutter SDK. | Yes |

---

## 11. Uploads & Media Errors (`ERR_UPL_*`)

| Error Code | HTTP Status | Description | Root Cause Reason | Recommended Client Action | Retryable? |
| :--- | :---: | :--- | :--- | :--- | :---: |
| `ERR_UPL_001` | 413 | File Too Large | Upload payload exceeds 5MB size limit. | Prompt user to compress file. | No |
| `ERR_UPL_002` | 400 | Invalid MIME Type | Magic bytes failed image/PDF check. | Prompt user to upload valid image/PDF. | No |

---

## 12. Payments & Subscription Errors (`ERR_PAY_*`)

| Error Code | HTTP Status | Description | Root Cause Reason | Recommended Client Action | Retryable? |
| :--- | :---: | :--- | :--- | :--- | :---: |
| `ERR_PAY_001` | 400 | Invalid Webhook Signature| Razorpay HMAC SHA256 check failed. | Log security warning alert. | No |

---

## 13. Database & System Infrastructure Errors (`ERR_SYS_*`)

| Error Code | HTTP Status | Description | Root Cause Reason | Recommended Client Action | Retryable? |
| :--- | :---: | :--- | :--- | :--- | :---: |
| `ERR_SYS_001` | 500 | Internal Server Error | Unhandled backend exception. | Display generic error dialog + log ID. | Yes |
| `ERR_SYS_002` | 503 | Database Unavailable | PostgreSQL connection pool exhausted. | Automatic client exponential backoff. | Yes |

---

## 14. Client Implementation Rules & Retry Strategies

1. **Automatic Refresh Strategy (`ERR_AUTH_002`):** Mobile HTTP client interceptor MUST automatically intercept `HTTP 401` with `ERR_AUTH_002`, execute `POST /auth/refresh`, and retry original request transparently.
2. **Exponential Backoff (`Retryable: Yes`):** Client retries retryable 5xx errors after $2^n \times 100\text{ms}$ delay (where $n$ is retry attempt 1 to 3).

---

## 15. Cross References

* [13-error-handling.md](file:///d:/Nexus-AI/backend/docs/13-error-handling.md)
* [31-api-overview.md](file:///d:/Nexus-AI/backend/docs/31-api-overview.md)
* [44-api-response-standard.md](file:///d:/Nexus-AI/backend/docs/44-api-response-standard.md)
