# Smart Glasses AI — Sistem Personalisasi Kacamata Berbasis AI

Aplikasi mobile Android berbasis Flutter untuk membantu pengguna memilih kacamata yang sesuai dengan bentuk wajah dan gaya hidup mereka menggunakan teknologi Computer Vision dan Machine Learning.

## Fitur Utama

- **Face Scan** — Deteksi dan klasifikasi bentuk wajah (Heart, Oblong, Oval, Round, Square) menggunakan model MobileNetV2 + TFLite
- **Rekomendasi Frame** — Top-3 rekomendasi frame kacamata berbasis rule-based system
- **Rekomendasi Lensa** — Top-2 rekomendasi jenis lensa berdasarkan gaya hidup pengguna
- **Virtual Try-On** — Fitur AR real-time untuk mencoba kacamata secara virtual menggunakan Google ML Kit Face Detection

## Tech Stack

- **Framework:** Flutter (Dart)
- **ML Model:** MobileNetV2 + Transfer Learning, diekspor ke TFLite
- **Face Detection:** Google ML Kit Face Detection
- **State Management:** Provider
- **Navigation:** GoRouter

## Struktur Proyek
lib/
├── ai/services/          # TFLite & recommendation service
├── core/                 # Theme, constants, utils
├── features/             # Splash, home, face_scan, lifestyle,
│                         # lifestyle_recommendation, recommendation, try_on
├── models/               # Data models
└── routes/               # GoRouter config

## Cara Menjalankan

```bash
# Install dependencies
flutter pub get

# Jalankan di device/emulator
flutter run

# Build APK
flutter build apk --release
```

## Requirements

- Flutter SDK >= 3.0.0
- Android SDK >= API 29 (Android 10)
- Kamera depan (untuk Face Scan & Virtual Try-On)

## Tim Pengembang

Capstone Project Kelompok 1 — Program Studi Informatika, Universitas Andalas

1. Ezza Addini
2. Siti Fadhilah Rahmi
3. Muhammad Hafiz