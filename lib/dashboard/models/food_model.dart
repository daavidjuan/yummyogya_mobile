class Food {
  final int id;
  final String name;
  final int price;
  final String description;
  final String category;
  final String restaurant;
  final double rating;
  final String imageUrl;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.restaurant,
    required this.rating,
    required this.imageUrl,
  });

  // Factory method untuk parsing JSON dari API Django
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      category: json['category'],
      restaurant: json['restaurant'],
      rating: json['rating'].toDouble(),
      imageUrl: json['image_url'],
      // createdBy: json['created_by'],
    );
  }

  // Method untuk mengonversi ke JSON (misalnya untuk mengirim data ke API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'restaurant': restaurant,
      'rating': rating,
      'image_url': imageUrl,
      // 'created_by': createdBy,
    };
  }
}
