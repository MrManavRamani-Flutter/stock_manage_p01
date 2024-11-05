class User {
  final String uId; // unique ID
  final String username; // unique username
  final String email;
  final String password;
  final String phone;
  final String role; // 'owner', 'admin', or 'guest'
  final int status; // 0 = not logged in, 1 = logged in
  final DateTime createdAt;

  User({
    required this.uId,
    required this.username,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
    required this.status,
    required this.createdAt,
  });
}
