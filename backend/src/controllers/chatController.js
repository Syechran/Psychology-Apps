// backend/src/controllers/chatController.js

const aiService = require("../services/aiService");
const PDFDocument = require("pdfkit");
const db = require("../config/firebase"); // Pastikan path ini benar

// --- KONFIGURASI SEMENTARA ---
const HARDCODED_USER_ID = "Orang Baik";

// --- 1. Handle Chat (Logic Utama) ---
const handleChat = async (req, res) => {
  try {
    // sessionId dikirim dari Flutter. Jika null, berarti buat sesi baru.
    const { message, sessionId } = req.body;

    if (!message) {
      return res.status(400).json({ error: "Pesan tidak boleh kosong" });
    }

    let currentSessionId = sessionId;
    let sessionRef;
    let sessionTitle = "";

    // --- LOGIKA: SESI BARU VS SESI LAMA ---
    if (!currentSessionId) {
      // A. CHAT BARU (Buat Room Baru)

      // Judul otomatis dari 30 huruf pertama
      sessionTitle = message.length > 30 ? message.substring(0, 30) + "..." : message;
      let preview = message.length > 50 ? message.substring(0, 50) + "..." : message;

      // Simpan Sesi ke Firestore
      const newSession = await db.collection("chat_sessions").add({
        userId: HARDCODED_USER_ID,
        title: sessionTitle,
        preview: preview,
        createdAt: new Date(),
        updatedAt: new Date(),
      });

      currentSessionId = newSession.id;
      sessionRef = newSession;

    } else {
      // B. LANJUT CHAT (Pakai Room Lama)
      sessionRef = db.collection("chat_sessions").doc(currentSessionId);

      // Update waktu agar naik ke paling atas list
      await sessionRef.update({
        updatedAt: new Date(),
        preview: message.length > 50 ? message.substring(0, 50) + "..." : message
      });
    }

    // --- SIMPAN PESAN & DAPATKAN BALASAN AI ---

    // 1. Simpan pesan User
    await sessionRef.collection("messages").add({
      role: "user",
      content: message,
      createdAt: new Date(),
    });

    // 2. Panggil AI
    const aiReply = await aiService.getAIChatResponse(message);

    // 3. Simpan balasan AI
    await sessionRef.collection("messages").add({
      role: "model",
      content: aiReply,
      createdAt: new Date(),
    });

    // 4. Return response
    res.json({
      reply: aiReply,
      sessionId: currentSessionId,
      title: !sessionId ? sessionTitle : undefined
    });

  } catch (error) {
    console.error("Error di chat controller:", error);
    res.status(500).json({ error: "Terjadi kesalahan pada server" });
  }
};

// --- 2. Get Chat History List (Untuk Halaman List) ---
const getChatHistory = async (req, res) => {
  try {
    const snapshot = await db.collection("chat_sessions")
      .where("userId", "==", HARDCODED_USER_ID)
      .orderBy("updatedAt", "desc")
      .get();
      // Jangan lupa dihapus
//    console.log("History Chat:", snapshot);

    const history = [];
    snapshot.forEach((doc) => {
      const data = doc.data();
      history.push({
        id: doc.id,
        title: data.title,
        preview: data.preview,
        updatedAt: data.updatedAt.toDate()
      });
    });

    res.json(history);
  } catch (error) {
    console.error("Error ambil history:", error);
    res.status(500).json({ error: "Gagal mengambil riwayat chat" });
  }
};

// --- 3. Get Specific Session Messages (Saat Card diklik) ---
const getSessionMessages = async (req, res) => {
  try {
    const { sessionId } = req.params;

    const snapshot = await db.collection("chat_sessions")
      .doc(sessionId)
      .collection("messages")
      .orderBy("createdAt", "asc")
      .get();

    const messages = [];
    snapshot.forEach((doc) => {
      messages.push({ id: doc.id, ...doc.data() });
    });

    res.json(messages);
  } catch (error) {
    console.error("Error ambil pesan:", error);
    res.status(500).json({ error: "Gagal mengambil pesan" });
  }
};

// --- 4. Handle Summary (Tetap sama) ---
const handleSummary = async (req, res) => {
  try {
    const chatHistory = req.body.history || [];

    const journalsRef = db.collection("journals");
    const snapshot = await journalsRef.orderBy("created_at", "desc").get();

    const journalEntries = [];
    snapshot.forEach((doc) => {
      const data = doc.data();
      journalEntries.push(`--- JOURNAL ENTRY ---\nTitle: ${data.title}\nContent: ${data.content}\n--- END JOURNAL ENTRY ---`);
    });

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
    res.setHeader('Content-Disposition', 'attachment; filename="ringkasan_curhat.pdf"');
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

module.exports = {
  handleChat,
  getChatHistory,
  getSessionMessages,
  handleSummary,
};
