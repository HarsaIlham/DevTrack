import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const Navbar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  Widget _buildIcon(String imagePath, int index) {
  bool isActive = currentIndex == index;
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: isActive ? const Color.fromRGBO(134, 182, 246, 0.3) : Colors.transparent,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Image.asset(
      imagePath,
      color: isActive ? const Color.fromRGBO(134, 182, 246, 1) : Colors.grey,
      width: 36,
      height: 36,
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues( 
              alpha: 0.5,
            ),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),

        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon('assets/images/manajemen_proyek.png', 0),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon('assets/images/monitoring.png', 1),
              label: 'Penyiraman',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon('assets/images/helmetIcon.png', 2),
              label: 'Penyiraman',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon('assets/images/riwayat.png', 3),
              label: 'Pengaturan',
            ),
          ],
          unselectedItemColor: Colors.grey,
          backgroundColor: Color.fromRGBO(217, 217, 217, 1),
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          iconSize: 30,
          selectedFontSize: 12,
          unselectedFontSize: 12,
        ),
      ),
    );
  }
}
