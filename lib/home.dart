import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fria02_praktik_kpu/views/form_entry.dart';
import 'package:fria02_praktik_kpu/views/informasi.dart';
import 'package:fria02_praktik_kpu/views/lihat_semua_data.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        HexColor("6528F7"),
        HexColor("A076F9"),
        HexColor("D7BBF5"),
        HexColor("EDE4FF"),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "KPU",
            style: GoogleFonts.ubuntu(
                fontSize: 40,
                color: HexColor("6528F7"),
                fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: ListView(children: [
            OutlinedButton(
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Informasi()));
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    side: BorderSide(color: HexColor('EDE4FF'))),
                child: SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      "INFORMASI",
                      style: GoogleFonts.ubuntu(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FormEntry()));
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    side: BorderSide(color: HexColor('EDE4FF'))),
                child: SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      "FORM ENTRY",
                      style: GoogleFonts.ubuntu(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LihatSemuaData()));
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    side: BorderSide(color: HexColor('EDE4FF'))),
                child: SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      "LIHAT DATA",
                      style: GoogleFonts.ubuntu(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )),
            const SizedBox(
              height: 50,
            ),
            Divider(
              thickness: 1.5,
              color: Colors.black.withOpacity(0.5),
            ),
            const SizedBox(
              height: 50,
            ),
            OutlinedButton(
                onPressed: () async {
                  await SystemNavigator.pop(animated: true);
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.6),
                    side: BorderSide(color: HexColor('EDE4FF'))),
                child: SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      "KELUAR",
                      style: GoogleFonts.ubuntu(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }
}
