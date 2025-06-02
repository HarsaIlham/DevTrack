import 'package:flutter/material.dart';

class MonitoringProyek extends StatefulWidget {
  const MonitoringProyek({super.key});

  @override
  State<MonitoringProyek> createState() => _MonitoringProyekState();
}

class _MonitoringProyekState extends State<MonitoringProyek> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Monitoring Proyek',
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
