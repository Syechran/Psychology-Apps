// backend/src/services/aiService.js
require("dotenv").config();

// 1. Import class yang dibutuhkan dari SDK
const { GoogleGenerativeAI } = require("@google/generative-ai");

// 2. Ambil API key dari .env dan inisialisasi client
// SDK secara otomatis akan mencari variabel GEMINI_API_KEY
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

const getAIChatResponse = async (userMessage) => {
  try {
    // 3. Pilih model yang akan digunakan
    const model = genAI.getGenerativeModel({
      model: "gemini-2.5-flash",
    });

    // 4. Buat prompt yang lebih rapi
    const prompt = `Anda adalah asisten psikologi AI yang hangat, empatik, dan suportif. Selalu tanggapi dengan ramah dalam bahasa Indonesia. Berikut adalah pesan dari pengguna: "${userMessage}"`;

    // 5. Panggil AI untuk menghasilkan konten. Jauh lebih simpel!
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const aiReply = response.text();

    return aiReply;
  } catch (error) {
    // Error handling tetap sama
    console.error("Error dari Google Generative AI:", error);
    throw new Error("Gagal mendapatkan balasan dari AI");
  }
};

module.exports = {
  getAIChatResponse,
};
