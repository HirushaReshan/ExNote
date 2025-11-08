// lib/models/plan_item.dart (Updated to use toJson/fromJson)

class PlanItem {
  final int? id; // Changed to final
  final int planId;
  final String name;
  final double amount;
  final String? description;
  final bool isCompleted; // Changed to final
  final int displayOrder;

  PlanItem({
    this.id,
    required this.planId,
    required this.name,
    required this.amount,
    this.description,
    this.isCompleted = false,
    required this.displayOrder,
  });

  // Renamed to toJson()
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planId': planId,
      'name': name,
      'amount': amount,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0, // Store bool as 1 or 0
      'displayOrder': displayOrder,
    };
  }

  // Renamed to fromJson()
  factory PlanItem.fromJson(Map<String, dynamic> json) {
    return PlanItem(
      id: json['id'] as int?,
      planId: json['planId'] as int,
      name: json['name'] as String,
      amount: json['amount'] as double,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] == 1, // Read 1/0 as bool
      displayOrder: json['displayOrder'] as int,
    );
  }

  PlanItem copyWith({
    int? id,
    int? planId,
    String? name,
    double? amount,
    String? description,
    bool? isCompleted,
    int? displayOrder,
  }) {
    return PlanItem(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }
}
