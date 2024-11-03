class Employee {
  String id;
  String name;
  String role;
  String email;
  String contactNumber;
  int presentCount;
  int absentWithLeaveCount;
  int absentWithoutLeaveCount;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.contactNumber,
    this.presentCount = 0,
    this.absentWithLeaveCount = 0,
    this.absentWithoutLeaveCount = 0,
  });
}
