import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quotes_app/pages/home_page.dart';
import 'package:quotes_app/theme/app_theme.dart';
import 'package:quotes_app/utils/user_list_adaptor.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(QuoteAdaptor());
  await Hive.openBox('QuotesBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeData,
      home: HomePage(),
    );
  }
}
