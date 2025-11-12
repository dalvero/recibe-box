import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:recipe_box/db/db_constants.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DBConstants.dbName);

    return await openDatabase(
      path,
      version: DBConstants.dbVersion,
      onCreate: _createDB,
    );
  }

  static Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DBConstants.tableResep} (
        ${DBConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBConstants.colJudul} TEXT NOT NULL,
        ${DBConstants.colKategori} TEXT NOT NULL,
        ${DBConstants.colPorsi} INTEGER,
        ${DBConstants.colWaktu} TEXT,
        ${DBConstants.colImage} TEXT,
        ${DBConstants.colBahan} TEXT,
        ${DBConstants.colLangkah} TEXT
      )
    ''');
  }

  static Future<void> close() async {
    final db = await database;
    db.close();
  }
}
