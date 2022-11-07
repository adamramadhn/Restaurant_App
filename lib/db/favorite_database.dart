import 'package:sqflite/sqflite.dart';

import '../models/favorite_model.dart';

class FavDatabase {
  static final FavDatabase instance = FavDatabase._init();

  static Database? _database;

  FavDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('favorite_resto.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath$filePath';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    await db.execute('''
CREATE TABLE $tableFav (${FavoriteFields.idDB} $idType,${FavoriteFields.idResto} $textType ,${FavoriteFields.restoName} $textType,${FavoriteFields.city} $textType,${FavoriteFields.rating} $textType, ${FavoriteFields.url} $textType)
''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<FavRestoModel> create(FavRestoModel note) async {
    final db = await instance.database;
    final json = note.toJson();
    final id = await db.insert(tableFav, json,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return note.copy(idDb: id);
  }

  Future<List<FavRestoModel>?> readAllFavorite() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT * FROM $tableFav');
    if (result.isEmpty) {
      return null;
    } else {
      return result.map((json) => FavRestoModel.fromJson(json)).toList();
    }
  }

  Future<int> delete(String id) async {
    final db = await instance.database;
    return await db.delete(tableFav,
        where: '${FavoriteFields.idResto} = ?', whereArgs: [id]);
  }
}
