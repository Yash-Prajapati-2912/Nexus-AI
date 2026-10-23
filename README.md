# Nexus AI — AI-Powered Student Life Operating System

![Nexus AI Banner](frontend/assets/branding/banner.png)

Nexus AI is an enterprise-grade, AI-powered student productivity and personal finance management platform. It combines academic task planning, document intelligence, budgeting, savings goal tracking, and context-aware AI mentorship into a unified cross-platform application.

---

## 1. Executive Summary & Overview

Nexus AI acts as a single operational dashboard for college students to manage:
- **Academic Tasks & Deadlines**: Smart scheduling, priority tracking, due dates, and completion metrics.
- **Academic Document Intelligence**: Automatic text extraction from course PDFs, 2-stage academic classification, and multi-assignment task segmentation.
- **Personal Finance & Budgeting**: Expense tracking, category breakdowns, monthly budget health run-rates, and savings goal progress.
- **Context-Aware AI Assistance**: Chat agent with direct visibility into real student planner and financial context for intelligent recommendations.
- **Student Profile & Customization**: Preference controls, theme toggles, and security settings.

---

## 2. Technology Stack

### Frontend (Flutter App)
- **Framework**: Flutter 3.x (Dart 3)
- **State Management**: BLoC Pattern (`flutter_bloc`)
- **Navigation**: Declarative Routing with `go_router`
- **Dependency Injection**: Service Locator via `get_it`
- **Networking**: `dio` REST API Client with RFC 7807 problem details handling
- **PDF Text Processing**: Syncfusion PDF (`syncfusion_flutter_pdf`)
- **Charts & Visualizations**: `fl_chart`

### Backend (REST API Service)
- **Framework**: NestJS (Node.js / TypeScript)
- **Database**: PostgreSQL with TypeORM
- **Authentication**: JWT Token Authentication & BCrypt Password Hashing
- **AI Integration**: Google Gemini 1.5 Pro API integration

---

## 3. High-Level System Architecture

```
                               ┌─────────────────────────┐
                               │  Nexus AI User / Client │
                               └────────────┬────────────┘
                                            │
                                            ▼
                        ┌───────────────────────────────────────┐
                        │      Flutter Web / Mobile App         │
                        │ ┌───────────────────────────────────┐ │
                        │ │ Presentation Layer (Pages/Widgets)│ │
                        │ ├───────────────────────────────────┤ │
                        │ │ BLoC State Management Layer       │ │
                        │ ├───────────────────────────────────┤ │
                        │ │ Domain Layer (Entities & UseCases)│ │
                        │ ├───────────────────────────────────┤ │
                        │ │ Data Layer (Repos & ApiClient)    │ │
                        │ └─────────────────┬─────────────────┘ │
                        └───────────────────┼───────────────────┘
                                            │ HTTP / REST (JSON)
                                            ▼
                        ┌───────────────────────────────────────┐
                        │          NestJS Backend API           │
                        │ ┌───────────────────────────────────┐ │
                        │ │ Authentication & User Controller  │ │
                        │ ├───────────────────────────────────┤ │
                        │ │ Tasks & Planner Controller        │ │
                        │ ├───────────────────────────────────┤ │
                        │ │ Finance & Expense Controller      │ │
                        │ ├───────────────────────────────────┤ │
                        │ │ AI Mentor / Agent Controller      │ │
                        │ └─────────────────┬─────────────────┘ │
                        └───────────────────┼───────────────────┘
                                            │
                                   ┌────────┴────────┐
                                   ▼                 ▼
                          ┌────────────────┐  ┌─────────────┐
                          │ PostgreSQL DB  │  │ Gemini AI   │
                          │ (Data Storage) │  │ Service API │
                          └────────────────┘  └─────────────┘
```

---

## 4. Key Feature Modules

### 1. Smart Planner & Task Management
- Create, edit, complete, search, filter, and prioritize academic tasks.
- Categorize by *Assignments & Coursework*, *Exam Preparation*, *Study Materials*, *Projects*, and *Practical & Lab*.
- Visual due date indicators, progress tracking, and category tags.

### 2. Document Intelligence & PDF Extraction
- Upload academic PDF documents (assignments, syllabi, lecture notes, lab manuals).
- Extraction quality validation for scanned PDFs or unreadable text.
- **Stage 1 (Classification)**: Identifies document type (*Syllabus*, *Assignment Collection*, *Notes*, etc.) and infers subject/course.
- **Stage 2 (Segmentation)**: Automatically breaks multi-assignment documents into individual actionable tasks with step-by-step guidance.

