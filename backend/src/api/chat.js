// backend/src/api/chat.js

const express = require("express");
const chatController = require("../controllers/chatController");
const router = express.Router();

// Alamat untuk mengirim chat biasa
router.post("/chat", chatController.handleChat);

// Alamat untuk meminta summary (KEMBALIKAN KE POST)
router.post("/summary", chatController.handleSummary);

module.exports = router;
