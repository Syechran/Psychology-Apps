// backend/src/services/aiService.js
require("dotenv").config();
const { GoogleGenerativeAI } = require("@google/generative-ai");

// Pastikan di .env namanya GEMINI_API_KEY
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

// Gunakan model yang stabil
const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

const getAIChatResponse = async (userMessage) => {
  try {
    const systemPrompt = `
          **[PERAN DAN TUJUAN]**
          Anda adalah "Sana", sebuah AI Companion yang dirancang sebagai ruang aman untuk refleksi diri. Tujuan utama Anda adalah menjadi pendengar yang empatik dan membantu pengguna memahami perasaan mereka sendiri dengan lebih baik. Anda BUKAN terapis dan tidak boleh memberikan nasihat medis.

          **[KEPRIBADIAN]**
          Kepribadian Anda hangat, sabar, dan tidak menghakimi. Gunakan gaya bahasa yang santai dan natural seperti teman dekat yang bijaksana. Selalu panggil pengguna dengan sapaan akrab jika nama mereka disebutkan, atau gunakan "kamu".

          **[STRUKTUR RESPONS]**
          Setiap balasan Anda harus mengikuti struktur 3 langkah ini:
          1.  **Validasi:** Mulailah dengan mengakui dan memvalidasi perasaan atau situasi yang dibagikan pengguna. Tunjukkan bahwa Anda mengerti. (Contoh: "Kedengarannya situasi itu membuatmu sangat tertekan," atau "Terima kasih sudah berbagi, itu pasti tidak mudah.").
          2.  **Refleksi/Perspektif:** Berikan satu kalimat reflektif yang singkat atau perspektif yang menenangkan, tanpa memberikan nasihat. (Contoh: "Tidak apa-apa untuk merasa kewalahan," atau "Penting untuk diingat bahwa perasaanmu itu valid.").
          3.  **Ajakan (Invitation):** Akhiri dengan sebuah pertanyaan terbuka yang lembut dan tidak memaksa, yang mengundang pengguna untuk bercerita lebih dalam. (Contoh: "Apakah ada bagian tertentu dari perasaan itu yang paling mengganggumu?", "Bagaimana perasaanmu saat ini ketika menceritakannya?", atau "Jika kamu nyaman, boleh ceritakan lebih lanjut?").

          **[BATASAN]**
          -   Jangan pernah memberikan diagnosis atau nasihat medis.
          -   Jangan pernah menggunakan bahasa yang kasar, tidak senonoh, atau menghakimi.
          -   Selalu berkomunikasi dalam Bahasa Indonesia.
          `;

    // Mulai chat dengan history instruksi
    const chat = model.startChat({
      history: [
        {
          role: "user",
          parts: [{ text: systemPrompt }],
        },
        {
          role: "model",
          parts: [{ text: "Mengerti, saya Sana. Saya siap mendengarkan." }],
        },
      ],
    });

    const result = await chat.sendMessage(userMessage);
    const response = await result.response;
    let aiReply = response.text();

    // Bersihkan enter yang berlebihan
    aiReply = aiReply.replace(/\n/g, " ");

    return aiReply;
  } catch (error) {
    console.error("Error Google AI:", error);
    // Kembalikan string kosong atau error agar controller tahu
    throw new Error("Gagal koneksi ke AI");
  }
};

// Axios no longer needed
// const axios = require("axios"); 

const getAISummary = async (history) => {
  try {
    // Ensure history is an array of strings
    const historyArray = Array.isArray(history) ? history : [history];
    const fullText = historyArray.join("\n");
    const prompt = `Ringkaslah percakapan dan entri jurnal berikut menjadi poin-poin utama yang mudah dipahami oleh seorang psikolog.
    
    Data terdiri dari:
    1. "CHAT HISTORY": Percakapan langsung dengan pengguna.
    2. "JOURNAL ENTRIES": Catatan harian pengguna dalam 7 hari terakhir.
    
    Analisis kedua sumber data ini untuk mendapatkan gambaran kesehatan mental yang lebih utuh.
    Fokus pada:
    - Keluhan utama (dari Chat).
    - Pola perasaan atau mood harian (dari Jurnal).
    - Validasi apakah apa yang dicurhatkan di chat konsisten dengan tulisan di jurnal.
    - Potensi pemicu masalah.
    
    Gunakan bahasa Indonesia yang formal, empatik, dan terstruktur:\n\n---\n\n${fullText}`;

    // Gunakan model yang sudah diinisialisasi (gemini-2.5-flash)
    const result = await model.generateContent(prompt);
    const response = await result.response;
    return response.text();
  } catch (error) {
    console.error("Error Google AI Summary:", error);
    throw new Error("Gagal membuat ringkasan dari AI");
  }
};

module.exports = {
  getAIChatResponse,
  getAISummary,
};