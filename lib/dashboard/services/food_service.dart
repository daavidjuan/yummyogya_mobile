import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchFoods() async {
  final response =
      await http.get(Uri.parse('http:///127.0.0.1:8000/dashboard/foods/'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((food) => food as Map<String, dynamic>).toList();
  } else {
    throw Exception('Failed to load foods ini gagal kah');
  }
}
