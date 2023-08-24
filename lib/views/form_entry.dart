import 'dart:io';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fria02_praktik_kpu/db/db.dart';
import 'package:fria02_praktik_kpu/model/pemilih.dart';
import 'package:fria02_praktik_kpu/views/widget/datetime_picker_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class FormEntry extends StatefulWidget {
  final Pemilih? pemilih;
  const FormEntry({super.key, this.pemilih});

  @override
  State<FormEntry> createState() => _FormEntryState();
}

class _FormEntryState extends State<FormEntry> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nik = TextEditingController();
  TextEditingController namaLengkap = TextEditingController();
  TextEditingController nomorHp = TextEditingController();
  String? jenisKelamin;
  late DateTime tanggal = DateTime.now();
  final tanggals = BoardDateTimeController();
  DateTimePickerType? opened;
  late TextEditingController alamat = TextEditingController();
  String? gambar;

  bool isValid = false;

  @override
  void initState() {
    super.initState();

    if (widget.pemilih != null) {
      nik = TextEditingController(text: widget.pemilih!.nik);
      namaLengkap = TextEditingController(text: widget.pemilih!.namaLengkap);
      nomorHp = TextEditingController(text: widget.pemilih!.nomorHp);
      jenisKelamin = widget.pemilih!.jenisKelamin;
      tanggal = widget.pemilih!.tanggal;
      alamat = TextEditingController(text: widget.pemilih!.alamat);
      gambar = widget.pemilih!.gambar;
    }
  }

  void addOrUpdateData() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      this.isValid = true;
      final isUpdating = widget.pemilih != null;

      if (isUpdating) {
        await updateData();
      } else {
        await addData();
      }
    }
  }

  Future updateData() async {
    final data = widget.pemilih!.copy(
        nik: nik.text,
        namaLengkap: namaLengkap.text,
        nomorHp: nomorHp.text,
        jenisKelamin: jenisKelamin,
        tanggal: tanggal,
        alamat: alamat.text,
        gambar: gambar);

    try {
      await InitDatabase.instance.update(data);
      print("Update Success");
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future addData() async {
    final data = Pemilih(
      nik: nik.text,
      namaLengkap: namaLengkap.text,
      nomorHp: nomorHp.text,
      jenisKelamin: jenisKelamin.toString(),
      tanggal: tanggal,
      alamat: alamat.text,
      gambar: gambar.toString(),
    );

    try {
      await InitDatabase.instance.create(data);
      print("Success");
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission == await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future getAddressFromLatLong(Position position) async {
    List placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    alamat = TextEditingController(
        text:
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}');
    setState(() {});
  }

  String? lat, long;

  File? pickedImage;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
          source: source, imageQuality: 85, maxWidth: 400, maxHeight: 400);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(image: img);
      setState(() {
        pickedImage = img;
        Navigator.of(context).pop();
      });
      if (await pickedImage!.exists()) {
        gambar = await uploadImage();
        setState(() {});
      }
    } on PlatformException {
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File image}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: image.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  Future<String> uploadImage() async {
    final appPath = await getApplicationDocumentsDirectory();
    final finalPath =
        p.join(appPath.path, 'upload', 'img', p.basename(pickedImage!.path));
    await pickedImage!.copy(finalPath);
    return finalPath;
  }

  @override
  Widget build(BuildContext context) {
    return BoardDateTimeBuilder(
      controller: tanggals,
      resizeBottom: true,
      onChange: (value) {
        setState(() {
          tanggal = value;
        });
      },
      builder: (context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
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
              "Form Entry",
              style: GoogleFonts.ubuntu(
                  fontSize: 28,
                  color: HexColor("6528F7"),
                  fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 30, bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 500,
                              fit: FlexFit.tight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: nik,
                                    keyboardType: TextInputType.text,
                                    scrollPhysics:
                                        const ClampingScrollPhysics(),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        label: Text(
                                          "NIK",
                                          style: GoogleFonts.ubuntu(),
                                        )),
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 500,
                              fit: FlexFit.tight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: namaLengkap,
                                    keyboardType: TextInputType.text,
                                    scrollPhysics:
                                        const ClampingScrollPhysics(),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        label: Text(
                                          "Nama Lengkap",
                                          style: GoogleFonts.ubuntu(),
                                        )),
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 500,
                              fit: FlexFit.tight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: nomorHp,
                                    keyboardType: TextInputType.text,
                                    scrollPhysics:
                                        const ClampingScrollPhysics(),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        label: Text(
                                          "No. HP",
                                          style: GoogleFonts.ubuntu(),
                                        )),
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Text(
                            "Jenis Kelamin",
                            style: GoogleFonts.ubuntu(fontSize: 16),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Radio(
                                  value: "Laki-Laki",
                                  groupValue: jenisKelamin,
                                  onChanged: (value) {
                                    setState(() {
                                      jenisKelamin = value;
                                    });
                                  }),
                              const Text(
                                "L",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: "Perempuan",
                                  groupValue: jenisKelamin,
                                  onChanged: (value) {
                                    setState(() {
                                      jenisKelamin = value;
                                    });
                                  }),
                              const Text(
                                "P",
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Text(
                            "Tanggal",
                            style: GoogleFonts.ubuntu(fontSize: 16),
                          ),
                          const Spacer(),
                          DateTimePickerWidget(
                            controller: tanggals,
                            onOpen: (DateTimePickerType type) {
                              opened = type;
                            },
                            type: DateTimePickerType.datetime,
                            d: tanggal,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 500,
                              fit: FlexFit.tight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: alamat,
                                    keyboardType: TextInputType.text,
                                    scrollPhysics:
                                        const ClampingScrollPhysics(),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        label: Text(
                                          "Alamat",
                                          style: GoogleFonts.ubuntu(),
                                        )),
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        lat == null
                            ? const SizedBox()
                            : long == null
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      Text(
                                        'Latitude: $lat',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        'Longitude: $long',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                        SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                "Atau",
                                style: GoogleFonts.ubuntu(fontSize: 16),
                              ),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              getCurrentLocation().then((value) async {
                                lat = '${value.latitude}';
                                long = '${value.longitude}';
                                // String googleUrl =
                                //     "https://www.google.com/maps/search/?api=1&query=$lat,$long";

                                // await canLaunchUrlString(googleUrl)
                                //     ? launchUrlString(googleUrl)
                                //     : throw 'Could not launch $googleUrl';
                                getAddressFromLatLong(value);
                              });
                            },
                            child: Text(
                              "Dapatkan Lokasi Saat Ini",
                              style: GoogleFonts.ubuntu(fontSize: 14),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Gambar",
                                style: GoogleFonts.ubuntu(fontSize: 16),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                  onPressed: () {
                                    _showModalBottomSheet(context);
                                  },
                                  child: Text(
                                    "Pilih Gambar",
                                    style: GoogleFonts.ubuntu(fontSize: 14),
                                  ))
                            ],
                          ),
                          widget.pemilih == null && pickedImage == null
                              ? const SizedBox()
                              : widget.pemilih != null && pickedImage == null
                                  ? Image.file(
                                      File(gambar.toString()),
                                      scale: 1.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                    )
                                  : Image.file(
                                      File(pickedImage!.path),
                                      scale: 1.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                    )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: isValid
                                ? Colors.blue
                                : Colors.blue.withOpacity(0.6),
                            side: BorderSide(color: HexColor('EDE4FF'))),
                        onPressed: () {
                          addOrUpdateData();
                        },
                        child: SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              "SUBMIT",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: ((context) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _pickImage(ImageSource.gallery);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade300,
                        fixedSize: const Size(300, 50),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    child: const Text(
                      'Pick Image From Gallery',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _pickImage(ImageSource.camera);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade300,
                        fixedSize: const Size(300, 50),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    child: const Text(
                      'Pick Image From Camera',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            )));
  }
}
