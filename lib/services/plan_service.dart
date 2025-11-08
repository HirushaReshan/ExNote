import 'package:sqflite/sqflite.dart';
import 'package:exnote/models/plan.dart'; // Ensure Plan model has toJson/fromJson
import 'package:exnote/models/plan_item.dart'; // Ensure PlanItem model has toJson/fromJson
import 'package:exnote/services/database_service.dart';

class PlanService {
  final DatabaseService _dbService;
  final String _planTable = 'plans';
  final String _itemTable = 'plan_items';

  PlanService(this._dbService);

  // ======================
  // === PLAN CRUD (Parent) ===
  // ======================

  // --- CREATE PLAN ---
  Future<int> createPlan(Plan plan) async {
    final db = await _dbService.database;

    // Deactivate all others if the new plan is set to active (should be done in provider, but added here for safety)
    if (plan.isActive) {
      await db.update(_planTable, {'isActive': 0});
    }

    final id = await db.insert(
      _planTable,
      plan.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  // --- READ ALL PLANS ---
  Future<List<Plan>> readAllPlans() async {
    final db = await _dbService.database;
    final result = await db.query(_planTable, orderBy: 'startDate DESC');
    return result.map((json) => Plan.fromJson(json)).toList();
  }

  // --- READ ACTIVE PLAN ---
  Future<Plan?> readActivePlan() async {
    final db = await _dbService.database;
    final result = await db.query(
      _planTable,
      where: 'isActive = ?',
      whereArgs: [1], // 1 represents TRUE in SQLite boolean storage
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Plan.fromJson(result.first);
    }
    return null;
  }

  // --- UPDATE PLAN ---
  Future<int> updatePlan(Plan plan) async {
    final db = await _dbService.database;

    // If we're activating this plan, deactivate all others first
    if (plan.isActive && plan.id != null) {
      await db.update(
        _planTable,
        {'isActive': 0},
        // We only update plans that are not the current one, to be safe, though a simple update would often suffice.
        where: 'id != ?',
        whereArgs: [plan.id],
      );
    }

    return await db.update(
      _planTable,
      plan.toJson(),
      where: 'id = ?',
      whereArgs: [plan.id],
    );
  }

  // --- DELETE PLAN ---
  Future<int> deletePlan(int id) async {
    final db = await _dbService.database;
    // Note: 'ON DELETE CASCADE' in the database schema handles the deletion of associated plan items.
    return await db.delete(_planTable, where: 'id = ?', whereArgs: [id]);
  }

  // =======================
  // === PLAN ITEM CRUD (Child) ===
  // =======================

  // --- CREATE PLAN ITEM ---
  Future<int> createPlanItem(PlanItem item) async {
    final db = await _dbService.database;
    final id = await db.insert(
      _itemTable,
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  // --- READ ITEMS FOR A PLAN ---
  Future<List<PlanItem>> readPlanItems(int planId) async {
    final db = await _dbService.database;
    final result = await db.query(
      _itemTable,
      where: 'planId = ?',
      whereArgs: [planId],
      orderBy: 'displayOrder ASC',
    );
    return result.map((json) => PlanItem.fromJson(json)).toList();
  }

  // --- UPDATE PLAN ITEM ---
  Future<int> updatePlanItem(PlanItem item) async {
    final db = await _dbService.database;
    return await db.update(
      _itemTable,
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  // --- DELETE PLAN ITEM ---
  Future<int> deletePlanItem(int id) async {
    final db = await _dbService.database;
    return await db.delete(_itemTable, where: 'id = ?', whereArgs: [id]);
  }
}
