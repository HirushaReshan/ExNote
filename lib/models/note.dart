// lib/models/note.dart (Updated to use toJson/fromJson)

class Note {
  final int? id; // Changed to final for best practice
  final String title;
  final String content;
  final DateTime date;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  // Renamed to toJson()
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(), // Store date as ISO string
    };
  }

  // Renamed to fromJson()
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as int?,
      title: json['title'] as String,
      content: json['content'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Note copyWith({int? id, String? title, String? content, DateTime? date}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }
}
