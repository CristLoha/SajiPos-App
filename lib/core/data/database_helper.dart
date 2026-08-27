import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('saji_pos_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        categoryId INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price INTEGER NOT NULL,
        discountPrice INTEGER,
        isCampaignActive INTEGER NOT NULL,
        stock INTEGER NOT NULL,
        image TEXT NOT NULL,
        status INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        image TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE discounts (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        code TEXT NOT NULL,
        description TEXT,
        type TEXT NOT NULL,
        value REAL,
        minTransaction REAL,
        maxDiscount REAL,
        status TEXT NOT NULL,
        startDate TEXT NOT NULL,
        expiredDate TEXT NOT NULL
      )
    ''');

    await _createOrdersTables(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createOrdersTables(db);
    }
  }

  Future _createOrdersTables(Database db) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cashierId INTEGER NOT NULL,
        transactionTime TEXT NOT NULL,
        subTotal REAL NOT NULL,
        discountId INTEGER,
        discountAmount REAL NOT NULL,
        shippingCost REAL NOT NULL,
        serviceCharge REAL NOT NULL,
        tax REAL NOT NULL,
        total REAL NOT NULL,
        paymentMethod TEXT NOT NULL,
        isSynced INTEGER NOT NULL DEFAULT 0,
        serverId INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId INTEGER NOT NULL,
        productId INTEGER NOT NULL,
        productName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
