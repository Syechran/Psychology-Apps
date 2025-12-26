// flutter_app/lib/journal-page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'writing_journal_page.dart';
import 'homepage.dart';
import 'chat_history.dart';
import 'journal_service.dart'; // Import Service

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
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => _navigateToWritingPage(),
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA1BC98),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
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
                        const SizedBox(height: 8),
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
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : journals.isEmpty
                    ? const Center(child: Text('Belum ada jurnal.'))
                    : GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: journals.length,
                  itemBuilder: (context, index) {
                    final journal = journals[index];
                    final date =
                    DateTime.parse(journal['created_at']);
                    final formattedDate =
                    DateFormat('dd MMMM yyyy').format(date);

                    return GestureDetector(
                      onTap: () =>
                          _navigateToWritingPage(journal: journal),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              journal['title'] ?? 'No Title',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              journal['content'] ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
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
                                borderRadius:
                                BorderRadius.circular(8),
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
      // Menggunakan Navbar Lokal Sederhana
      bottomNavigationBar: _buildLocalNavbar(),
    );
  }

  // Widget Navbar Lokal (Sesuai Gambar Referensi)
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
          // Tombol Home (Kiri) - TIDAK AKTIF
          IconButton(
            onPressed: () => _onNavBarTap(0),
            icon: const Icon(
              Icons.home_filled,
              size: 32,
              color: Color(0xFF8DAC8D), // Sage Green (Tidak Aktif)
            ),
          ),
          // Tombol Tengah (Tulip) - TIDAK AKTIF
          IconButton(
            onPressed: () => _onNavBarTap(1),
            icon: const Icon(
              Icons.local_florist, // Icon Bunga Tulip
              size: 32,
              color: Color(0xFF8DAC8D), // Sage Green (Tidak Aktif)
            ),
          ),
          // Tombol Jurnal (Kanan) - AKTIF
          IconButton(
            onPressed: () {}, // Sedang di halaman ini
            icon: const Icon(
              Icons.edit_note, // Icon Note/Jurnal
              size: 34,
              color: Color(0xFF557C56), // Hijau Tua (Aktif)
            ),
          ),
        ],
      ),
    );
  }
}
