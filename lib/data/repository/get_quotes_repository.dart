import 'package:hive/hive.dart';
import 'package:quotes_app/data/models/quote.dart';
import 'package:quotes_app/data/services/local_quote_service.dart';
import 'package:quotes_app/data/services/remote_quote_service.dart';

class QuotesRepository {
  Future<List<Quote>> getAllQuotes([bool favorite = false]) async {
    final quoteBox = Hive.box('QuotesBox');
    List<Quote> myQuotes = [];
    /**
     *  check for data in local storage and return it if available
     *  else get data from remote database and cache it
     *  then return the cached data
     */
    if (quoteBox.isEmpty) {
      //get quotes from remote database
      final quotes = await RemoteQuoteService.getQuotes();
      if (quotes.isNotEmpty) {
        //save quotes to local database
        final result = await LocalQuoteService.addQuotes(quotes);
        if (result) {
          //get favourite quotes
          if (favorite) {
            myQuotes = await LocalQuoteService.getFavouriteQuotes();
          }
          //get all quotes from local database
          myQuotes = await LocalQuoteService.getAllQuotes();
        }
      }
    } else {
      //get favourite quotes
      if (favorite) {
        myQuotes = await LocalQuoteService.getFavouriteQuotes();
      } else {
        myQuotes = await LocalQuoteService.getAllQuotes();
      }
    }
    return Future.value(myQuotes);
  }

  Future<bool> updateQuote(Quote quote) async {
    return LocalQuoteService.updateQuote(quote);
  }
}
