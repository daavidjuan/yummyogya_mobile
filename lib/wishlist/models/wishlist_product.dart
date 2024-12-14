// lib/wishlist/models/wishlist_product.dart
import 'dart:convert';

List<WishlistProduct> wishlistProductFromJson(String str) => 
    List<WishlistProduct>.from(json.decode(str).map((x) => WishlistProduct.fromJson(x)));

String wishlistProductToJson(List<WishlistProduct> data) => 
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WishlistProduct {
    int id;
    String nama;
    int harga;
    String deskripsi;
    String rating;
    String gambar;

    WishlistProduct({
        required this.id,
        required this.nama,
        required this.harga,
        required this.deskripsi,
        required this.rating,
        required this.gambar,
    });

    factory WishlistProduct.fromJson(Map<String, dynamic> json) => WishlistProduct(
        id: json["id"],
        nama: json["nama"],
        harga: json["harga"],
        deskripsi: json["deskripsi"],
        rating: json["rating"],
        gambar: json["gambar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "harga": harga,
        "deskripsi": deskripsi,
        "rating": rating,
        "gambar": gambar,
    };
}