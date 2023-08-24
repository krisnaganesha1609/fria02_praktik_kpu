import 'package:fria02_praktik_kpu/model/pemilih.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class InitDatabase {
  static final InitDatabase instance = InitDatabase._init();

  static Database? db;

  InitDatabase._init();

  Future<Database> get database async {
    if (db != null) return db!;

    db = await _initDB('pemilih.db');
    return db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    await db.execute('''
CREATE TABLE $tablePemilih (
  ${PemilihFields.id} $idType,
  ${PemilihFields.nik} $textType,
  ${PemilihFields.namaLengkap} $textType,
  ${PemilihFields.nomorHp} $textType,
  ${PemilihFields.jenisKelamin} $textType,
  ${PemilihFields.tanggal} $textType,
  ${PemilihFields.alamat} $textType,
  ${PemilihFields.gambar} $textType
)
''');
  }

  Future<Pemilih> create(Pemilih pemilih) async {
    final db = await instance.database;

    final id = await db.insert(tablePemilih, pemilih.toJson());

    return pemilih.copy(id: id);
  }

  Future<Pemilih> readPemilihById(int id) async {
    final db = await instance.database;

    final maps = await db.query(tablePemilih,
        columns: PemilihFields.values,
        where: '${PemilihFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Pemilih.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Pemilih>> readAllPemilih() async {
    final db = await instance.database;

    const orderBy = '${PemilihFields.tanggal} ASC';
    try {
      final result = await db.query(tablePemilih, orderBy: orderBy);
      return result.map((e) => Pemilih.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> update(Pemilih pemilih) async {
    final db = await instance.database;

    try {
      return db.update(tablePemilih, pemilih.toJson(),
          where: '${PemilihFields.id} = ?', whereArgs: [pemilih.id]);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    try {
      return await db.delete(tablePemilih,
          where: '${PemilihFields.id} = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future close() async {
    final dbClose = await instance.database;
    db = null;
    dbClose.close();
  }
}
