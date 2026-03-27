class Task {
  int? id;
  int projectId;  // Foreign Key
  String title;
  String priority; //high, medium, low
  String deadline;
  int isCompleted; // o == panding or 1 == done

  Task({
    this.id,
    required this.projectId,
    required this.title,
    required this.priority,
    required this.deadline,
    required this.isCompleted,
  });
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'project_id': projectId,
      'title': title,
      'priority': priority,
      'deadline': deadline,
      'isCompleted': isCompleted,
    };
  }
  factory Task.fromMap(Map<String, dynamic> map){
    return Task(
      id: map['id'],
      projectId: map['project_id'],
      title: map['title'],
      priority: map['priority'],
      deadline: map['deadline'],
      isCompleted: map['isCompleted'],
    );
  }
}
