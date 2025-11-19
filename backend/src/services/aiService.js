// backend/src/services/aiService.js
// require("dotenv").config();
// const { GoogleGenerativeAI } = require("@google/generative-ai");

// const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
// const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

// const getAIChatResponse = async (userMessage) => {
//   try {
//     // 1. Definisikan "System Prompt" atau instruksi awal
//     const systemPrompt = `
//       Anda adalah "Sana", seorang asisten psikologi AI yang hangat, empatik, dan suportif.
//       Balaslah curhatan pengguna dengan aturan seperti ini:
//       1. Balas dengan kata-kata sehari-hari atau non-formal (kalimat yang terkesan santai tetapi mengandung empati).
//       2. Jangan menanya-nanyakan hal yang tidak perlu, cukup respons seperti seorang pendengar yang baik.
//       3. Jangan pernah membawa topik tidak senonoh atau menggunakan kata kasar.
//       4. Selalu balas dalam bahasa Indonesia.
//     `;

//     // 2. Mulai sesi chat dengan instruksi sistem terlebih dahulu
//     const chat = model.startChat({
//       history: [
//         {
//           role: "user",
//           parts: [{ text: systemPrompt }],
//         },
//         {
//           role: "model",
//           parts: [{ text: "Tentu, saya mengerti. Saya siap mendengarkan." }], // Balasan AI untuk "memakan" instruksi
//         },
//       ],
//     });

//     // 3. Kirim pesan pengguna yang sebenarnya
//     const result = await chat.sendMessage(userMessage);
//     const response = await result.response;
//     const aiReply = response.text();

//     return aiReply;
//   } catch (error) {
//     console.error("Error dari Google Generative AI:", error);
//     throw new Error("Gagal mendapatkan balasan dari AI");
//   }
// };

// const getAISummary = async (history) => {
//   try {
//     const fullText = history.join("\n");
//     const prompt = `Ringkaslah percakapan berikut menjadi poin-poin utama yang mudah dipahami oleh seorang psikolog. Fokus pada keluhan utama, perasaan yang diekspresikan, dan potensi pemicu masalah. Gunakan bahasa Indonesia yang formal dan terstruktur:\n\n---\n\n${fullText}`;

//     const result = await model.generateContent(prompt);
//     const response = await result.response;
//     return response.text();
//   } catch (error) {
//     console.error("Error saat membuat summary dengan AI:", error);
//     throw new Error("Gagal membuat ringkasan dari AI");
//   }
// };

// module.exports = {
//   getAIChatResponse,
//   getAISummary,
// };

//API Proxy

// backend/src/services/aiService.js
require("dotenv").config();
const axios = require("axios"); // Kita kembali menggunakan axios!

// --- Fungsi untuk Chat ---
const getAIChatResponse = async (userMessage) => {
  try {
    const PROXY_API_KEY = process.env.PROXY_API_KEY;

    if (!PROXY_API_KEY) {
      throw new Error("PROXY_API_KEY tidak ditemukan di file .env");
    }

    // 1. URL Endpoint dari panduan teman Anda
    const url =
      "https://krsbeknjypkg.sg-members-1.clawcloudrun.com/proxy/gemini/v1beta/openai/chat/completions"; // Tambahkan /chat/completions di akhir

    // 2. Body/Payload permintaan, mengikuti format OpenAI
    const data = {
      model: "gemini-2.5-pro", // Gunakan nama model yang disarankan teman Anda
      messages: [
        {
          role: "system",
          content: `
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
          `,
        },
        {
          role: "user",
          content: userMessage,
        },
      ],
    };

    // 3. Headers permintaan, termasuk API Key dengan format "Bearer"
    const headers = {
      Authorization: `Bearer ${PROXY_API_KEY}`,
      "Content-Type": "application/json",
    };

    // 4. Mengirim permintaan menggunakan axios
    const response = await axios.post(url, data, { headers: headers });

    let aiReply = response.data.choices[0].message.content;

    // 5. Mengambil balasan dari struktur respons OpenAI
    aiReply = aiReply.replace(/\n/g, " ");

    return aiReply;
  } catch (error) {
    if (error.response) {
      console.error(
        "Error dari Proxy API:",
        error.response.status,
        error.response.data
      );
    } else {
      console.error("Error saat mengirim permintaan:", error.message);
    }
    throw new Error("Gagal mendapatkan balasan dari AI");
  }
};

// --- Fungsi untuk Summary (JUGA HARUS DIUPDATE) ---
const getAISummary = async (history) => {
  try {
    const PROXY_API_KEY = process.env.PROXY_API_KEY;

    if (!PROXY_API_KEY) {
      throw new Error("PROXY_API_KEY tidak ditemukan di file .env");
    }

    const url =
      "https://krsbeknjypkg.sg-members-1.clawcloudrun.com/proxy/gemini/v1beta/openai/chat/completions";
    const fullText = history.join("\n");
    const prompt = `Ringkaslah percakapan berikut menjadi poin-poin utama yang mudah dipahami oleh seorang psikolog. Fokus pada keluhan utama, perasaan yang diekspresikan, dan potensi pemicu masalah. Gunakan bahasa Indonesia yang formal dan terstruktur:\n\n---\n\n${fullText}`;

    const data = {
      model: "gemini-2.5-pro",
      messages: [{ role: "user", content: prompt }],
    };

    const headers = {
      Authorization: `Bearer ${PROXY_API_KEY}`,
      "Content-Type": "application/json",
    };

    const response = await axios.post(url, data, { headers: headers });
    return response.data.choices[0].message.content;
  } catch (error) {
    if (error.response) {
      console.error(
        "Error dari Proxy API saat membuat summary:",
        error.response.status,
        error.response.data
      );
    } else {
      console.error("Error saat mengirim permintaan summary:", error.message);
    }
    throw new Error("Gagal membuat ringkasan dari AI");
  }
};

module.exports = {
  getAIChatResponse,
  getAISummary,
};
