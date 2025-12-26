// backend/src/index.js

const express = require("express");
const cors = require("cors");
// 1. Panggil file rute yang sudah kita buat
const chatRoutes = require("./api/chat");
const journalRoutes = require("./api/journal");

const app = express();
// Gunakan port dari environment variable jika ada, atau 3000 jika tidak ada
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json()); // Middleware untuk membaca body JSON

// 2. Gunakan rutenya
// Beritahu Express: "Untuk setiap permintaan yang alamatnya diawali dengan '/api',
// tolong gunakan aturan yang ada di dalam 'chatRoutes'."
app.use("/api", chatRoutes);
app.use("/api", journalRoutes);

app.listen(port, () => {
  console.log(`Server backend berjalan di http://localhost:${port}`);
});
