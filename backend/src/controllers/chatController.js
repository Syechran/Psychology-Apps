// backend/src/controllers/chatController.js

const aiService = require("../services/aiService");
const PDFDocument = require("pdfkit");

// --- Fungsi untuk Handle Chat (Tetap sama, tidak berubah) ---
const handleChat = async (req, res) => {
  try {
    const userMessage = req.body.message;
    if (!userMessage) {
      return res.status(400).json({ error: "Pesan tidak boleh kosong" });
    }
    const aiReply = await aiService.getAIChatResponse(userMessage);
    res.json({ reply: aiReply });
  } catch (error) {
    console.error("Error di chat controller:", error);
    res.status(500).json({ error: "Terjadi kesalahan pada server" });
  }
};

// --- Fungsi untuk Handle Summary (KEMBALIKAN KE VERSI ASLI) ---
const handleSummary = async (req, res) => {
  try {
    // 1. AKTIFKAN KEMBALI pengambilan data dari body permintaan
    const chatHistory = req.body.history;

    // 2. HAPUS data history yang di-hardcode (sudah tidak diperlukan lagi)

    // 3. AKTIFKAN KEMBALI validasi untuk data yang datang dari frontend
    if (!chatHistory || chatHistory.length === 0) {
      return res.status(400).json({ error: "Riwayat chat tidak boleh kosong" });
    }

    // Sisa kode di bawah ini tetap sama persis
    const summaryText = await aiService.getAISummary(chatHistory);

    const doc = new PDFDocument();
    res.setHeader("Content-Type", "application/pdf");
    res.setHeader(
      "Content-Disposition",
      'attachment; filename="ringkasan_curhat.pdf"'
    );
    doc.pipe(res);
    doc.fontSize(20).text("Ringkasan Konsultasi", { align: "center" });
    doc.moveDown();
    doc.fontSize(12).text(summaryText);
    doc.end();
  } catch (error) {
    console.error("Error di summary controller:", error);
    res.status(500).json({ error: "Gagal membuat ringkasan" });
  }
};

// Ekspor KEDUA fungsi
module.exports = {
  handleChat,
  handleSummary,
};
