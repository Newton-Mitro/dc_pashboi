# Credit Union Mobile App (Flutter)

## Overview

The **Credit Union Mobile App** is designed to provide credit union members with a convenient, secure, and seamless way to manage their accounts, loans, and transactions directly from their mobile devices. With this app, members can check account balances, transfer funds, view transaction history, manage loans, and much more, all from the palm of their hands.

Built with **Flutter**, this app is optimized for both iOS and Android devices, offering a smooth cross-platform experience.

## Features

- **Account Overview**: View balances of checking, savings, and loan accounts.
- **Fund Transfers**: Easily transfer funds between accounts or to other members.
- **Loan Management**: Track loan status, repayments, and outstanding balances.
- **Transaction History**: Search and view past transactions with sorting filters.
- **Push Notifications**: Receive push notifications for account activities, transfers, payments, and more.
- **Bill Payments**: Pay bills from your credit union account to supported vendors.
- **Secure Login**: Multi-factor authentication (MFA) for secure access to your account.
- **Account Statements**: Download and view monthly account statements.

## Technologies

- **Frontend**: Flutter (Dart)
- **Backend**: NestJS (API services)
- **Database**: PostgreSQL / MySQL (depending on implementation)
- **Authentication**: JWT with OAuth 2.0
- **Push Notifications**: Firebase Cloud Messaging (FCM)
- **State Management**: Provider or Riverpod
- **Dependency Injection**: GetIt (for service management)

## Setup Instructions

### Prerequisites

- Install **Flutter SDK** (version >= 3.x):
  - Follow the Flutter installation guide: [Flutter Installation](https://flutter.dev/docs/get-started/install)
- Install **Android Studio** or **Xcode** (for iOS) for building the app on respective platforms.
- Make sure **Dart** is properly installed and configured.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/credit-union-mobile-app.git
   cd credit-union-mobile-app
   ```

## Getting Started

## Splash Screen Generate

```
dart run flutter_native_splash:create --path=./splash/flutter_native_splash-acceptance.yaml
dart run flutter_native_splash:remove
dart run flutter_native_splash:remove --path=./splash/flutter_native_splash-acceptance.yaml
```

## Generate Launcher Icon

```
flutter pub run flutter_launcher_icons:main
```

## Build Variants (Optional)

```
flutter clean
flutter pub get
flutter build appbundle
```

6. Build signed APK

For direct installation or testing:

flutter build apk --release

Output:

build/app/outputs/flutter-apk/app-release.apk

For smaller APKs per architecture:

flutter build apk --split-per-abi

You will get:

app-armeabi-v7a-release.apk
app-arm64-v8a-release.apk
app-x86_64-release.apk

```
- flutter build apk
- flutter build apk --release
- flutter build apk --debug
- flutter build apk --profile
```

## APK Location

build/app/outputs/flutter-apk/app-release.apk # For release build
build/app/outputs/flutter-apk/app-debug.apk # For debug build

## Generate android folder

```
- rm -rf android
- flutter create .

```

## Started with Flutter

May 29, 2025

Let’s get your Flutter app signed and ready to ship with a production-grade APK, Newton! 🚀

This is a must-do when you're ready to upload to the Play Store or distribute outside the dev/debug world.

✅ Step-by-Step: Create a Signed APK in Flutter
🔐 1. Generate a Keystore File (if you don't have one)
Open your terminal and run:

bash
Copy
Edit
keytool -genkey -v -keystore ~/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias
📌 This will ask for:

Passwords

Your name, org, etc.

💡 This command requires Java JDK installed and available in your PATH.

📁 2. Move the Keystore into Your Project
Place your keystore file in a secure location inside your Flutter project (e.g., /android/app/my-release-key.jks).

📝 3. Configure key.properties
Create this file in:
<your_flutter_project>/android/key.properties

properties
Copy
Edit
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=my-key-alias
storeFile=./app/my-release-key.jks
🔒 Keep this file out of version control (add it to .gitignore)

🔧 4. Update android/app/build.gradle
Open android/app/build.gradle, find android { ... }, and add signing config like this:

gradle
Copy
Edit
android {
...
signingConfigs {
release {
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled false
            shrinkResources false
            proguardFiles getDefaultProguardFile(
                'proguard-android-optimize.txt'),
                'proguard-rules.pro'
        }
    }

}
🧱 5. Build the APK
In your terminal, run:

bash
Copy
Edit
flutter build apk --release
You’ll find your signed APK here:

swift
Copy
Edit
build/app/outputs/flutter-apk/app-release.apk
📦 Optional: Build App Bundle for Play Store
bash
Copy
Edit
flutter build appbundle --release
This generates .aab, which is preferred by Google Play.

🔐 Final Notes
Keep your keystore file and credentials safe and backed up.

Don’t check key.properties or .jks files into Git.

Use --split-per-abi if you want smaller APKs per device architecture:

bash
Copy
Edit
flutter build apk --release --split-per-abi
Need help automating this with CI/CD (e.g., GitHub Actions or Bitrise)? Or want a full Play Store release checklist? Just say the word. You're so close to global domination 😎📱💼
