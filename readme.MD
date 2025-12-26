# Flanella

<div align="center">
  
  **Sahabat Psikologi AI & Aplikasi Jurnal Pribadi Anda**

  <br>

  ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
  ![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)
  ![Express.js](https://img.shields.io/badge/express.js-%23404d59.svg?style=for-the-badge&logo=express&logoColor=%2361DAFB)
  ![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
  ![Google Gemini](https://img.shields.io/badge/Google%20Gemini-8E75B2?style=for-the-badge&logo=google%20bard&logoColor=white)

</div>

---

## 📖 Tentang Flanella

**Flanella** adalah aplikasi seluler komprehensif yang dirancang untuk mendukung kesehatan mental pengguna. Aplikasi ini menggabungkan kecerdasan buatan (AI) dengan fitur jurnal digital untuk menyediakan ruang aman bagi pengguna dalam mengekspresikan pikiran, mendapatkan dukungan psikologis berbasis AI, dan melacak perjalanan emosional mereka.

Ditenagai oleh **Google Gemini 2.5 Flash**, Flanella menawarkan percakapan cerdas yang responsif, fitur perangkuman obrolan otomatis menjadi dokumen PDF, serta pengelolaan jurnal yang intuitif.

## ✨ Fitur Utama

### 🤖 Pendamping Obrolan AI
- **Percakapan Cerdas**: Berinteraksi dengan AI yang empatik dan responsif menggunakan model Gemini 2.5 Flash dari Google.
- **Pemahaman Konteks**: AI mampu memahami konteks percakapan sebelumnya untuk interaksi yang lebih relevan dan bermakna.
- **Penamaan Sesi Otomatis**: Judul sesi obrolan dibuat secara otomatis berdasarkan topik pembicaraan utama.

### 📝 Sistem Jurnal Digital
- **Jurnal Harian**: Fitur untuk menulis dan menyimpan catatan harian mengenai pikiran dan perasaan pengguna.
- **Manajemen Data (CRUD)**: Kemudahan dalam Membuat, Membaca, Memperbarui, dan Menghapus entri jurnal.
- **Antarmuka Intuitif**: Desain antarmuka yang bersih dan nyaman untuk pengalaman menulis yang lebih baik.

### 📄 Perangkuman Cerdas (Smart Summarization)
- **Ekspor ke PDF**: Merangkum sesi percakapan dengan AI secara otomatis dan mengunduhnya dalam format PDF langsung ke perangkat pengguna.
- **Integrasi PDFKit**: Pembuatan dokumen PDF berkualitas tinggi yang diproses di sisi backend.

### 🏥 Rekomendasi Konsultasi Profesional
- **Akses Cepat**: Tautan langsung ke platform konsultasi kesehatan mental profesional terkemuka:
  - **Halodoc**
  - **Kalm**
  - **Alodokter**

## 🛠 Teknologi yang Digunakan

### Frontend (Aplikasi Seluler)
- **Framework**: [Flutter](https://flutter.dev/)
- **Bahasa Pemrograman**: [Dart](https://dart.dev/)
- **Pustaka & Paket Utama**:
  - `http`: Menangani permintaan HTTP dan komunikasi dengan API backend.
  - `path_provider`: Menyediakan akses ke lokasi penyimpanan file di sistem file perangkat (Android/iOS).
  - `url_launcher`: Memungkinkan aplikasi untuk membuka tautan eksternal (browser, email, telepon).
  - `curved_navigation_bar`: Komponen navigasi bar bawah dengan animasi yang menarik dan modern.
  - `intl`: Menyediakan fasilitas internasionalisasi dan lokalisasi, termasuk pemformatan tanggal dan angka.
  - `cupertino_icons`: Set ikon standar gaya iOS untuk konsistensi desain.

### Backend (API & Layanan)
- **Runtime**: [Node.js](https://nodejs.org/)
- **Framework**: [Express.js](https://expressjs.com/)
- **Database**: [Firebase Firestore](https://firebase.google.com/)
- **Pustaka & Dependensi Utama**:
  - `@google/generative-ai`: SDK resmi untuk mengintegrasikan model AI Google Gemini.
  - `firebase-admin`: SDK Admin Firebase untuk interaksi server-side dengan layanan Firebase (Firestore, Auth).
  - `pdfkit`: Pustaka untuk membuat dokumen PDF yang kompleks dan dapat diunduh secara dinamis.
  - `dotenv`: Memuat variabel lingkungan dari file `.env` untuk keamanan konfigurasi.
  - `cors`: Middleware untuk mengaktifkan Cross-Origin Resource Sharing pada server Express.
  - `axios`: Klien HTTP berbasis Promise untuk melakukan permintaan ke layanan eksternal jika diperlukan.

## 🚀 Cara Memulai

Ikuti langkah-langkah berikut untuk menjalankan proyek ini di lingkungan lokal Anda.

### Prasyarat
- Flutter SDK telah terinstal
- Node.js & npm telah terinstal
- Proyek Firebase telah disiapkan (Firestore & Auth)
- Kunci API Google AI Studio (Gemini API)

### 1. Instalasi Backend

Masuk ke direktori backend:
```bash
cd backend
```

Instal dependensi yang diperlukan:
```bash
npm install
```

Buat file `.env` di dalam folder `backend` dengan konfigurasi berikut:
```env
PORT=3000
GEMINI_API_KEY=kunci_api_gemini_anda
FIREBASE_PRIVATE_KEY="kunci_privat_firebase_anda"
# Tambahkan konfigurasi firebase lainnya jika diperlukan
```

Jalankan server:
```bash
node src/index.js
```

### 2. Instalasi Frontend

Masuk ke direktori aplikasi flutter:
```bash
cd flutter_app
```

Instal dependensi paket:
```bash
flutter pub get
```

Jalankan aplikasi (pastikan emulator atau perangkat fisik sudah terhubung):
```bash
flutter run
```

## 📂 Struktur Proyek

```
Psychology-Apps-main/
├── backend/                 # Server Node.js Express
│   ├── src/
│   │   ├── api/            # Rute API
│   │   ├── config/         # Konfigurasi Firebase & Aplikasi
│   │   ├── controllers/    # Pengendali Permintaan (Controllers)
│   │   ├── services/       # Logika Bisnis & Layanan AI
│   │   └── index.js        # Titik Masuk Aplikasi (Entry Point)
│   └── package.json
│
├── flutter_app/            # Aplikasi Seluler Flutter
│   ├── lib/
│   │   ├── widgets/        # Komponen UI yang Dapat Digunakan Kembali
│   │   ├── chat_page.dart  # Halaman Obrolan
│   │   ├── homepage.dart   # Halaman Utama
│   │   ├── journal-page.dart # Halaman Jurnal
│   │   └── main.dart       # Titik Masuk Aplikasi Flutter
│   └── pubspec.yaml
│
└── readme.MD               # Dokumentasi Proyek
```

