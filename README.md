<div align="center">

# 🕶️ Smart Glasses AI

### Sistem Personalisasi Kacamata Berbasis AI

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-API%2029+-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![TFLite](https://img.shields.io/badge/TFLite-MobileNetV2-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white)
![ML Kit](https://img.shields.io/badge/ML%20Kit-Face%20Detection-4285F4?style=for-the-badge&logo=google&logoColor=white)

Aplikasi mobile Android berbasis Flutter untuk membantu pengguna memilih kacamata yang sesuai dengan bentuk wajah dan gaya hidup menggunakan teknologi Computer Vision dan Machine Learning.

</div>

---

## ✨ Fitur Utama

| Fitur | Deskripsi |
|---|---|
| 🔍 **Face Scan** | Deteksi & klasifikasi bentuk wajah (Heart, Oblong, Oval, Round, Square) via MobileNetV2 + TFLite |
| 🕶️ **Rekomendasi Frame** | Top-3 rekomendasi frame kacamata berbasis rule-based system |
| 👁️ **Rekomendasi Lensa** | Top-2 rekomendasi lensa berdasarkan gaya hidup pengguna |
| 🪞 **Virtual Try-On** | AR real-time untuk mencoba kacamata secara virtual via Google ML Kit |

---

## 🛠️ Tech Stack

| Kategori | Teknologi |
|---|---|
| Framework | Flutter (Dart) |
| ML Model | MobileNetV2 + Transfer Learning → TFLite |
| Face Detection | Google ML Kit Face Detection |
| State Management | Provider |
| Navigation | GoRouter |
| Font | Google Fonts |
| Splash Screen | flutter_native_splash |

---

## ⚙️ Requirements

Sebelum menjalankan proyek, pastikan sudah terinstall:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) >= 3.0.0
- [Android Studio](https://developer.android.com/studio) / VS Code
- Android SDK >= API 29 (Android 10)
- Device / emulator dengan kamera depan
- USB Debugging aktif (untuk run di device fisik)

---

## 🚀 Cara Menjalankan

### 1. Clone repository

```bash
git clone https://github.com/username/smart_glasses_ai.git
cd smart_glasses_ai
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Generate splash screen & launcher icon

```bash
dart run flutter_native_splash:create
dart run flutter_launcher_icons
```

### 4. Jalankan di device / emulator

```bash
# Mode debug
flutter run

# Mode profile (untuk analisis performa)
flutter run --profile
```

### 5. Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK (ukuran lebih kecil)
flutter build apk --release

# Split per ABI (ukuran optimal)
flutter build apk --split-per-abi --release
```

APK tersimpan di `build/app/outputs/flutter-apk/`.

---

## 📊 Analisis Kode

```bash
# Analisis linting
flutter analyze

# Cyclomatic complexity & code metrics
dart run dart_code_metrics:metrics analyze lib

# HTML report
dart run dart_code_metrics:metrics analyze lib --reporter=html
```

Report HTML tersimpan di folder `metrics/index.html`.

```bash
# run html report
start metrics/index.html
```

---

## 👥 Tim Pengembang

Capstone Project **Kelompok 1**
Program Studi Informatika — Universitas Andalas

| No | Nama |
|---|---|
| 1 | Ezza Addini |
| 2 | Siti Fadhilah Rahmi |
| 3 | Muhammad Hafiz |

---

<div align="center">
  <sub>© 2026 Smart Glasses AI — Universitas Andalas</sub>
</div>