<div align="center">

# 🟢 FinTrack

### AI-Powered Personal Finance Tracker

*Upload your bank statement. Get instant AI insights.*

[![Spring Boot](https://img.shields.io/badge/Spring%20Boot%203-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Next.js](https://img.shields.io/badge/Next.js%2014-000000?style=for-the-badge&logo=nextdotjs&logoColor=white)](https://nextjs.org)
[![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org)
[![Google Gemini](https://img.shields.io/badge/Gemini%202.5%20Flash-8E75B2?style=for-the-badge&logo=google&logoColor=white)](https://ai.google.dev)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com)

**[🚀 Live Demo](https://fintrack.omidtavassoli.dev)** · Demo: `demo@fintrack.com` / `demo1234`

![FinTrack Demo](frontend/public/fintrack-demo.gif)

</div>

---

![FinTrack Demo](frontend/public/fintrack-demo.gif)

> Upload your bank statement. Get instant AI insights.

**[Live Demo](https://fintrack.omidtavassoli.dev)** 

---

## What it does

German banks give you raw transaction lists with no intelligence. FinTrack takes your monthly PDF bank statement and turns it into actionable insights — automatically categorized, anomaly-detected, and queryable in plain language.

No bank connection required. No subscription. Your data stays on your server.

---

## Demo

**[fintrack.omidtavassoli.dev](https://fintrack.omidtavassoli.dev)** 

---

## Features

| Feature | Description |
|---------|-------------|
| **PDF Extraction** | Gemini Vision reads any German bank PDF and returns structured transaction data |
| **AI Categorization** | Rule cache handles known merchants instantly. Gemini covers the rest with 98%+ accuracy |
| **Anomaly Detection** | Z-score analysis automatically flags unusual spending |
| **NL Query Engine** | Ask "How much did I spend on food in October?" — get a precise answer |
| **AI Chat Assistant** | Conversational finance advisor with full access to your transaction history |
| **Budget Tracking** | Set monthly limits per category, track progress visually |
| **Analytics Dashboard** | Monthly charts, category breakdown, anomaly alerts |

---

## How the AI pipeline works

PDF Upload
→ Gemini Vision extracts transactions as structured JSON
→ TextNormalizer cleans raw bank descriptions
→ Rule cache checked first (learns from your corrections)
→ Gemini Flash called only for unknown merchants
→ Z-score anomaly detection runs on categorized data
→ NL query engine translates plain language → SQL → answer

The system learns from corrections — every category override becomes a rule that skips Gemini on future uploads.

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | Spring Boot 3, Java 21 |
| Database | PostgreSQL + Flyway |
| AI | Google Gemini 2.5 Flash (multimodal) |
| Frontend | Next.js 14, TypeScript, Tailwind |
| Charts | Recharts |
| Auth | JWT |
| Infrastructure | Docker, Nginx, Hetzner VPS |

---

## Architecture

<div align="center">

| Layer | Technology | Role |
|-------|-----------|------|
| **Browser** | Next.js 14 | Frontend SPA |
| **Reverse Proxy** | Nginx + SSL | Routing + HTTPS |
| **Backend** | Spring Boot 3 | REST API + Business Logic |
| **Database** | PostgreSQL + Flyway | Persistence + Migrations |
| **AI** | Gemini 2.5 Flash | PDF Extraction + Categorization + NL Queries |

</div>

### Request Flow

User → Nginx → Spring Boot → PostgreSQL
↓
Gemini 2.5 Flash
(PDF extraction / categorization / NL queries)

### AI Pipeline

PDF Upload
↓
Gemini Vision extracts transactions as JSON
↓
TextNormalizer cleans raw descriptions
↓
Rule Cache lookup (global + user corrections)
↓ (no match)
Gemini Flash categorizes unknown merchants
↓
Z-score anomaly detection
↓
Stored in PostgreSQL

---

## Project Structure

<table>
<tr>
<td valign="top" width="50%">

**Backend** `Spring Boot 3 · Java 21`

backend/src/main/java/
└── com/fintrack/fintrack/
├── controller/
│   ├── AuthController
│   ├── TransactionController
│   ├── AnalyticsController
│   ├── ChatController
│   ├── BudgetController
│   └── NlQueryController
├── service/
│   ├── GeminiClient
│   ├── GeminiPdfExtractor
│   ├── CategorizationService
│   ├── PdfIngestionService
│   ├── AnomalyDetectionService
│   ├── NlQueryService
│   ├── ChatService
│   └── TextNormalizer
├── repository/
├── entity/
├── dto/
├── security/
└── exception/

</td>
<td valign="top" width="50%">

**Frontend** `Next.js 14 · TypeScript · Tailwind`
frontend/src/app/
├── (auth)/
│   └── login/
│       └── page.tsx
└── (app)/
├── dashboard/
│   └── page.tsx
├── transactions/
│   └── page.tsx
├── upload/
│   └── page.tsx
├── chat/
│   └── page.tsx
└── budgets/
└── page.tsx

**Database Migrations** `Flyway`
V1 — users
V2 — categories
V3 — transactions
V4 — budgets
V5 — global_category_rules
V6 — user_category_rules

</td>
</tr>
</table>

---

** Built by Omid Tavassoli [portfolio.omidtavassoli.dev](https://portfolio.omidtavassoli.dev)