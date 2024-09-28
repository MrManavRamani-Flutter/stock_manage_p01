class Client {
  final String id; // Unique identifier for the client
  final String clientName;
  final String email;
  final String contact;
  final String? imageUrl; // Nullable to allow for default avatar
  final String? shopAddress; // Nullable if no address is provided

  Client({
    required this.id,
    required this.clientName,
    required this.email,
    required this.contact,
    this.imageUrl,
    this.shopAddress,
  });
}
