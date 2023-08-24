const String tablePemilih = 'pemilih';

class PemilihFields {
  static final List<String> values = [
    id,
    nik,
    namaLengkap,
    nomorHp,
    jenisKelamin,
    tanggal,
    alamat,
    gambar
  ];

  static const String id = '_id';
  static const String nik = 'NIK';
  static const String namaLengkap = 'Nama_Lengkap';
  static const String nomorHp = 'Nomor_Handphone';
  static const String jenisKelamin = 'Jenis_Kelamin';
  static const String tanggal = 'Tanggal';
  static const String alamat = 'Alamat';
  static const String gambar = 'Gambar';
}

class Pemilih {
  final int? id;
  final String nik;
  final String namaLengkap;
  final String nomorHp;
  final String jenisKelamin;
  final DateTime tanggal;
  final String alamat;
  final String gambar;

  const Pemilih(
      {this.id,
      required this.nik,
      required this.namaLengkap,
      required this.nomorHp,
      required this.jenisKelamin,
      required this.tanggal,
      required this.alamat,
      required this.gambar});

  Pemilih copy(
          {int? id,
          String? nik,
          String? namaLengkap,
          String? nomorHp,
          String? jenisKelamin,
          DateTime? tanggal,
          String? alamat,
          String? gambar}) =>
      Pemilih(
        id: id ?? this.id,
        alamat: alamat ?? this.alamat,
        gambar: gambar ?? this.gambar,
        jenisKelamin: jenisKelamin ?? this.jenisKelamin,
        namaLengkap: namaLengkap ?? this.namaLengkap,
        nik: nik ?? this.nik,
        nomorHp: nomorHp ?? this.nomorHp,
        tanggal: tanggal ?? this.tanggal,
      );

  static Pemilih fromJson(Map<String, Object?> json) => Pemilih(
      id: json[PemilihFields.id] as int?,
      nik: json[PemilihFields.nik] as String,
      namaLengkap: json[PemilihFields.namaLengkap] as String,
      nomorHp: json[PemilihFields.nomorHp] as String,
      jenisKelamin: json[PemilihFields.jenisKelamin] as String,
      tanggal: DateTime.parse(json[PemilihFields.tanggal] as String),
      alamat: json[PemilihFields.alamat] as String,
      gambar: json[PemilihFields.gambar] as String);

  Map<String, Object?> toJson() => {
        PemilihFields.id: id,
        PemilihFields.nik: nik,
        PemilihFields.namaLengkap: namaLengkap,
        PemilihFields.nomorHp: nomorHp,
        PemilihFields.jenisKelamin: jenisKelamin,
        PemilihFields.tanggal: tanggal.toIso8601String(),
        PemilihFields.alamat: alamat,
        PemilihFields.gambar: gambar
      };
}
