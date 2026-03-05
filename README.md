# Al-Quran Digital 📖✨

Al-Quran Digital is a comprehensive, feature-rich, and professionally designed Islamic application built with Flutter. It provides an intuitive, elegant, and modern user experience with all essential features ranging from reading the Quran with Tajwid rules to tracking daily Sholat times, Dzikir, and more.

## 🌟 Key Features

### 📖 1. The Holy Quran

- **Full 114 Surahs and 30 Juz**: Navigate easily using a robust search and bookmarking capability.
- **Tajwid Berwarna (Color-coded Tajweed)**: Clear visualization and explanation of multiple Tajweed rules for accurate recitation.
- **Word-by-word Translation**: Expandable word-by-word breakdown for each Ayah to understand its linguistic roots.
- **Transliteration & Translation**: Seamlessly toggle reading modes with Indonesian/Kemenag standard translations.
- **Dual Rasm Standards**: Choose intuitively between **IndoPak** and **Utsmani** standard scripts.
- **Murattal Audio Player**: Mini player & persistent control bar, multiple Qari options, gapless playback per Ayah or full Surah, and repeat capabilities.

### 🕒 2. Sholat Times & Qibla

- **Precise Prayer Times**: Accurate algorithms using device GPS location.
- **Hijri Calendar Integration**: Conversion from Gregorian to Hijri dates with user-adjustable offsets (-2 to +2 days).
- **Qibla Compass**: A smooth, real-time animated Qibla compass pointer pointing directly to the Kaaba.
- **Notifikasi Adzan & Pre-Adzan**: Reminder notifications per prayer time customizable directly from settings.

### 📿 3. Daily Worship Tools

- **Hadits Harian & Arbain**: Curated selection of Hadith with translation.
- **Doa Harian**: Comprehensive collection of daily prayers (Doa).
- **Dzikir Pagi & Petang**: Guided morning and evening supplications.
- **Smart Tasbih**: A digital counter complete with haptic feedback limits.

### ☁️ 4. Cloud Sync & Profile

- **Firebase Integration**: Secure Google Sign-In and Cloud Firestore.
- **Cross-Device Sync**: Bookmarks and last-read positions are saved dynamically to the cloud.
- **Hafalan Tracker**: Progress tracking for verses memorized by the user.

## 🛠 Tech Stack & Architecture

- **Framework**: Flutter ^3.24.0
- **State Management**: Riverpod (`flutter_riverpod`, `riverpod_annotation`)
- **Routing**: declarative routing via `go_router`
- **Local Storage**: `shared_preferences`
- **Audio Engine**: `just_audio`
- **Backend**: Firebase (Auth, Firestore)
- **Optimization**: Enabled ProGuard and Resource Shrinking for the Android release target and migrated to Adaptive Launcher Icons.

## 🚀 Getting Started

1. Clone the repository:
   ```bash
   git clone <repository_url>
   ```
2. Navigate to the project directory:
   ```bash
   cd Al-Quran-Indonesia-Lengkap
   ```
3. Fetch dependencies:
   ```bash
   flutter pub get
   ```
4. Code generation (for Riverpod):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
5. Run the app:
   ```bash
   flutter run
   ```

## 📄 License

This application is purely open-source designed to facilitate Islamic learning and daily worship. Feel free to contribute or utilize portions of the codebase to scale meaningful endeavors.
