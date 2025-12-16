// flutter_app/lib/widgets/custom_navbar.dart

import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  // Warna sesuai request
  final Color peachColor = const Color(0xFFF7D9C4);
  final Color sageGreenColor = const Color(0xFF8DAC8D);

  const CustomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final itemWidth = width / 3; // Membagi lebar layar untuk 3 item

    return SizedBox(
      height: kBottomNavigationBarHeight + 30, // Tinggi ekstra untuk elemen floating
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Layer Bawah: Bar Putih Dasar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: kBottomNavigationBarHeight + 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
            ),
          ),

          // 2. Layer Tengah: Lengkungan Peach (Bergerak Animasi)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: selectedIndex * itemWidth,
            bottom: kBottomNavigationBarHeight - 5, // Posisi sedikit overlap dengan bar putih
            width: itemWidth,
            height: 50,
            child: CustomPaint(
              painter: _PeachCurvePainter(color: peachColor),
            ),
          ),

          // 3. Layer Atas: Icon Menu dan Tombol Floating
          Positioned.fill(
            child: Row(
              children: [
                _buildNavItem(0, Icons.home_filled, itemWidth),
                _buildNavItem(1, Icons.local_florist, itemWidth), // Icon Bunga untuk History
                _buildNavItem(2, Icons.edit_note, itemWidth),     // Icon Note untuk Jurnal
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, double width) {
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Lingkaran Putih (Floating Background) - Muncul saat dipilih
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: isSelected ? 45 : 15, // Naik ke atas saat dipilih
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isSelected ? 56 : 0, // Membesar saat dipilih
                height: isSelected ? 56 : 0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : [],
                ),
              ),
            ),
            // Icon
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: isSelected ? 58 : 25, // Icon ikut naik
              child: Icon(
                icon,
                size: 30,
                color: sageGreenColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Class untuk menggambar lengkungan peach di belakang tombol aktif
class _PeachCurvePainter extends CustomPainter {
  final Color color;
  _PeachCurvePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Menggambar bentuk bukit landai
    path.moveTo(0, size.height); // Mulai dari kiri bawah

    // Kurva naik ke tengah (Bentuk S-curve naik)
    path.cubicTo(
      size.width * 0.25, size.height,      // Control point 1
      size.width * 0.25, 10,               // Control point 2
      size.width * 0.5, 10,                // Puncak
    );

    // Kurva turun ke kanan (Bentuk S-curve turun)
    path.cubicTo(
      size.width * 0.75, 10,               // Control point 3
      size.width * 0.75, size.height,      // Control point 4
      size.width, size.height,             // Kanan bawah
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
