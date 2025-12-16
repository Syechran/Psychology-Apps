// flutter_app/lib/homepage.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chat_history.dart';
import 'journal-page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required String title});

  // Helper function to launch URLs
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  // Function to handle Navbar navigation
  void _handleNavigation(BuildContext context, int index) {
    if (index == 0) return; // Already on Home

    if (index == 1) {
      // Navigate to Chat History
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const ChatHistoryScreen(title: 'Riwayat Curhat')),
      );
    } else if (index == 2) {
      // Navigate to Journal
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
      backgroundColor: const Color(0xFFF7D9C4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Section ---
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                      Border.all(color: const Color(0xFFFFFFFF), width: 3),
                    ),
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundImage:
                      AssetImage('assets/images/foto_profile_example.jpg'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hai Orang Baik,',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Jangan lupa untuk tersenyum ya!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // --- Curhatan Section ---
              const Text(
                'Curhatan kamu baru baru ini!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              // Placeholder for Chat History
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Masih kosong nih...',
                    style: TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- Jurnal Section ---
              const Text(
                'Jurnal kamu akhir-akhir ini!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              // Placeholder for Journal
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Masih kosong nih...',
                    style: TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- Rekomendasi Section ---
              const Text(
                'Rekomendasi konsultasi!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),

              // White Container for Consultation Cards
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildConsultationCard(
                        imagePath: 'assets/images/Logo_Halodoc.png',
                        buttonColor:
                        const Color(0xFFE0004D), // Halodoc Red/Pink
                        onTap: () => _launchURL('https://www.halodoc.com/'),
                      ),
                      const SizedBox(width: 12),
                      _buildConsultationCard(
                        imagePath: 'assets/images/logo_Kalm.png',
                        buttonColor:
                        const Color(0xFF5C7C8A), // Kalm Grey/Blueish
                        onTap: () => _launchURL('https://www.kalm.id/'),
                      ),
                      const SizedBox(width: 12),
                      _buildConsultationCard(
                        imagePath: 'assets/images/alodokter.png',
                        buttonColor: const Color(0xFF2D74C4), // Alodokter Blue
                        onTap: () => _launchURL('https://www.alodokter.com/'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // Menggunakan Navbar Lokal Sederhana
      bottomNavigationBar: _buildLocalNavbar(context),
    );
  }

  // Widget Navbar Lokal (Sesuai Gambar Referensi)
  Widget _buildLocalNavbar(BuildContext context) {
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
          // Tombol Home (Kiri) - AKTIF
          IconButton(
            onPressed: () {}, // Sudah di Home
            icon: const Icon(
              Icons.home_filled,
              size: 32,
              color: Color(0xFF557C56), // Hijau Tua (Aktif)
            ),
          ),
          // Tombol Tengah (Tulip) - TIDAK AKTIF
          IconButton(
            onPressed: () => _handleNavigation(context, 1),
            icon: const Icon(
              Icons.local_florist, // Icon Bunga Tulip
              size: 32,
              color: Color(0xFF8DAC8D), // Sage Green (Tidak Aktif)
            ),
          ),
          // Tombol Jurnal (Kanan) - TIDAK AKTIF
          IconButton(
            onPressed: () => _handleNavigation(context, 2),
            icon: const Icon(
              Icons.edit_note, // Icon Note/Jurnal
              size: 34,
              color: Color(0xFF8DAC8D), // Sage Green (Tidak Aktif)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationCard({
    required String imagePath,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 120,
      height: 160,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                ),
              ),
              child: const Text(
                'Hubungi\nSekarang!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
