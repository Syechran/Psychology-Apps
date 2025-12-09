// backend/src/controllers/chatController.js

const aiService = require("../services/aiService");
const PDFDocument = require("pdfkit");
const db = require("./config/firebase");

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
    const chatHistory = req.body.history || []; // Ensure chatHistory is an array

    // Fetch all journals
    const journalsRef = db.collection("journals");
    const snapshot = await journalsRef.orderBy("created_at", "desc").get();
    const journalEntries = [];
    snapshot.forEach((doc) => {
      const data = doc.data();
      journalEntries.push(`--- JOURNAL ENTRY ---\nTitle: ${data.title}\nContent: ${data.content}\n--- END JOURNAL ENTRY ---`);
    });

    // Combine chat history and journal entries
    const combinedHistory = [
      "--- START CHAT HISTORY ---",
      ...chatHistory,
      "--- END CHAT HISTORY ---",
      "--- START JOURNAL ENTRIES ---",
      ...journalEntries,
      "--- END JOURNAL ENTRIES ---",
    ];

    if (combinedHistory.length === 0) {
      return res.status(400).json({ error: "Riwayat chat dan jurnal tidak boleh kosong" });
    }

    const summaryText = await aiService.getAISummary(combinedHistory);

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
