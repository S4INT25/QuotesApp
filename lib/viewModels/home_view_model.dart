import 'package:get/get.dart';
import 'package:quotes_app/data/models/quote.dart';
import 'package:quotes_app/data/repository/get_quotes_repository.dart';

class HomeViewModel extends GetxController {
  final _repository = QuotesRepository();

  var activeTab = false.obs;
  var favoriteFilter = false.obs;
  var addFavourite = false.obs;

  Future<List<Quote>> getQuotes([bool favourite = false]) {
    return _repository.getAllQuotes(favourite);
  }

  Future<bool> updateQuote(bool isFavourite, Quote quote) {
    var temp = Quote(
      id: quote.id,
      text: quote.text,
      author: quote.author,
      isFavourite: isFavourite,
      color: quote.color,
    );
    quote = temp;
    return _repository.updateQuote(quote);
  }
}
