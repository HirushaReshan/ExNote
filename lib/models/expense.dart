// lib/models/expense.dart (FIXED)
class Expense {
  final int? id; 
  final String name;
  final double amount; // Corrected: Must be double
  final String category;
  final DateTime date;
  final String? description;

  Expense({
    this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });

  // --- 1. toJson (WRITE to DB) ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'category': category,
      // Store date as ISO 8601 string (TEXT) for sorting/retrieval
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  // --- 2. fromJson (READ from DB) ---
  // FIX: Safely cast the 'amount' from dynamic (int or double) to double.
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as int?,
      name: json['name'] as String,
      // FIX HERE: Use .toDouble() after casting to num to handle int or double from DB
      amount: (json['amount'] as num).toDouble(), 
      category: json['category'] as String,
      // Parse the stored TEXT date string back into a DateTime object
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
    );
  }

  // --- 3. copyWith (STATE MANAGEMENT HELPER) ---
  Expense copyWith({
    int? id,
    String? name,
    double? amount,
    String? category,
    DateTime? date,
    String? description,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}