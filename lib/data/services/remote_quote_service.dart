import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:quotes_app/data/models/quote.dart';
import 'package:quotes_app/utils/my_custom_exceptions.dart';

class RemoteQuoteService {
  static Future<List<Quote>> getQuotes() async {
    String url = 'https://type.fit/api/quotes';
    final client = http.Client();
    List<Quote> remoteQuotes = [];
    try {
      final response = await client.get(url);
      /*
      * checking for response status code
      * if status code ranges from 100 < 400 it means are connection established with the server
      * */
      if (response.statusCode == 200) {
        remoteQuotes = quoteFromJson(response.body);
      } else {
        return Future.error(DatabaseWriteException);
      }
    } on SocketException {
      return Future.error(NoInternetException);
    } catch (exception) {
      return Future.error(exception);
    } finally {
      client.close();
    }
    return Future.value(remoteQuotes);
  }
}
