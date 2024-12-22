
class Owner {
  final String name;
  final String bio;
  final String image;

  Owner({
    required this.name,
    required this.bio,
    required this.image,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      name: json['name'],
      bio: json['bio'],
      image: json['image'],
    );
  }
}
