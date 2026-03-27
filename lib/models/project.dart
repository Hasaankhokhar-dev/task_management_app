class Project {
  int? id;
  String title;
  String description;
  String deadline;
  String status;   // "active" or "completed"
  Project({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.status,
  });
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline,
      'status': status,
    };
  }
  factory Project.fromMap(Map<String, dynamic> map){
    return Project(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        deadline: map['deadline'],
        status: map['status'],
    );
  }
}
