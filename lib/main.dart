import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracedev/controller/project_controller.dart';
import 'package:tracedev/view/main_page.dart';
import 'package:tracedev/view/tambah_mandor.dart';
import 'package:tracedev/view/tambah_projek.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectController()),
        // Tambah provider lain jika perlu
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      routes: {
        '/tambah-projek': (context) => const TambahProjek(),
        '/tambah-mandor': (context) => const TambahMandor(),
      },
    );
  }
}
