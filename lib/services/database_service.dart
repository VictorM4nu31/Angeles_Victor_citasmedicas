import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../models/appointment.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT,
        firstName TEXT,
        lastName TEXT,
        middleName TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        doctor TEXT,
        date TEXT,
        address TEXT,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) {
      return User(
        id: maps.first['id'],
        username: maps.first['username'],
        password: maps.first['password'],
        firstName: maps.first['firstName'], // Campo añadido
        lastName: maps.first['lastName'],   // Campo añadido
        middleName: maps.first['middleName'], // Campo añadido
      );
    }
    return null;
  }

  Future<int> insertAppointment(Appointment appointment) async {
    Database db = await database;
    return await db.insert('appointments', appointment.toMap());
  }

  Future<List<Appointment>> getUserAppointments(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'appointments',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Appointment(
        id: maps[i]['id'],
        userId: maps[i]['userId'],
        doctor: maps[i]['doctor'],
        date: maps[i]['date'],
        address: maps[i]['address'],
      );
    });
  }

  Future<int> updateAppointment(Appointment appointment) async {
    Database db = await database;
    return await db.update(
      'appointments',
      appointment.toMap(),
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  Future<int> deleteAppointment(int id) async {
    Database db = await database;
    return await db.delete(
      'appointments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
