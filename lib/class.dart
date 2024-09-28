class Pokemon {
  final String name;
  final String imageUrl;

  Pokemon({required this.name, required this.imageUrl});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final imageUrl = json['sprites']['front_default'];
    return Pokemon(
      name: name,
      imageUrl: imageUrl ?? 'default_image_url',  // Fallback if no image found
    );
  }
}