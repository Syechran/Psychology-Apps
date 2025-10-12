// backend/src/api/chat.js

const express = require("express");
// 1. Panggil controller yang sudah kita buat
const chatController = require("../controllers/chatController");

// 2. Buat instance router dari Express
const router = express.Router();

// 3. Definisikan alamatnya
// Saat ada permintaan HTTP POST ke alamat '/chat',
// jalankan fungsi 'handleChat' dari chatController.
router.post("/chat", chatController.handleChat);

// 4. Ekspor router agar bisa digunakan oleh server utama
module.exports = router;
