import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yummyogya_mobile/detail/components/add_review.dart';
import 'package:yummyogya_mobile/detail/components/detail_card.dart';
import 'package:yummyogya_mobile/detail/components/review_list.dart';
import 'package:yummyogya_mobile/models/makanan_entry.dart';

class DetailPage extends StatefulWidget {
  final Makanan makanan;
  final String username;

  const DetailPage({required this.makanan, required this.username, super.key});

  @override
  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  final String baseUrl = 'http://127.0.0.1:8000';
  Map<String, dynamic> foodData = {};
  List<dynamic> reviews = [];
  int selectedRating = 0;
  bool isSubmitting = false;
  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFoodDetails();
  }

  Future<void> fetchFoodDetails() async {
    final url = Uri.parse(
        '$baseUrl/details/details_flutter/?food_id=${widget.makanan.pk}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            foodData = data['data'];
            reviews = data['data']['reviews'] ?? [];
          });
        }
      }
    } catch (error) {
      showSnackbar('Terjadi kesalahan: $error');
    }
  }

  Future<void> submitReview() async {
    setState(() {
      isSubmitting = true;
    });

    final url = Uri.parse('$baseUrl/details/add_review_flutter/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'food_id': widget.makanan.pk,
          'username': widget.username,
          'rating': selectedRating,
          'review': reviewController.text,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201 && responseData['status'] == 'success') {
        showSnackbar(responseData['message']);
        fetchFoodDetails();
        reviewController.clear();
        setState(() {
          selectedRating = 0;
        });
      } else {
        showSnackbar(responseData['message'] ?? 'Terjadi kesalahan');
      }
    } catch (error) {
      showSnackbar('Gagal mengirim ulasan: $error');
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodData['name'] ?? 'Memuat...'),
        backgroundColor: Colors.orange,
      ),
      body: foodData.isNotEmpty
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailCard(foodData: foodData),
                    const SizedBox(height: 24),
                    AddReviewForm(
                      reviewController: reviewController,
                      selectedRating: selectedRating,
                      onRatingSelected: (rating) =>
                          setState(() => selectedRating = rating),
                      onSubmit: submitReview,
                      isLoading: isSubmitting,
                    ),
                    const SizedBox(height: 24),
                    ReviewList(reviews: reviews),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.orange)),
    );
  }
}
