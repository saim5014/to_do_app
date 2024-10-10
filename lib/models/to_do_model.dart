// ignore_for_file: camel_case_types

class task {
  int? id;
  int userid;
  String title;
  String? description;
  String date;
  int status;

  task({
    this.id,
    required this.userid,
    required this.title,
    this.description,
    required this.date,
    this.status = 0,
  });
  Map<String, Object?> tomap() {
    return {
      'id': id,
      'userid': userid,
      'title': title,
      'description': description,
      'date': date,
      'status': status,
    };
  }

  factory task.frommap(Map<String, Object?> map) {
    return task(
      id: map['id'] as int?,
      userid: map['userid'] as int,
      title: map['title'] as String,
      date: map['date'] as String,
      status: map['status'] as int,
      description: map['description'] as String,
    );
  }
}
