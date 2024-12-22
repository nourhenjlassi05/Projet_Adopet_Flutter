class Dog {
  final String id;
  final String name;
  final double age;
  final String gender;
  final String color;
  final double weight;
  final String location;
  final String about;
  final String image;

  Dog({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.color,
    required this.weight,
    required this.location,
    required this.about,
    required this.image,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['_id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      color: json['color'],
      weight: json['weight'],
      location: json['location'],
      about: json['about'],
      image: json['image'],
    );
  }
}