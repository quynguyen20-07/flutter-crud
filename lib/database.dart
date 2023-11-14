import 'package:crud_fltter/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'dart:developer' as developer;

class DbSQLite {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, "Todo_db");

    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    await db.execute(
      'CREATE TABLE mytodo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, desc TEXT NOT NULL, datetime TEXT NOT NULL)',
    );
  }

  Future<TodoModel> insert(TodoModel todoModel) async {
    var dbClient = await db;

    await dbClient?.insert('mytodo', todoModel.toMap());
    return todoModel;
  }

  Future<List<TodoModel>> getDataList() async {
    await db;
    final List<Map<String, Object?>> QueryResult =
        await _db!.rawQuery('SELECT * FROM mytodo');
    return QueryResult.map((e) => TodoModel.fromMap(e)).toList();
  }

  Future<int> updateData(TodoModel todoModel) async {
    var dbClient = await db;
    return await dbClient!.update('mytodo', todoModel.toMap(),
        where: 'id = ?', whereArgs: [todoModel.id]);
  }

  Future<void> deleteData(int id) async {
    var dbClient = await db;
    developer.log('$id', name: 'my.app.category');

    try {
      await dbClient!.delete('mytodo', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw FormatException(e.toString());
    }
  }

  // static Future<int> createData(String title, String? desc) async {
  //   final db = await DbSQLite.db();

  //   final data = {"title": title, "desc": desc};
  //   final id = await db.insert("data", data,
  //       conflictAlgorithm: sql.ConflictAlgorithm.replace);
  //   return id;
  // }

  //  Future<List<Map<String, dynamic>>> getSingleData(int id) async {
  //   final db = await DbSQLite.db();
  //   return await db.query('data', where: 'id = ?', whereArgs: [id]);
  // }
}
