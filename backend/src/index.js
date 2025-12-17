// backend/src/index.js

const express = require("express");
const cors = require("cors");
// 1. Panggil file rute yang sudah kita buat
const chatRoutes = require("./api/chat");
const journalRoutes = require("./api/journal");

const app = express();
// Gunakan port dari environment variable jika ada, atau 3000 jika tidak ada
const port = process.env.PORT || 3000;

// Konfigurasi CORS yang lebih permissif untuk development
// Konfigurasi CORS yang lebih permissif untuk development
app.use(cors({
  origin: "*", // Izinkan semua origin
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"]
}));

app.use(express.json()); 

// Middleware Logging
app.use((req, res, next) => {
  console.log(`[REQUEST] ${req.method} ${req.url}`);
  next();
});

// Route Cek Server (Untuk memastikan server hidup di browser)
app.get("/", (req, res) => {
  res.send("Server Backend Berjalan! Silakan akses /api/chat");
});

// 2. Gunakan rutenya
// Beritahu Express: "Untuk setiap permintaan yang alamatnya diawali dengan '/api',
// tolong gunakan aturan yang ada di dalam 'chatRoutes'."
app.use("/api", chatRoutes);
app.use("/api", journalRoutes);

app.listen(port, () => {
  console.log(`Server backend berjalan di http://localhost:${port}`);
});
