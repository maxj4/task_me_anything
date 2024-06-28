class Task {
  final int? id;
  final String content;
  final bool isDone;
  final int timeSpentInMinutes;

  Task({
    this.id,
    required this.content,
    this.isDone = false,
    this.timeSpentInMinutes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'isDone': isDone ? 1 : 0,
      'timeSpentInMinutes': timeSpentInMinutes,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      content: map['content'],
      isDone: map['isDone'] == 1,
      timeSpentInMinutes: map['timeSpentInMinutes'],
    );
  }

  Task copyWith({
    int? id,
    String? content,
    bool? isDone,
    int? timeSpentInMinutes,
  }) {
    return Task(
      id: id ?? this.id,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
      timeSpentInMinutes: timeSpentInMinutes ?? this.timeSpentInMinutes,
    );
  }
}
