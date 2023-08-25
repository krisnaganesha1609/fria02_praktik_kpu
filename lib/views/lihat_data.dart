import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fria02_praktik_kpu/db/db.dart';
import 'package:fria02_praktik_kpu/model/pemilih.dart';
import 'package:fria02_praktik_kpu/views/form_entry.dart';
import 'package:fria02_praktik_kpu/views/widget/snackbar_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class LihatData extends StatefulWidget {
  final int id;
  const LihatData({super.key, required this.id});

  @override
  State<LihatData> createState() => _LihatDataState();
}

class _LihatDataState extends State<LihatData> {
  bool isLoading = false;
  late Pemilih data;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshData();
  }

  @override
  void dispose() {
    InitDatabase.instance.close();
    super.dispose();
  }

  Future refreshData() async {
    setState(() {
      isLoading = true;
    });

    data = await InitDatabase.instance.readPemilihById(widget.id);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              await InitDatabase.instance.readAllPemilih();
              if (!mounted) return;
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: HexColor("6528F7"),
            )),
        title: Text(
          "Data Pemilih",
          style: GoogleFonts.ubuntu(
              fontSize: 28,
              color: HexColor("6528F7"),
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FormEntry(
                          pemilih: data,
                        )));

                refreshData();
              },
              icon: Icon(
                Icons.edit,
                color: HexColor("6528F7"),
              )),
          IconButton(
              onPressed: () {
                _showAlertDialog(context);
              },
              icon: Icon(
                Icons.delete,
                color: HexColor("6528F7"),
              ))
        ],
      ),
      body: isLoading
          ? const CircularProgressIndicator.adaptive()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ListView(children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("NIK\n ",
                          style: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                      Text(data.nik,
                          style: GoogleFonts.ubuntu(color: Colors.black))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nama Lengkap\n ",
                          style: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                      Text(data.namaLengkap,
                          style: GoogleFonts.ubuntu(color: Colors.black))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nomor HP\n ",
                          style: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                      Text(data.nomorHp,
                          style: GoogleFonts.ubuntu(color: Colors.black))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Jenis Kelamin\n ",
                          style: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                      Text(data.jenisKelamin,
                          style: GoogleFonts.ubuntu(color: Colors.black))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tanggal\n ",
                          style: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                      Text(
                          DateFormat.yMMMMEEEEd()
                              .add_jmz()
                              .format(data.tanggal),
                          style: GoogleFonts.ubuntu(color: Colors.black))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Alamat\n ",
                          style: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                      Text(data.alamat,
                          style: GoogleFonts.ubuntu(color: Colors.black))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Gambar\n ",
                          style: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                      Text(data.gambar,
                          style: GoogleFonts.ubuntu(color: Colors.black)),
                      Center(
                        child: Image.file(
                          File(data.gambar),
                          scale: 1.5,
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.5,
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
    );
  }

  _showAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Yakin menghapus data ini?",
              style: GoogleFonts.ubuntu(),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await InitDatabase.instance.delete(widget.id);
                    try {
                      if (!mounted) return;
                      SnackbarService.showSuccessSnackbar(
                          context: context,
                          title: "Success",
                          message: "Sukses Menghapus Data!");
                      Navigator.of(context).popUntil(
                        (route) => route.isFirst,
                      );
                    } catch (e) {
                      if (!mounted) return;
                      SnackbarService.showFailedSnackbar(
                          context: context,
                          title: "Failed",
                          message: "Gagal menambahkan data");
                      throw Exception(e);
                    }
                  },
                  child: Text(
                    "Ya",
                    style: GoogleFonts.ubuntu(fontSize: 16, color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Tidak",
                    style: GoogleFonts.ubuntu(fontSize: 16, color: Colors.blue),
                  ))
            ],
          );
        });
  }
}
