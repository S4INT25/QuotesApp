import 'dart:convert';

import 'package:meta/meta.dart';

List<Quote> quoteFromJson(String str) =>
    List<Quote>.from(json.decode(str).map((x) => Quote.fromJson(x)));

String quoteToJson(List<Quote> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Quote {
  Quote(
      {this.id,
      @required this.text,
      @required this.author,
      this.color,
      this.isFavourite});

  final int id;
  final String text;
  final String author;
  final String color;
  final bool isFavourite;

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        text: json["text"],
        author: json["author"] == null ? null : json["author"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "author": author == null ? null : author,
      };
}
