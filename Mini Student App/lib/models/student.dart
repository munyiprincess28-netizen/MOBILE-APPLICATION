class Student {
  int? id;
  String name;
  String regNumber;
  String course;
  int age;
  String phone;
  String dateRegistered;

  Student({
    this.id,
    required this.name,
    required this.regNumber,
    required this.course,
    required this.age,
    required this.phone,
    required this.dateRegistered,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'regNumber': regNumber,
      'course': course,
      'age': age,
      'phone': phone,
      'dateRegistered': dateRegistered,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      regNumber: map['regNumber'],
      course: map['course'],
      age: map['age'],
      phone: map['phone'],
      dateRegistered: map['dateRegistered'],
    );
  }
}