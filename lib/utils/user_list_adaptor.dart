import 'package:hive/hive.dart';
import 'package:quotes_app/data/models/quote.dart';

class QuoteAdaptor extends TypeAdapter<Quote> {
  @override
  Quote read(BinaryReader reader) {
    return Quote(
        id: reader.read(),
        author: reader.read(),
        text: reader.read(),
        color: reader.read(),
        isFavourite: reader.read());
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, Quote obj) {
    writer.write(obj.id);
    writer.write(obj.author);
    writer.write(obj.text);
    writer.write(obj.color);
    writer.write(obj.isFavourite);
  }
}
