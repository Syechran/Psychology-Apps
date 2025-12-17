import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'journal-page.dart';
import 'homepage.dart';
import 'chat_service.dart'; // Import Service
import 'widgets/custom_navbar.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key, required String title});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final ChatService _chatService = ChatService();
  List<dynamic> chatHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChatHistory();
  }

  Future<void> fetchChatHistory() async {
    try {
      final data = await _chatService.getChatHistory();
      if (mounted) {
        setState(() {
          chatHistory = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _editTitle(String sessionId, String currentTitle) async {
    TextEditingController titleController =
        TextEditingController(text: currentTitle);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ganti Judul Chat"),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Masukkan judul baru"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _chatService.updateTitle(
                      sessionId, titleController.text);
                  Navigator.pop(context); // Tutup dialog
                  fetchChatHistory(); // Refresh list
                } catch (e) {
                  debugPrint("Error update title: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Gagal mengubah judul")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA3C4A0),
              ),
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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
                         // --- TITLE ROW WITH EDIT BUTTON ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                chat['title'] ?? "Tanpa Judul",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                              onPressed: () => _editTitle(chat['id'], chat['title'] ?? ""),
                              constraints: const BoxConstraints(), // Remove padding
                              padding: const EdgeInsets.only(left: 8),
                            ),
                          ],
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                   onTap: () => _confirmDelete(chat['id']),
                                   child: const Icon(
                                     Icons.delete_outline, 
                                     color: Colors.red, 
                                     size: 20
                                   ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatDate(chat['updatedAt']),
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      title: chat['title'] ??
                                          "Curhat Lama",
                                          sessionId: chat['id'],
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
      extendBody: true,
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 1,
        onItemTapped: (index) => _onNavBarTap(index),
      ),
    );
  }

  Future<void> _confirmDelete(String sessionId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus Sesi?"),
          content: const Text("Curhatan ini akan dihapus permanen."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        await _chatService.deleteSession(sessionId);
        fetchChatHistory();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghapus sesi")),
        );
      }
    }
  }

  // Widget Navbar Lokal Floating
  Widget _buildLocalNavbar() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
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
              size: 30, // Sedikit lebih kecil agar proporsional
              color: Color(0xFF8DAC8D), 
            ),
          ),
          // Tombol Tengah (Tulip - Aktif)
          IconButton(
            onPressed: () {}, 
            icon: const Icon(
              Icons.local_florist, 
              size: 30,
              color: Color(0xFF557C56), 
            ),
          ),
          // Tombol Jurnal (Kanan)
          IconButton(
            onPressed: () => _onNavBarTap(2),
            icon: const Icon(
              Icons.edit_note, 
              size: 32,
              color: Color(0xFF8DAC8D), 
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
