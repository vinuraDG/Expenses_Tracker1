Expense Tracker Mobile App

A modern Expense Tracker mobile application built with Flutter that helps users easily manage and monitor their daily expenses.
The app provides secure authentication, real-time data storage, and receipt image uploads using cloud services.

This project demonstrates integration of modern mobile technologies including Firebase Authentication, Cloud Firestore, and Cloudinary.

📱 Features
🔐 Secure User Authentication
➕ Add new expense records
✏️ Edit and update expenses
❌ Delete expenses
☁️ Real-time data storage
🧾 Upload receipt images
📊 Track personal spending
📱 Clean and user-friendly mobile interface

🛠️ Technologies Used

Technology	                            Purpose
Flutter	                                Cross-platform mobile app development
Dart	                                  Programming language for Flutter
Firebase Authentication	                User login & registration
Cloud Firestore	                        Real-time NoSQL database
Cloudinary	                            Cloud storage for receipt images
Git	                                    Version control
GitHub	                                Code hosting

🏗️ Project Structure

lib/
│
├── core/                # Core utilities and shared services
├── models/              # Data models for the application
├── providers/           # State management using Provider
├── routes/              # Application navigation and route management
├── screens/             # UI screens of the application
├── theme/               # App themes, colors, and styles
├── widgets/             # Reusable UI components
│
├── firebase_options.dart  # Firebase configuration file
└── main.dart              # Application entry point
 
🚀 Getting Started

1️⃣ Clone the Repository
git clone https://github.com/vinuraDG/Expenses_Tracker1.git

2️⃣ Navigate to the Project Folder
cd Expenses_Tracker1

3️⃣ Install Dependencies
flutter pub get

4️⃣ Run the Application
flutter run


🔑 Firebase Setup

Create a project in Firebase
Enable Authentication
Enable Cloud Firestore
Download google-services.json

Place it inside
android/app/

☁️ Cloudinary Setup

Create an account at Cloudinary

Get:
Cloud name

API key
Configure them inside the project for image upload.


🎯 Future Improvements

📊 Expense analytics charts
📅 Monthly budget tracking
📈 Spending reports
🌙 Dark mode
🔔 Notifications

## 🔧 Git Workflow & Contribution Guide

### 📥 Clone the Repository

```bash
git clone https://github.com/vinuraDG/Expenses_Tracker1.git
cd Expenses_Tracker1
```

---

### 🌿 Create a New Branch

```bash
git checkout -b feature/your-feature-name
```

---

### 💾 Make Changes & Commit

```bash
git add .
git commit -m "feat: add your feature name"
```

---

### 🚀 Push to GitHub

```bash
git push origin feature/your-feature-name
```

---

### 🔀 Create a Pull Request

1. Go to your GitHub repository
2. Click **"Compare & pull request"**
3. Add description
4. Click **"Create pull request"**

---

### 📝 Commit Message Convention

* `feat:` → New feature
* `fix:` → Bug fix
* `docs:` → Documentation changes
* `style:` → UI/design changes
* `refactor:` → Code improvement

Example:

```bash
git commit -m "fix: resolve login issue"
```

👨‍💻 Author

Vinura Gamage
Mobile Developer | Flutter Enthusiast

GitHub: https://github.com/vinuraDG

