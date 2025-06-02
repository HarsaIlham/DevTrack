import 'package:flutter/material.dart';

class TambahMandor extends StatefulWidget {
  const TambahMandor({super.key});
  static const String routeName = '/tambah-mandor';

  @override
  State<TambahMandor> createState() => _TambahMandorState();
}

class _TambahMandorState extends State<TambahMandor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Akun Mandor',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(36, 158, 192, 1),
      ),
    );
  }
}