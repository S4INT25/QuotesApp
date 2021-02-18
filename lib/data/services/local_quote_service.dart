import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quotes_app/data/models/quote.dart';
import 'package:quotes_app/utils/colour_converter.dart';
import 'package:quotes_app/utils/my_custom_exceptions.dart';

class LocalQuoteService {
  static Future<bool> addQuotes(List<Quote> quotes) async {
    final quoteBox = Hive.box('QuotesBox');
    var completed = false;
    try {
      //clear the box first
      await quoteBox.clear();
      var id = 0;
      quotes.forEach((quote) {
        //add color
        var randomColor =
            Color((math.Random().nextDouble() * 0xFFFFFF).toInt());
        var myQuote = Quote(
            id: id,
            author: quote.author,
            text: quote.text,
            color: randomColor.toHex(),
            isFavourite: false);
        quoteBox.add(myQuote);
        id++;
      });
      completed = true;
    } catch (e) {
      return Future.error(DatabaseWriteException);
    }
    return Future.value(completed);
  }

  static Future<List<Quote>> getAllQuotes() {
    final quoteBox = Hive.box('QuotesBox');
    List<Quote> quotes = [];
    try {
      //hive return a map of type {id,value<Quote>}
      //in this case i'm interested in the value
      final data = quoteBox.toMap().values.toList();
      if (data.isNotEmpty) {
        quotes = convertToList(data);
      }
    } catch (e) {
      return Future.error(DatabaseReadException);
    }
    return Future.value(quotes);
  }

  static List<Quote> convertToList(List<dynamic> data) {
    return data.map((e) {
      final quote = e as Quote;
      return Quote(
          id: quote.id,
          author: quote.author,
          text: quote.text,
          color: quote.color,
          isFavourite: quote.isFavourite);
    }).toList();
  }

  static Future<bool> updateQuote(Quote quote) async {
    final quoteBox = Hive.box('QuotesBox');
    var hasCompleted = false;
    try {
      await quoteBox.put(quote.id, quote);
      hasCompleted = true;
    } catch (e) {
      return Future.error(DatabaseWriteException);
    }
    return Future.value(hasCompleted);
  }

  static Future<List<Quote>> getFavouriteQuotes() async {
    final quoteBox = Hive.box('QuotesBox');
    List<Quote> quotes = [];
    try {
      var data = quoteBox.toMap().values.toList();
      if (data.isNotEmpty) {
        quotes = convertToList(data)
            .where((element) => element.isFavourite)
            .toList();
      }
    } catch (e) {
      return Future.error(DatabaseReadException);
    }

    return Future.value(quotes);
  }
}
