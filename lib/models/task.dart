class Task {
  final int? id;
  final String content;
  final bool isDone;
  // TODO: timeSpent

  Task({
    this.id,
    required this.content,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      content: map['content'],
      isDone: map['isDone'] == 1,
    );
  }

  Task copyWith({
    int? id,
    String? content,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
    );
  }
}
