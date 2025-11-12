import 'dart:convert';
import 'package:recipe_box/db/db_helper.dart';
import 'package:recipe_box/db/db_constants.dart';
import 'package:recipe_box/models/resep_model.dart';
import 'package:sqflite/sqflite.dart';

class ResepDao {
  static Future<int> insertResep(Resep resep) async {
    final db = await DBHelper.database;

    return await db.insert(
      DBConstants.tableResep,
      {
        DBConstants.colJudul: resep.judul,
        DBConstants.colKategori: resep.kategori,
        DBConstants.colPorsi: resep.porsi,
        DBConstants.colWaktu: resep.waktuMasak,
        DBConstants.colImage: resep.imagePath,
        DBConstants.colBahan: jsonEncode(resep.bahan),
        DBConstants.colLangkah: jsonEncode(resep.langkah),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // static Future<List<Resep>> getAllResep() async {
  //   final db = await DBHelper.database;
  //   final result = await db.query(DBConstants.tableResep, orderBy: DBConstants.colId);

  //   return result.map((e) => Resep(
  //     judul: e[DBConstants.colJudul] as String,
  //     kategori: e[DBConstants.colKategori] as String,
  //     porsi: e[DBConstants.colPorsi] as int,
  //     waktuMasak: e[DBConstants.colWaktu] as String,
  //     bahan: List<String>.from(jsonDecode(e[DBConstants.colBahan])),
  //     langkah: List<String>.from(jsonDecode(e[DBConstants.colLangkah])),
  //     imagePath: e[DBConstants.colImage] as String?,
  //   )).toList();
  // }

  static Future<int> deleteResep(int id) async {
    final db = await DBHelper.database;
    return await db.delete(
      DBConstants.tableResep,
      where: '${DBConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  static Future<void> clearAll() async {
    final db = await DBHelper.database;
    await db.delete(DBConstants.tableResep);
  }
}
