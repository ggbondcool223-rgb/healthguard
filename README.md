# Health Guard App

A comprehensive health management Flutter application for tracking blood pressure, blood sugar, and heart rate.

## Features

- **Health Metrics Tracking**: Record and monitor blood pressure, blood sugar, and heart rate
- **Heart Rate Detection**: Real-time heart rate detection using camera
- **Health Analysis**: Visual charts and trends of health data
- **Health Knowledge**: Educational articles about chronic diseases and health tips
- **Healthy Recipes**: Curated recipes with health benefits
- **Personal Profile**: Manage personal health information and goals
- **Daily Check-in**: Track daily health habits

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── router/                             # Route management
│   ├── health_guard_names.dart         # Route constants
│   └── health_guard_index.dart         # Route configuration
├── db_health_guard/                    # Database layer
│   ├── data.dart                       # Database initialization
│   └── health_guard_entity.dart        # Data entities
└── pages/                              # All app pages
    ├── health_guard_tab/               # Main tab container
    ├── health_guard_home/              # Home page
    ├── health_guard_blood_sugar/       # Blood sugar recording
    ├── health_guard_blood_pressure/    # Blood pressure recording
    ├── health_guard_heart_rate/        # Heart rate manual recording
    ├── health_guard_heart_rate_detect/ # Heart rate detection
    ├── health_guard_health_analysis/   # Health data analysis
    ├── health_guard_history/           # History records
    ├── health_guard_knowledge/         # Health knowledge
    ├── health_guard_chronic_disease/   # Chronic disease articles
    ├── health_guard_recipe/            # Recipe list
    ├── health_guard_recipe_detail/     # Recipe details
    ├── health_guard_profile/           # User profile
    └── health_guard_personal_info/     # Personal information
```

## Tech Stack

- **Framework**: Flutter
- **State Management**: GetX
- **Database**: Sqflite
- **UI Adaptation**: flutter_screenutil
- **Charts**: fl_chart
- **Styling**: styled_widget

## Getting Started

### Prerequisites

- Flutter SDK (>=3.5.0)
- Dart SDK
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. Navigate to project directory:
```bash
cd health_guard
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Database Schema

### Tables

1. **user_info**: Personal information (age, height, weight, medical history)
2. **blood_sugar**: Blood sugar records
3. **blood_pressure**: Blood pressure records
4. **heart_rate**: Heart rate records
5. **check_in**: Daily check-in records
6. **articles**: Health knowledge articles
7. **recipes**: Healthy recipes

## Key Features Implementation

### Health Data Recording

- **Blood Sugar**: Picker-based input with health status evaluation
- **Blood Pressure**: Dual-column picker for systolic and diastolic values
- **Heart Rate**: Camera-based detection or manual input

### Data Visualization

- Line charts showing 7-day trends
- Color-coded health status indicators
- Statistics dashboard

### Local Data Persistence

- All health data stored locally using Sqflite
- Automatic data synchronization across pages
- Historical data accessible anytime

## Color Scheme

- **Primary Color**: #5FC970 (Green)
- **Background**: Linear gradient #7CC7FA → #FFFFFF
- **Blood Sugar**: #FF6B6B (Red)
- **Blood Pressure**: #4ECDC4 (Cyan)
- **Heart Rate**: #FF6B9D (Pink)

## Architecture

The app follows GetX MVC pattern:

- **View**: UI rendering (GetView)
- **Logic**: Business logic and state management (GetxController)
- **Binding**: Dependency injection (Bindings)

## Navigation

Bottom Tab Navigation with 4 tabs:
1. Home - Health metrics overview
2. Knowledge - Health education
3. Recipe - Healthy recipes
4. Profile - User settings

## Development Notes

- All user-facing text is in English
- No comments in code (as per project requirements)
- Responsive UI using ScreenUtil
- iOS-style design with Cupertino transitions

## License

Private project - All rights reserved

## Support

For issues or questions, contact the development team.
