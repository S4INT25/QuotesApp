import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app/data/models/quote.dart';
import 'package:quotes_app/widgets/quote_item.dart';

class QuoteItemsPagesViewer extends StatefulWidget {
  final List<Quote> quotes;

  QuoteItemsPagesViewer(this.quotes);

  @override
  _QuoteItemsPagesViewerState createState() => _QuoteItemsPagesViewerState();
}

class _QuoteItemsPagesViewerState extends State<QuoteItemsPagesViewer> {
  final _pageController = PageController(viewportFraction: 0.8);

  //keep track of current page
  int currentPage = 0;

  @override
  void initState() {
    _pageController.addListener(() {
      //get the current page position
      //_controller.page() return a fraction of the page which later on is converted to int
      int next = _pageController.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: widget.quotes.length,
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, int currentIndex) {
              if (widget.quotes.length >= currentIndex) {
                //set current page to active
                bool isActive = currentIndex == currentPage;
                return QuoteItem(
                    widget.quotes[currentIndex], isActive, widget.quotes);
              } else {
                return SizedBox();
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //show go back button
            if (currentPage >= 3)
              _buildNavigatorButtons(
                  0, Icons.arrow_back_ios_outlined, Curves.easeIn),
            _buildNavigatorButtons(math.Random().nextInt(widget.quotes.length),
                Icons.shuffle, Curves.easeInOut)
          ],
        )
      ],
    );
  }

  Widget _buildNavigatorButtons(int position, IconData icon, Curve curve) {
    return IconButton(
        icon: Icon(icon),
        onPressed: () {
          _pageController.animateToPage(position,
              duration: Duration(milliseconds: 500), curve: curve);
        });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
