// backend/src/api/chat.js

const express = require("express");
const chatController = require("../controllers/chatController");
const router = express.Router();

// 1. Kirim Chat
// URL: /api/chat
router.post("/chat", chatController.handleChat);

// 2. Ambil List History (PERBAIKAN DI SINI)
// URL Jadi: /api/chat/history (Sesuai dengan Flutter)
router.get("/chat/history", chatController.getChatHistory);

// 3. Ambil Detail Pesan (PERBAIKAN DI SINI)
// URL Jadi: /api/chat/session/:sessionId
router.get("/chat/session/:sessionId", chatController.getSessionMessages);

// 4. Update Title (Ganti Nama Sesi)
router.put("/chat/session/:sessionId/title", chatController.updateSessionTitle);

// 5. Delete Session
router.delete("/chat/session/:sessionId", chatController.deleteSession);

// 6. Minta Summary PDF
// URL: /api/summary (Ini biarkan saja atau mau disamakan jadi /api/chat/summary juga boleh)
router.post("/summary", chatController.handleSummary);

module.exports = router;