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
    final itemWidth = width / 3;

    return SizedBox(
      height: kBottomNavigationBarHeight + 35, // Adjusted height
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Fluid Background with Shadow
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            left: 0,
            right: 0,
            bottom: 0,
            height: kBottomNavigationBarHeight + 20,
            child: CustomPaint(
              painter: _NavbarBackgroundPainter(
                selectedIndex: selectedIndex,
                itemCount: 3,
                color: Colors.white,
              ),
              child: Container(),
            ),
          ),

          // 2. Items & Floating Button
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildNavItem(0, Icons.home_rounded, itemWidth), // Use rounded variants
                _buildNavItem(1, Icons.local_florist_rounded, itemWidth),
                _buildNavItem(2, Icons.edit_note_rounded, itemWidth),
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
        height: kBottomNavigationBarHeight + 30, // Match visual height
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Floating Circle Background (Putih)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              bottom: isSelected ? 45 : 15,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isSelected ? 60 : 0, // Slightly larger
                height: isSelected ? 60 : 0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15), // Stronger shadow
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [],
                ),
              ),
            ),
            // Icon
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              bottom: isSelected ? 65 : 18, // Lifted selected, lowered unselected
              child: Icon(
                icon,
                size: 32, // Slightly larger icons
                color: isSelected ? sageGreenColor : sageGreenColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavbarBackgroundPainter extends CustomPainter {
  final int selectedIndex;
  final int itemCount;
  final Color color;

  _NavbarBackgroundPainter({
    required this.selectedIndex,
    required this.itemCount,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path();
    final itemWidth = size.width / itemCount;
    final center = itemWidth * selectedIndex + (itemWidth / 2);
    
    // Parameters for the shape
    const double notchRadius = 40.0; // Lebar total lekukan kiri-kanan
    const double notchDepth = 30.0;  // Kedalaman lekukan (Reduced for shallower curve)
    const double topRadius = 25.0;   // Kebulatan sudut kiri-kanan atas navbar
    const double topPositions = 20.0; // Tinggi awal flat surface
    
    path.moveTo(0, topPositions + topRadius);
    
    // Sudut kiri atas bulat
    path.quadraticBezierTo(0, topPositions, topRadius, topPositions);
    
    // Garis datar kiri sampai mulai lekukan
    double startCurve = center - notchRadius;
    path.lineTo(startCurve, topPositions);
    
    // Lekukan Cekung (Smooth Concave)
    // Menggunakan 2 Cubic Bezier untuk membentuk huruf U yang sangat halus
    
    // Bagian turun (kiri ke tengah bawah)
    path.cubicTo(
      center - (notchRadius * 0.6), topPositions, // Control 1: Geser sedikit ke dalam tetap datar
      center - (notchRadius * 0.4), topPositions + notchDepth, // Control 2:  Turun tajam (convex feel) -> tapi ini buat concave
      center, topPositions + notchDepth, // Titik akhir (Tengah Bawah)
    );
    
    /* Revisi Logika Bezier untuk Concave Sempurna:
       Kita ingin startCurve (datar) -> smooth transition -> bottom center -> smooth transition -> endCurve (datar)
    */
    
    // Bagian naik (tengah bawah ke kanan)
    path.cubicTo(
      center + (notchRadius * 0.4), topPositions + notchDepth, // Control 1: Naik tajam
      center + (notchRadius * 0.6), topPositions, // Control 2: Menuju datar
      center + notchRadius, topPositions, // Titik akhir kanan
    );
    
    // Garis datar sisa ke kanan
    path.lineTo(size.width - topRadius, topPositions);
    
    // Sudut kanan atas bulat
    path.quadraticBezierTo(size.width, topPositions, size.width, topPositions + topRadius);
    
    // Sisi kanan bawah kiri tutup
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    // Shadow Utama
    // Kita gambar shadow manual agar lebih smooth
    canvas.drawShadow(path, Colors.black.withOpacity(0.1), 8.0, true);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NavbarBackgroundPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }
}