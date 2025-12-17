// flutter_app/lib/journal-page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'writing_journal_page.dart';
import 'homepage.dart';
import 'chat_history.dart';
import 'journal_service.dart'; // Import Service
import 'widgets/custom_navbar.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key, required String title});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final JournalService _journalService = JournalService();
  List<dynamic> journals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJournals();
  }

  // Logika Fetching sekarang bersih, hanya memanggil Service
  Future<void> fetchJournals() async {
    try {
      final data = await _journalService.getJournals();
      if (mounted) {
        setState(() {
          journals = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching journals: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _navigateToWritingPage({Map<String, dynamic>? journal}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WritingJournalPage(journal: journal),
      ),
    );

    if (result == true) {
      fetchJournals(); // Refresh list if changes were made
    }
  }

  // Handle Navbar Navigation
  void _onNavBarTap(int index) {
    if (index == 2) return; // Sudah di halaman Jurnal

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage(title: '',)),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const ChatHistoryScreen(title: 'Riwayat Curhat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7D9C4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ini list jurnal-mu selama ini!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 20),
              // --- LIST JURNAL ---
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    // Jika kosong, tetap tampilkan Grid dengan 1 item (Card Tambah Jurnal)
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                        // Item count = Jumlah Jurnal + 1 (Card Tambah Jurnal diurutan pertama)
                        itemCount: journals.length + 1,
                        itemBuilder: (context, index) {
                          // --- ITEM 0: CARD TAMBAH JURNAL ---
                          if (index == 0) {
                            return GestureDetector(
                              onTap: () => _navigateToWritingPage(),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFA1BC98),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Mau Buat\nJurnal Baru?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Color(0xFFA1BC98),
                                        size: 32,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // --- ITEM > 0: LIST JURNAL ---
                          final journal = journals[index - 1]; // Offset index
                          final date = DateTime.parse(journal['created_at']);
                          final formattedDate =
                              DateFormat('dd MMMM yyyy').format(date);

                          return GestureDetector(
                            onTap: () => _navigateToWritingPage(journal: journal),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          journal['title'] ?? 'No Title',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _confirmDelete(journal['id']),
                                        // Area sentuh lebih besar
                                        child: Container(
                                          color: Colors.transparent, 
                                          padding: const EdgeInsets.only(left: 8, bottom: 8),
                                          child: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Text(
                                      journal['content'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Divider(),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFA1BC98),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Lanjutkan',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 2,
        onItemTapped: (index) => _onNavBarTap(index),
      ),
    );
  }


  Future<void> _confirmDelete(String id) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus Jurnal?"),
          content: const Text("Jurnal ini akan dihapus permanen."),
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
        await _journalService.deleteJournal(id);
        fetchJournals();
      } catch (e) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal menghapus jurnal")),
          );
        }
      }
    }
  }

}
