// backend/src/services/aiService.js
require("dotenv").config();
const { GoogleGenerativeAI } = require("@google/generative-ai");

// Pastikan API Key ada
if (!process.env.GEMINI_API_KEY) {
  throw new Error("GEMINI_API_KEY tidak ditemukan di file .env");
}

// Inisialisasi Client Google Generative AI
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

// --- Konfigurasi System Prompt (Persona Sana) ---
const systemPromptSana = `
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

// --- Fungsi untuk Chat ---
const getAIChatResponse = async (userMessage) => {
  try {
    // Menggunakan model gemini-2.5-flash sesuai permintaan
    const model = genAI.getGenerativeModel({
      model: "gemini-2.5-flash",
      systemInstruction: systemPromptSana, // System prompt masuk di sini
    });

    // Kirim pesan
    const result = await model.generateContent(userMessage);
    const response = await result.response;
    let aiReply = response.text();

    // Bersihkan format newline berlebih jika perlu
    aiReply = aiReply.replace(/\n/g, " ");

    return aiReply;
  } catch (error) {
    console.error("Error dari Google Generative AI:", error);
    throw new Error("Gagal mendapatkan balasan dari AI");
  }
};

// --- Fungsi untuk Summary ---
const getAISummary = async (history) => {
  try {
    // Untuk summary, kita panggil model tanpa systemInstruction khusus Sana
    const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

    const fullText = history.join("\n");
    const prompt = `Ringkaslah percakapan berikut menjadi poin-poin utama yang mudah dipahami oleh seorang psikolog. Fokus pada keluhan utama, perasaan yang diekspresikan, dan potensi pemicu masalah. Pertimbangkan juga content jurnal yang telah diisi pengguna untuk mengetahui informasi tambahan untuk konteks lebih dalam, karakter pengguna, progress pemulihan mental pengguna, dan keseharian pengguna. Gunakan bahasa Indonesia yang formal dan terstruktur:\n\n---\n\n${fullText}`;

    const result = await model.generateContent(prompt);
    const response = await result.response;

    return response.text();
  } catch (error) {
    console.error("Error saat membuat summary dengan AI:", error);
    throw new Error("Gagal membuat ringkasan dari AI");
  }
};

module.exports = {
  getAIChatResponse,
  getAISummary,
};
