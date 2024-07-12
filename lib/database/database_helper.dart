import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/appointment.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('appointments.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE appointments (
      id $idType,
      doctorName $textType,
      date $textType,
      address $textType
    )
    ''');
  }

  Future<Appointment> create(Appointment appointment) async {
    final db = await instance.database;

    final id = await db.insert('appointments', appointment.toMap());
    return appointment.copy(id: id);
  }

  Future<Appointment?> readAppointment(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'appointments',
      columns: ['id', 'doctorName', 'date', 'address'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Appointment.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Appointment>> readAllAppointments() async {
    final db = await instance.database;

    final result = await db.query('appointments');

    return result.map((json) => Appointment.fromMap(json)).toList();
  }

  Future<int> update(Appointment appointment) async {
    final db = await instance.database;

    return db.update(
      'appointments',
      appointment.toMap(),
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'appointments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  createUser(user) {}
}
