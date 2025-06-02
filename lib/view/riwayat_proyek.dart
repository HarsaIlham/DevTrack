import 'package:flutter/material.dart';

class RiwayatProyek extends StatefulWidget {
  const RiwayatProyek({super.key});

  @override
  State<RiwayatProyek> createState() => _RiwayatProyekState();
}

class _RiwayatProyekState extends State<RiwayatProyek> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Riwayat Proyek',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(36, 158, 192, 1),
      ),
    );
  }
}