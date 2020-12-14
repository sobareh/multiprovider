import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Restaurant albumFromJson(String str) => Restaurant.fromJson(json.decode(str));

class Restaurant {
  Restaurant({
    @required this.error,
    @required this.message,
    @required this.count,
    @required this.restaurants,
  });

  bool error;
  String message;
  int count;
  List<RestaurantElement> restaurants;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<RestaurantElement>.from(
            json["restaurants"].map((x) => RestaurantElement.fromJson(x))),
      );

  static Future<dynamic> fetchRestaurant() async {
    final response = await http.get('https://restaurant-api.dicoding.dev/list');

    if (response.statusCode == 200) {
      return Restaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class RestaurantElement {
  RestaurantElement({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.pictureId,
    @required this.city,
    @required this.rating,
  });

  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  factory RestaurantElement.fromJson(Map<String, dynamic> json) =>
      RestaurantElement(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"].toDouble(),
      );
}
