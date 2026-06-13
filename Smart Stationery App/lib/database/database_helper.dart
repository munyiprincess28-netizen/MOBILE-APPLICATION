import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/stationery_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'stationery.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE stationery_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        description TEXT,
        dateAdded TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertItem(StationeryItem item) async {
    Database db = await database;
    return await db.insert('stationery_items', item.toMap());
  }

  Future<List<StationeryItem>> getAllItems() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stationery_items',
      orderBy: 'dateAdded DESC',
    );
    return List.generate(maps.length, (i) {
      return StationeryItem.fromMap(maps[i]);
    });
  }

  Future<int> updateItem(StationeryItem item) async {
    Database db = await database;
    return await db.update(
      'stationery_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    Database db = await database;
    return await db.delete(
      'stationery_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getTotalItemsCount() async {
    Database db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM stationery_items');
    return result.first['count'] as int;
  }

  Future<double> getTotalInventoryValue() async {
    Database db = await database;
    final result = await db.rawQuery('SELECT SUM(quantity * price) as total FROM stationery_items');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}