class Employee {
  final String name;
  final String role;
  final String imageUrl;
  final String email;
  final String contactNumber;
  final int presentCount;
  final int absentWithLeaveCount;
  final int absentWithoutLeaveCount;

  Employee({
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.email,
    required this.contactNumber,
    required this.presentCount,
    required this.absentWithLeaveCount,
    required this.absentWithoutLeaveCount,
  });
}
