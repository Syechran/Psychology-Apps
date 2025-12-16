// backend/src/api/chat.js

const express = require("express");
const chatController = require("../controllers/chatController");
const router = express.Router();

// 1. Kirim Chat (Bisa chat baru atau balasan)
router.post("/chat", chatController.handleChat);

// 2. Ambil List History (Daftar semua sesi curhat)
router.get("/history", chatController.getChatHistory);

// 3. Ambil Detail Pesan (Isi chat dalam satu sesi)
router.get("/session/:sessionId", chatController.getSessionMessages);

// 4. Minta Summary PDF
router.post("/summary", chatController.handleSummary);

module.exports = router;
