import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._constructor();
  static final DatabaseHelper instance = DatabaseHelper._constructor();

  static Database _db;
  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await _initialize();
    return _db;
  }

  Future<Database> _initialize() async {
    Directory _dir = await getApplicationDocumentsDirectory();
    String _path = join(_dir.path, "belajar.db"); // /ext/android/db/belajar.db
    return openDatabase(_path, onCreate: _onCreate, version: 1);
  }

  Future _onCreate(Database db, int versi) async {
    await db.execute('CREATE TABLE belajar (id INTEGER PRIMARY KEY, title TEXT, description TEXT, done INTEGER DEFAULT 0)');
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    Database db = await instance.database;
    return await db.query("belajar");
  }

  // Future<Map<String, dynamic>> getData(int id) async {
  //   Database db = await instance.database;
  //   return await db.query("belajar", where: 'id = ?', whereArgs: [id]);
  // }

  Future<int> insert(Map<String, dynamic> data) async {
    Database db = await instance.database;
    return await db.insert("belajar", data);
  }

  Future<int> update(Map<String, dynamic> data) async {
    Database db = await instance.database;
    int id = data['id'];
    return await db.update("belajar", data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete("belajar", where: 'id = ?', whereArgs: [id]);
  }
}