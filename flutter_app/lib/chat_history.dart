// flutter_app/lib/chat_history.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_page.dart';
import 'journal-page.dart';
import 'homepage.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key, required String title});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  List<dynamic> chatHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChatHistory();
  }

  Future<void> fetchChatHistory() async {
    try {
      // Sesuaikan URL dengan konfigurasi backend Anda
      final response =
      await http.get(Uri.parse('http://10.0.2.2:3000/api/chat/history'));

      if (response.statusCode == 200) {
        setState(() {
          chatHistory = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load history');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Handle Navbar Navigation
  void _onNavBarTap(int index) {
    if (index == 1) return; // Sudah di halaman Chat History

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage(title: '',)),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const JournalPage(title: 'Jurnal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9E2D2),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Mau lanjut ngobrol nih?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
              ),
            ),

            // New Chat Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatPage(
                        title: "Curhat Baru",
                      ),
                    ),
                  ).then((_) => fetchChatHistory());
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA3C4A0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Mau Buat\nCurhatan Baru?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, color: Color(0xFFA3C4A0)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Chat History List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : chatHistory.isEmpty
                  ? const Center(child: Text("Belum ada riwayat curhat."))
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  final chat = chatHistory[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat['title'] ?? "Tanpa Judul",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          chat['preview'] ?? "...",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(chat['updatedAt']),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      title: chat['title'] ??
                                          "Curhat Lama",
                                    ),
                                  ),
                                ).then((_) => fetchChatHistory());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFFA3C4A0),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                              ),
                              child: const Text(
                                "Lanjutkan",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Menggunakan Navbar Lokal yang Sederhana (Flat)
      bottomNavigationBar: _buildLocalNavbar(),
    );
  }

  // Widget Navbar Lokal Sederhana (Sesuai Gambar)
  Widget _buildLocalNavbar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Tombol Home (Kiri)
          IconButton(
            onPressed: () => _onNavBarTap(0),
            icon: const Icon(
              Icons.home_filled,
              size: 32,
              color: Color(0xFF8DAC8D), // Warna Sage Green (Tidak Aktif)
            ),
          ),
          // Tombol Tengah (Tulip - Aktif)
          IconButton(
            onPressed: () {}, // Sedang di halaman ini
            icon: const Icon(
              Icons.local_florist, // Icon Bunga Tulip
              size: 32,
              color: Color(0xFF557C56), // Hijau Tua (Aktif)
            ),
          ),
          // Tombol Jurnal (Kanan)
          IconButton(
            onPressed: () => _onNavBarTap(2),
            icon: const Icon(
              Icons.edit_note, // Icon Note/Jurnal
              size: 34,
              color: Color(0xFF8DAC8D), // Warna Sage Green (Tidak Aktif)
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return "";
    try {
      DateTime date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }
}
