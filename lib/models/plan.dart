// lib/models/plan.dart (Updated to use toJson/fromJson)

enum PlanType { daily, weekly, monthly, custom }

class Plan {
  final int? id; // Changed to final
  final String name;
  final PlanType type;
  final double maxAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final bool isActive; // Changed to final

  Plan({
    this.id,
    required this.name,
    required this.type,
    required this.maxAmount,
    required this.startDate,
    required this.endDate,
    this.description,
    this.isActive = false,
  });

  // Renamed to toJson()
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name, // Using enum name (string) for storage
      'maxAmount': maxAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
      'isActive': isActive ? 1 : 0,
    };
  }

  // Renamed to fromJson()
  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] as int?,
      name: json['name'] as String,
      // Find the enum value matching the stored string name
      type: PlanType.values.firstWhere((e) => e.name == json['type'] as String),
      maxAmount: json['maxAmount'] as double,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      description: json['description'] as String?,
      isActive: json['isActive'] == 1,
    );
  }

  Plan copyWith({
    int? id,
    String? name,
    PlanType? type,
    double? maxAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isActive,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      maxAmount: maxAmount ?? this.maxAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
