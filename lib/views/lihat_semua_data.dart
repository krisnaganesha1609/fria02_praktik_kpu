import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:fria02_praktik_kpu/db/db.dart';
import 'package:fria02_praktik_kpu/model/pemilih.dart';
import 'package:fria02_praktik_kpu/views/lihat_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class LihatSemuaData extends StatefulWidget {
  const LihatSemuaData({super.key});

  @override
  State<LihatSemuaData> createState() => _LihatSemuaDataState();
}

class _LihatSemuaDataState extends State<LihatSemuaData> {
  late List<Pemilih> datas;
  bool isLoading = false;

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

    datas = await InitDatabase.instance.readAllPemilih();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lihat Semua Data",
          style: GoogleFonts.ubuntu(
              fontSize: 24,
              color: HexColor("6528F7"),
              fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: HexColor("6528F7"),
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: const [
          Icon(Icons.search),
          SizedBox(
            width: 12,
          )
        ],
      ),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator.adaptive()
              : datas.isEmpty
                  ? const Text(
                      "No Data",
                      style: TextStyle(color: Colors.black),
                    )
                  : buildDatas()),
    );
  }

  Widget buildDatas() {
    return DataTable2(
        columnSpacing: 10,
        horizontalMargin: 10,
        minWidth: 1000,
        columns: [
          DataColumn2(
              label: Text("Tanggal", style: GoogleFonts.ubuntu()),
              size: ColumnSize.L),
          DataColumn2(
              label: Text(
                "ID",
                style: GoogleFonts.ubuntu(),
              ),
              size: ColumnSize.S),
          DataColumn(label: Text("NIK", style: GoogleFonts.ubuntu())),
          DataColumn(label: Text("Nama Lengkap", style: GoogleFonts.ubuntu())),
          DataColumn(label: Text("Jenis Kelamin", style: GoogleFonts.ubuntu())),
          DataColumn(label: Text("View Data", style: GoogleFonts.ubuntu())),
        ],
        rows: List<DataRow>.generate(datas.length, (index) {
          final data = datas[index];
          return DataRow(cells: [
            DataCell(
              Text(DateFormat.yMMMEd().add_jmv().format(data.tanggal),
                  style: GoogleFonts.ubuntu()),
            ),
            DataCell(Text(data.id.toString(), style: GoogleFonts.ubuntu())),
            DataCell(Text(data.nik.toString(), style: GoogleFonts.ubuntu())),
            DataCell(
                Text(data.namaLengkap.toString(), style: GoogleFonts.ubuntu())),
            DataCell(Text(data.jenisKelamin.toString(),
                style: GoogleFonts.ubuntu())),
            DataCell(IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LihatData(
                          id: data.id!,
                        )));
                refreshData();
              },
            ))
          ]);
        }));
  }
}