### 3. Personal Finance & Budgeting
- Track expenses, income sources, and custom expenditure categories.
- Real-time **Budget Health Card**: Calculates daily safe spending caps and monthly projected run-rates.
- **Savings Goals**: Target tracking with automated ratio calculation and progress indicators.
- Donut chart breakdowns and cash flow visual analytics.

### 4. Context-Aware AI Agent
- Natural language chat assistant.
- Injects live planner statistics and finance metrics into AI prompt context.
- Quick action prompt chips for rapid guidance on time management, budget optimization, and study strategy.

### 5. Profile & Settings
- Account management, security settings, session timeout configurations, and data backup controls.

---

## 5. Academic Document Processing Workflow

```
┌───────────────┐     ┌───────────────────────┐     ┌────────────────────────────┐
│ Upload PDF    │ ──► │ Syncfusion PDF        │ ──► │ Quality Validation         │
│ Document      │     │ Text Extraction       │     │ (Page & Character Count)   │
└───────────────┘     └───────────────────────┘     └─────────────┬──────────────┘
                                                                  │
                                                                  ▼
┌───────────────┐     ┌───────────────────────┐     ┌────────────────────────────┐
│ Actionable    │ ◄── │ 2-Stage Academic      │ ◄── │ Content & Keyword          │
│ Tasks Created │     │ Classifier Engine     │     │ Pattern Analysis           │
└───────────────┘     └───────────────────────┘     └────────────────────────────┘
```

1. **Extraction**: Syncfusion `PdfTextExtractor` parses raw selectable text page-by-page.
2. **Quality Check**: Detects scanned or image-only PDFs and provides user feedback.
3. **Classification**: Evaluates action keywords (e.g. *Assignment*, *Syllabus*, *Unit*, *Submit*) to categorize the document type and infer the course code.
4. **Segmentation**: Multi-assignment sheets (such as EEJS) are segmented into distinct tasks with independent titles, deadlines, and deliverables.

---

## 6. Project Directory Structure

```txt
Nexus-AI/
├── backend/                       # NestJS API Server
│   ├── src/                       # Controllers, Services, Modules, TypeORM Entities
│   ├── package.json               # Backend dependencies & script definitions
│   └── README.md                  # Backend specific documentation
├── frontend/                      # Flutter Application
│   ├── lib/
│   │   ├── core/                  # Network, storage, security, error handling
│   │   ├── features/              # Feature modules (Auth, Dashboard, Planner, Finance, AI, Profile)
│   │   ├── shared/                # Shared widgets & components
│   │   ├── theme/                 # Material 3 Design System & Tokens
│   │   └── main.dart              # Application entry point
│   ├── test/                      # Unit, widget, and regression tests
│   ├── pubspec.yaml               # Flutter dependencies & assets config
│   └── README.md                  # Frontend specific documentation
└── ARCHITECTURE.md                # System Architecture & Data Flow Reference
```

---

## 7. Developer Setup & Prerequisites

### Prerequisites
- **Node.js**: v18+ & `pnpm` or `npm`
- **Flutter SDK**: v3.19+ (Dart 3.x)
- **PostgreSQL**: v14+ (Local instance or Docker container)

### 1. Backend Setup
```bash
cd backend
pnpm install
# Copy environment template
cp .env.example .env
# Start local NestJS development server
pnpm start:dev
```

### 2. Frontend Setup
```bash
cd frontend
flutter pub get
# Run Flutter app on Web (Chrome)
flutter run -d chrome
```

---

## 8. Testing & Verification Commands

### Execute Automated Unit & Widget Tests
```bash
cd frontend
flutter test
```

### Execute Static Analysis (Zero Errors & Warnings Requirement)
```bash
cd frontend
flutter analyze lib/ test/
```

---

## 9. Verification & Quality Assurance Results

- **Analyzer Result**: `No issues found!` (0 errors, 0 warnings across `lib/` and `test/`)
- **Test Suite Result**: `All tests passed!` (47 unit and widget tests passing)
- **Form Safety**: Submission guards (`_isSubmitting`, `_isSaving`) enforce double-tap protection on form submissions.
- **Math Safety**: Division operations use explicit checks against `0` and clamp percentage values between `0.0` and `1.0`.

---

## 10. License & Project Metadata

- **Application Name**: Nexus AI
- **Version**: 1.0.0
- **Authors**: Nexus AI Project Team
