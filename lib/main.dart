import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fria02_praktik_kpu/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appPath = await getApplicationDocumentsDirectory();
  final finalPath = p.join(appPath.path, "upload", "img");
  await Directory(finalPath).create(recursive: true);
  runApp(const KPUApp());
}

class KPUApp extends StatelessWidget {
  const KPUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PENDATAAN KPU - VSGA',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
