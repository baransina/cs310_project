# CampusConnect

Student Task & Study Event Manager  
CS310 Mobile Application Development — Group 10  
Project Step 2.2 — Flutter UI Implementation

## Team

| Member | Student ID |
| --- | --- |
| Ömer Baran Sına | 35301 |
| Emir Kerem Subaşı | 34422 |
| Tolgahan Ercan | 34465 |
| Ahmet Efe Aydoğdu | 34119 |

## Overview

CampusConnect helps university students track academic tasks and discover
campus study sessions.

This submission implements the Flutter interface with placeholder data.
Authentication screens demonstrate input validation and navigation.
Firebase Authentication and Cloud Firestore integration are planned for Step 3.
Current application data is held in memory.

## Screens

- Login and sign-up
- Profile setup and notification level selection
- Home dashboard
- Task list with course filtering and task removal
- Study event list, creation and details
- Friends
- Profile display and name/major editing

## Run Instructions

Install Flutter and configure an Android emulator or iOS simulator.

Clone the repository and install dependencies:

```bash
git clone https://github.com/baransina/cs310_project.git
cd cs310_project
flutter pub get
```

On macOS, launch the iOS Simulator:

```bash
open -a Simulator
```

List available devices and start the application:

```bash
flutter devices
flutter run
```

If multiple devices are available, select the desired device or run:

```bash
flutter run -d DEVICE_ID
```

Replace DEVICE_ID with the identifier shown by flutter devices.
The default entry point is lib/main.dart.

## Images and Fonts

- Local profile image: assets/images/profile_avatar.png
- Network avatar: loaded by the Home screen
- Custom font: Inter Regular and Bold

An internet connection is required for network images.

## Current Limitations

- Authentication and persistent storage will be integrated in Step 3.
- Notification level selection currently stores a preference.
- Task creation and task-detail navigation are pending in this snapshot.
- The Home dashboard uses sample task and session data.

## Flutter Version

Flutter 3.50.0
Tools • Dart 3.14.0 • DevTools 2.61.0