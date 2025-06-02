import 'package:flutter/material.dart';
import 'package:tracedev/view/tambah_mandor.dart';

class AkunMandor extends StatefulWidget {
  const AkunMandor({super.key});

  @override
  State<AkunMandor> createState() => _AkunMandorState();
}

class _AkunMandorState extends State<AkunMandor> {
  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Akun Mandor',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(36, 158, 192, 1),
      ),
      body: Container(
        width: widthApp,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, TambahMandor.routeName);
                },
                icon: Icon(Icons.add, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(134, 182, 246, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: Text(
                  'Tambah Akun Mandor',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Akun Mandor',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            // Expanded untuk detail mandor agar fleksibel dan tidak overflow
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ujang Mandor',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text("Alamat: Sumbersari"),
                                  Text("Email: Q6PbM@example.com"),
                                  Text("No HP: 08123456789"),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            // Tombol Edit dan Hapus vertikal
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    minimumSize: Size(60, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    minimumSize: Size(60, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            titlePadding:
                                                EdgeInsets
                                                    .zero, // Menghilangkan padding default
                                            title: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: Colors.red,
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(24),
                                                  topRight:
                                                      Radius.circular(24),
                                                )
                                              ),
                                              padding: EdgeInsets.all(16),
                                              child: Center(
                                                child: Text(
                                                  'Konfirmasi',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            content: Text(
                                              'Apakah Anda yakin ingin menghapus akun ini?',
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text('Batal'),
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Hapus',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                  child: Text(
                                    'Hapus',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
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
    );
  }
}
