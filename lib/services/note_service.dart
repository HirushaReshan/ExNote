import 'package:sqflite/sqflite.dart';
import 'package:exnote/models/note.dart';
import 'package:exnote/services/database_service.dart';

class NoteService {
  final DatabaseService _dbService;
  final String _tableName = 'notes';

  NoteService(this._dbService);

  // --- CREATE (Insert) ---
  Future<int> create(Note note) async {
    final db = await _dbService.database;
    final id = await db.insert(
      _tableName,
      note.toJson(), // Uses the toJson() method from the Note model
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  // --- READ ALL (Query) ---
  Future<List<Note>> readAllNotes() async {
    final db = await _dbService.database;
    final result = await db.query(_tableName, orderBy: 'date DESC');
    // Uses the fromJson() factory constructor from the Note model
    return result.map((json) => Note.fromJson(json)).toList();
  }

  // --- UPDATE ---
  Future<int> update(Note note) async {
    final db = await _dbService.database;
    return await db.update(
      _tableName,
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // --- DELETE ---
  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
