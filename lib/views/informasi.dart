import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Informasi extends StatelessWidget {
  const Informasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: HexColor("6528F7"),
            )),
        title: Text(
          "Informasi",
          style: GoogleFonts.ubuntu(
              fontSize: 28,
              color: HexColor("6528F7"),
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
          child: Text(
        "Halaman Informasi Akan Di-Update!",
        textAlign: TextAlign.center,
        style: GoogleFonts.ubuntu(fontSize: 24, fontWeight: FontWeight.w600),
      )),
    );
  }
}
