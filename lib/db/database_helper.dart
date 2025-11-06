// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// // import '../models/recipe_model.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;

//   DatabaseHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('recipes.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     // buka atau buat database baru
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDB,
//     );
//   }

//   Future _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE recipes(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         title TEXT,
//         description TEXT,
//         ingredients TEXT,
//         steps TEXT
//       )
//     ''');
//   }

//   // CRUD Operations
//   Future<int> insertRecipe(Recipe recipe) async {
//     final db = await instance.database;
//     return await db.insert('recipes', recipe.toMap());
//   }

//   Future<List<Recipe>> getAllRecipes() async {
//     final db = await instance.database;
//     final result = await db.query('recipes');
//     return result.map((e) => Recipe.fromMap(e)).toList();
//   }

//   Future<int> updateRecipe(Recipe recipe) async {
//     final db = await instance.database;
//     return await db.update(
//       'recipes',
//       recipe.toMap(),
//       where: 'id = ?',
//       whereArgs: [recipe.id],
//     );
//   }

//   Future<int> deleteRecipe(int id) async {
//     final db = await instance.database;
//     return await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
//   }

//   Future close() async {
//     final db = await instance.database;
//     db.close();
//   }
// }
