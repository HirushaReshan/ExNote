// lib/models/expense.dart (CONVENTIONALLY NAMED & IMMUTABLE READY)
class Expense {
  final int? id; // Use final for immutability
  final String name;
  final double amount;
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
  // Conventionally named 'toJson' to convert the object into a Map for storage.
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
  // Conventionally named 'fromJson' to create an object from a database Map.
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as int?,
      name: json['name'] as String,
      amount: json['amount'] as double,
      category: json['category'] as String,
      // Parse the stored TEXT date string back into a DateTime object
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
    );
  }

  // --- 3. copyWith (STATE MANAGEMENT HELPER) ---
  // Creates a new instance of Expense, allowing specific fields to be changed.
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
