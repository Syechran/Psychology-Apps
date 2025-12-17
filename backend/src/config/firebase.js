const admin = require('firebase-admin');
require('dotenv').config();

// Cek dulu apakah Private Key ada. Jika tidak, jangan paksa init.
if (!process.env.FIREBASE_PRIVATE_KEY) {
  console.warn("⚠️ PERINGATAN: FIREBASE_PRIVATE_KEY tidak ditemukan di .env. Fitur database tidak akan jalan.");
} else {
  try {
    const serviceAccount = {
      type: process.env.FIREBASE_TYPE,
      project_id: process.env.FIREBASE_PROJECT_ID,
      private_key_id: process.env.FIREBASE_PRIVATE_KEY_ID,
      // Pastikan replace hanya jalan jika key-nya ada
      private_key: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
      client_email: process.env.FIREBASE_CLIENT_EMAIL,
      client_id: process.env.FIREBASE_CLIENT_ID,
      auth_uri: process.env.FIREBASE_AUTH_URI,
      token_uri: process.env.FIREBASE_TOKEN_URI,
      auth_provider_x509_cert_url: process.env.FIREBASE_AUTH_PROVIDER_X509_CERT_URL,
      client_x509_cert_url: process.env.FIREBASE_CLIENT_X509_CERT_URL,
      universe_domain: process.env.FIREBASE_UNIVERSE_DOMAIN,
    };

    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
    
    console.log("🔥 Firebase berhasil terhubung!");
  } catch (error) {
    console.error("❌ Error inisialisasi Firebase:", error.message);
  }
}

const db = admin.firestore(); // Ini akan tetap jalan walau init gagal (tapi request db nanti error)

module.exports = db;