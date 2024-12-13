// To parse this JSON data, do
//
//     final foodEntry = foodEntryFromJson(jsonString);

import 'dart:convert';

List<FoodEntry> foodEntryFromJson(String str) =>
    List<FoodEntry>.from(json.decode(str).map((x) => FoodEntry.fromJson(x)));

String foodEntryToJson(List<FoodEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodEntry {
  final int id;
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final String restoran;
  final String kategori;
  final String rating;

  FoodEntry({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.restoran,
    required this.kategori,
    required this.rating,
  });

  factory FoodEntry.fromJson(Map<String, dynamic> json) {
    return FoodEntry(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['image_url'] ?? '',
      restoran: json['restaurant'] ?? '',
      kategori: json['category'] ?? '',
      rating: json['rating'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'restaurant': restoran,
      'category': kategori,
      'rating': rating,
    };
  }
}
