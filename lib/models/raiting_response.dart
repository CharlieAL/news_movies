// To parse this JSON data, do
//
//     final rating = ratingFromMap(jsonString);

import 'dart:convert';

import 'package:news_movies/models/models.dart';

class Rating {
  Rating({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  factory Rating.fromJson(String str) => Rating.fromMap(json.decode(str));

  factory Rating.fromMap(Map<String, dynamic> json) => Rating(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
