import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  String usersTable = 'users';
  String colId = 'id';
  String colUsername = 'username';
  String colPassword = 'password';

  Future<Database> get db async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $usersTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colUsername TEXT, $colPassword TEXT)',
    );
  }

  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.db;
    return await db.insert(usersTable, row);
  }

  Future<Map<String, dynamic>?> getUser(
      String username, String password) async {
    Database db = await instance.db;
    List<Map<String, dynamic>> result = await db.query(
      usersTable,
      where: '$colUsername = ? AND $colPassword = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
