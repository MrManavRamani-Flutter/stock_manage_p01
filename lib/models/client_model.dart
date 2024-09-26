class Client {
  final String clientName;
  final String email;
  final String imageUrl;
  final String? shopAddress;

  Client({
    required this.clientName,
    required this.email,
    required this.imageUrl,
    this.shopAddress,
  });
}
