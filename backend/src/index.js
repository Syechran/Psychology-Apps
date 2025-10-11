// 1. Import library yang dibutuhkan
const express = require("express");
const cors = require("cors");
const axios = require("axios"); // Kita akan gunakan ini nanti

// 2. Inisialisasi aplikasi express
const app = express();
const port = 3000; // Pilih port, 3000 adalah standar

// 3. Gunakan middleware
app.use(cors()); // Mengizinkan akses dari frontend
app.use(express.json()); // Agar server bisa membaca data JSON yang dikirim frontend

// 4. Buat endpoint /chat (sesuai kontrak)
app.post("/chat", async (req, res) => {
  // Ambil pesan dari frontend
  const userMessage = req.body.message;
  console.log("Pesan diterima dari frontend:", userMessage);

  // --- LOGIKA INTEGRASI AI (z.ai) AKAN DITARUH DI SINI ---

  // Untuk sekarang, kita kirim balasan dummy dulu
  const aiReply = "Ini adalah balasan dummy dari server.";
  res.json({ reply: aiReply });
});

// 5. Buat endpoint /summary (sesuai kontrak)
app.post("/summary", async (req, res) => {
  // Ambil riwayat chat dari frontend
  const chatHistory = req.body.history;
  console.log("Riwayat chat diterima, jumlah pesan:", chatHistory.length);

  // --- LOGIKA INTEGRASI AI UNTUK SUMMARY AKAN DI SINI ---

  // Untuk sekarang, kita kirim summary dummy
  const aiSummary = "Ini adalah ringkasan dummy dari server.";
  res.json({ summary: aiSummary });
});

// 6. Jalankan server
app.listen(port, () => {
  console.log(`Server backend berjalan di http://localhost:${port}`);
});
