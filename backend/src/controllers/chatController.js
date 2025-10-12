// backend/src/controllers/chatController.js

// 1. Panggil service yang sudah kita buat
const aiService = require("../services/aiService");

// 2. Buat fungsi untuk menangani permintaan chat
const handleChat = async (req, res) => {
  try {
    // Ambil pesan dari body permintaan yang dikirim oleh frontend
    const userMessage = req.body.message;

    // Lakukan validasi sederhana, pastikan pesan tidak kosong
    if (!userMessage) {
      // Jika kosong, kirim error 'Bad Request'
      return res.status(400).json({ error: "Pesan tidak boleh kosong" });
    }

    // Suruh aiService untuk mendapatkan balasan dari AI
    const aiReply = await aiService.getAIChatResponse(userMessage);

    // Jika berhasil, kirim balasan dari AI kembali ke frontend
    res.json({ reply: aiReply });
  } catch (error) {
    // Jika terjadi error di mana pun, log errornya di konsol server
    console.error("Error di chat controller:", error);
    // Dan kirim pesan error umum ke frontend
    res.status(500).json({ error: "Terjadi kesalahan pada server" });
  }
};

// 3. Ekspor fungsi agar bisa digunakan di file lain
module.exports = {
  handleChat,
};
