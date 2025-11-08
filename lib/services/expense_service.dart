import 'package:sqflite/sqflite.dart';
import 'package:exnote/models/expense.dart';
import 'package:exnote/services/database_service.dart';

class ExpenseService {
  final DatabaseService _dbService;
  // Define the table name for clarity and safety
  final String _tableName = 'expenses';

  // Constructor receives the initialized database service instance
  ExpenseService(this._dbService);

  // --- 1. CREATE (Insert) ---
  Future<int> create(Expense expense) async {
    final db = await _dbService.database;

    // Insert the expense data. Assumes Expense model has toJson()
    final id = await db.insert(
      _tableName,
      expense.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  // --- 2. READ ALL (Query) ---
  Future<List<Expense>> readAllExpenses() async {
    final db = await _dbService.database;

    // Retrieve all rows, ordered by date (most recent first)
    final result = await db.query(
      _tableName,
      orderBy:
          'date DESC', // Assuming 'date' is a TEXT column storing sortable strings
    );

    // Convert List<Map<String, dynamic>> to List<Expense>
    return result.map((json) => Expense.fromJson(json)).toList();
  }

  // --- 3. UPDATE ---
  Future<int> update(Expense expense) async {
    final db = await _dbService.database;

    // Update the row where the id matches the expense's id
    return await db.update(
      _tableName,
      expense.toJson(),
      where: 'id = ?',
      whereArgs: [expense.id], // Use whereArgs to prevent SQL injection
    );
  }

  // --- 4. DELETE ---
  Future<int> delete(int id) async {
    final db = await _dbService.database;

    // Delete the row with the matching id
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
