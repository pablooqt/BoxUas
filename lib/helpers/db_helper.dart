import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../model/user_model.dart';
import '../model/review_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await databaseFactory.getDatabasesPath();
    final path = '$dbPath/user.db';

    return await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT,
            password TEXT,
            profile_picture TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS reviews (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            movie_id INTEGER,
            title TEXT,
            poster_url TEXT,
            review TEXT,
            rating REAL
          )
        ''');
      },
    ));
  }

  // ================= USER =================
  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert('users', user.toMap());
  }

  Future<void> updateUser(UserModel user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<UserModel?> getUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  // ================= REVIEW =================
  Future<void> insertReview(ReviewModel review) async {
    final db = await database;
    await db.insert('reviews', review.toMap());
  }

  Future<List<ReviewModel>> getReviewsByUser(int userId) async {
    final db = await database;
    final result = await db.query(
      'reviews',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );

    return result.map((e) => ReviewModel.fromMap(e)).toList();
  }

  Future<List<ReviewModel>> getReviewsByMovie(int movieId) async {
    final db = await database;
    final result = await db.query(
      'reviews',
      where: 'movie_id = ?',
      whereArgs: [movieId],
      orderBy: 'id DESC',
    );

    return result.map((e) => ReviewModel.fromMap(e)).toList();
  }
}
