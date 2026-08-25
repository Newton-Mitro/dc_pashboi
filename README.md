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

## Generate android folder

```
- rm -rf android
- flutter create .

```
