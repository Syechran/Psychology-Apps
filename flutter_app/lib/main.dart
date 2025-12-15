import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flanella',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFDF5F2),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFADBC5)),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 0,
              bottom: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SafeArea(
                  bottom: false,
                  minimum: EdgeInsets.only(top: 30),
                  child: _HeaderSection(),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Curhatan kamu baru baru ini!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D3B40),
                  ),
                ),
                const SizedBox(height: 12),
                const _ActivityCard(
                  title: "Sedih karena disuruh ke warung",
                  description:
                      "Ceritanya ini deskripsi tentang chat ini yang dimasukin sama user untuk ceritain lagi...",
                  date: "22 November 2025",
                  buttonText: "Lanjutkan",
                ),

                const SizedBox(height: 24),

                const Text(
                  "Diary kamu akhir-akhir ini!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D3B40),
                  ),
                ),
                const SizedBox(height: 12),
                const _ActivityCard(
                  title: "Sedih karena disuruh ke warung",
                  description:
                      "Ceritanya ini deskripsi tentang diary ini yang dimasukin sama user.",
                  date: "22 November 2025",
                  buttonText: "Lanjutkan",
                ),

                const SizedBox(height: 24),

                const Text(
                  "Rekomendasi konsultasi!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D3B40),
                  ),
                ),
                const SizedBox(height: 12),
                const _ConsultationSection(),
              ],
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _CustomBottomNavBar(),
          ),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.person, color: Color(0xFF9CAF88), size: 30),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Hai kamu,",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D3B40),
                ),
              ),
              Text(
                "Jangan lupa untuk tersenyum ya!",
                style: TextStyle(fontSize: 14, color: Color(0xFF8A8A8E)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String buttonText;

  const _ActivityCard({
    required this.title,
    required this.description,
    required this.date,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFADBC5).withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D3B40),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8E)),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Color(0xFFB0B0B0)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF9CAF88),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConsultationSection extends StatelessWidget {
  const _ConsultationSection();

  @override
  Widget build(BuildContext context) {
    final consults = [
      {"name": "Halodoc", "color": Colors.pinkAccent},
      {"name": "Kalm", "color": Colors.orangeAccent},
      {"name": "AloDokter", "color": Colors.blueAccent},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: consults.map((item) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.health_and_safety,
                  size: 40,
                  color: item['color'] as Color,
                ),
                const SizedBox(height: 8),
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Hubungi",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  const _CustomBottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      // MENGGUNAKAN SAFE AREA DENGAN CARA YANG BENAR
      child: SafeArea(
        // Ini kuncinya: Kita hanya minta 'sedikit' jarak tambahan dari margin sistem
        minimum: const EdgeInsets.only(bottom: 10),
        child: Padding(
          // Padding atas untuk memberi jarak antara ikon dan garis lengkung atas
          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home Icon
              Container(
                padding: const EdgeInsets.all(
                  10,
                ), // Sedikit diperkecil paddingnya biar ga bongsor
                decoration: const BoxDecoration(
                  color: Color(0xFF9CAF88),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 24, // Sedikit diperkecil iconnya
                ),
              ),

              // Flower Icon
              const Icon(
                Icons.local_florist_rounded,
                color: Color(0xFF9CAF88),
                size: 28,
              ),

              // Note Icon
              const Icon(
                Icons.edit_document,
                color: Color(0xFF9CAF88),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
