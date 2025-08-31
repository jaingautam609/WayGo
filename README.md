# 🌍 WayGo — Travel Booking App (iOS + Go Backend)

A complete full-stack demo travel app built with:
- 📱 iOS (SwiftUI) frontend
- 🛠️ Go + Gin backend (REST API)
- 🗄️ PostgreSQL database
- 💳 Stripe PaymentSheet (test mode)
- 🔐 JWT-based Auth
- 🛒 Cart + Custom Package Builder
- ✈️ Booking Flights, Trains, Stays, Cabs (demo mode)

---

## 📁 Folder Structure

WayGo/ # GitHub repo root
├── server/ # Go backend code
│ ├── cmd/ # Main entrypoint (main.go)
│ ├── internal/ # Routes, DB, handlers, middleware, config
│ └── .env.local # Your environment variables (not committed)
│
├── WayGo/ # iOS SwiftUI Xcode app
│ └── WayGo.xcodeproj # or .xcworkspace
│
├── go.mod # Go module at root
└── go.sum

yaml
Copy code

---

## 🚀 How to Run This Project from Scratch

### ✅ Prerequisites

| Backend              | Frontend             |
|----------------------|----------------------|
| Go 1.22+             | macOS with Xcode 15+ |
| PostgreSQL 14+       | Swift 5.9+           |
| Ngrok (if using iPhone) | Stripe test keys    |

---

### 🔧 Step 1: Backend Setup (`server/`)

1. **Create database**
   ```bash
   createdb travelapp
Set environment variables

Create a file called .env.local inside the server/ folder with:

env
Copy code
DATABASE_URL=postgres://<user>:<pass>@localhost:5432/travelapp?sslmode=disable
JWT_SECRET=super_secret_jwt_key
STRIPE_SECRET_KEY=sk_test_********************************
PORT=8080
Apply schema

If schema.sql is included, run:

bash
Copy code
psql "$DATABASE_URL" -f server/schema.sql
Run backend

From project root:

bash
Copy code
go run ./server/cmd
✅ Backend should now be running at: http://localhost:8080

(Optional) To test on iPhone, expose backend via ngrok:

bash
Copy code
ngrok http 8080
Use the HTTPS URL for your frontend.

📱 Step 2: iOS App Setup (WayGo/)
Open Xcode

File → Open → Select WayGo/WayGo.xcodeproj

Update API Base URL

Open APIService.swift and update:

swift
Copy code
enum APIService {
    // Use localhost for simulator or ngrok HTTPS for iPhone
    static let baseURL = "https://<your-ngrok-subdomain>.ngrok.io"
}
Add Stripe SDK

Xcode → File → Add Packages…

URL: https://github.com/stripe/stripe-ios

Add to the WayGo app target

Set Stripe Publishable Key

In StripeService.swift:

swift
Copy code
enum StripeService {
    static let publishableKey = "pk_test_********************************"
    static let currency = "usd" // or "inr"
}
Run the app

Select Simulator or iPhone device

Build & Run (⌘ + R)

💳 Stripe Test Instructions
Use test card:

yaml
Copy code
4242 4242 4242 4242
Exp: Any future date
CVV: Any 3 digits
ZIP: Any 5-digit code
You can simulate payment success/failure during checkout.
