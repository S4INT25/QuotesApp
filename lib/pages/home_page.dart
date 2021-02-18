import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quotes_app/data/models/quote.dart';
import 'package:quotes_app/utils/my_custom_exceptions.dart';
import 'package:quotes_app/viewModels/home_view_model.dart';
import 'package:quotes_app/widgets/animated_page_viewer.dart';

class HomePage extends StatelessWidget {
  final _viewModel = Get.put(HomeViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      return Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _viewModel.getQuotes(_viewModel.favoriteFilter.value),
              builder: (_, AsyncSnapshot<List<Quote>> snapshot) {
                print('${snapshot.connectionState.toString()}');
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  if (snapshot.data.isEmpty) {
                    return _buildErrorMessage(context, "No Quotes");
                  }
                  snapshot.data.shuffle();
                  return QuoteItemsPagesViewer(snapshot.data);
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasError) {
                  return handleErrors(snapshot, context);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          _buildNavBar(),
        ],
      );
    }));
  }

  Widget handleErrors(
      AsyncSnapshot<List<Quote>> snapshot, BuildContext context) {
    switch (snapshot.error) {
      case CustomHttpException:
        return _buildErrorMessage(context, CustomHttpException().toString());
        break;
      case DatabaseReadException:
        return _buildErrorMessage(context, DatabaseReadException().toString());
        break;
      case DatabaseWriteException:
        return _buildErrorMessage(context, DatabaseWriteException().toString());
        break;
      case NoInternetException:
        return _buildErrorPage();
        break;
    }
    return _buildErrorMessage(context, "Some thing went wrong");
  }

  //build functions
  Widget _buildErrorMessage(BuildContext context, String message) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        style:
            Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),
      ),
    ));
  }

  Widget _buildErrorPage() {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.black87,
      primary: Colors.grey[300],
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/1_No Connection.png",
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 100,
          left: 30,
          child: TextButton(
            style: raisedButtonStyle,
            onPressed: () {
              _viewModel.favoriteFilter.value =
                  !_viewModel.favoriteFilter.value;
            },
            child: Text("Retry".toUpperCase()),
          ),
        )
      ],
    );
  }

  Widget _buildButton(String title, IconData icon, bool tag) {
    return TextButton.icon(
      icon: Icon(icon),
      label: Text(title),
      onPressed: () {
        if (tag) {
          _viewModel.favoriteFilter.value = true;
          _viewModel.activeTab.value = true;
        } else {
          _viewModel.favoriteFilter.value = false;
          _viewModel.activeTab.value = false;
        }
      },
    );
  }

  Widget _buildNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
            'All',
            _viewModel.activeTab.value
                ? Icons.format_quote_outlined
                : Icons.format_quote,
            false),
        _buildButton(
            'Favourite',
            _viewModel.activeTab.value
                ? Icons.favorite_outlined
                : Icons.favorite_outline_outlined,
            true)
      ],
    );
  }
}
