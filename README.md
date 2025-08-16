# 📱 Social Media App

A simple Flutter app that lets users register, log in, verify their email, and share posts—similar to a basic social feed.

## 🚀 Features

- 📝 Register and log in with email & password
- 📧 Email verification required before posting
- ➕ Add, Edit, and  Delete posts
- 📰 Feed shows posts with author, content, and time 
- 🚪 Logout via a side drawer
- 🎨 Facebook-like UI with a post composer and feed cards 

## ⚙️ Structure Details

- 🔑 **Firebase Authentication** → Handles user accounts & email verification  
- ☁️ **Cloud Firestore** → Stores posts & user data  
- 🧩 **Custom Widgets & Stateful Logic** → For editing, deleting, and displaying posts  

## 🏗 Architecture

This project follows a modular structure:

```text
lib/
├── main.dart                        # App entry point
├── firebase_options.dart            # Firebase config
├── screens/
│   ├── auth_screen.dart             # Login/Register screen
│   ├── email_verification_screen.dart # Email verification
│   └── posts_screen.dart            # Main feed screen
├── services/
│   ├── auth_service.dart            # Authentication logic
│   └── firestore_service.dart       # Firestore logic
├── validators/
│   └── auth_validators.dart         # Form validation helpers
└── widgets/
    ├── login_form.dart              # Login form widget
    ├── register_form.dart           # Register form widget
    └── post_card.dart               # Post card widget
```

## 🛠 Technologies & Packages

- Flutter SDK ^3.x  
- Dart ^3.x  
- Firebase Authentication  
- Cloud Firestore  
- Provider / custom state handling  

## 📋 Prerequisites

Make sure you have:

- ✅ Flutter SDK (latest stable)  
- ✅ Dart SDK  
- ✅ Firebase project set up ([Firebase Console](https://console.firebase.google.com/))  
- ✅ Android Studio or VS Code with Flutter tools  
