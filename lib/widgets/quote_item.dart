import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app/data/models/quote.dart';
import 'package:quotes_app/data/repository/get_quotes_repository.dart';
import 'package:quotes_app/utils/colour_converter.dart';
import 'package:quotes_app/utils/custom_curve.dart';

enum AnimationTypes {
  TAP,
  LONG_PRESS,
}

class QuoteItem extends StatefulWidget {
  final Quote quote;
  final bool isActive;
  final List<Quote> quotes;

  QuoteItem(this.quote, this.isActive, this.quotes);

  @override
  _QuoteItemState createState() => _QuoteItemState();
}

class _QuoteItemState extends State<QuoteItem>
    with SingleTickerProviderStateMixin {
  bool favouriteTracker;
  AnimationController _controller;
  var animationState = 1;
  AnimationTypes type;

  @override
  void initState() {
    super.initState();
    favouriteTracker = widget.quote.isFavourite;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // Animated Properties
    final double blur = widget.isActive ? 20 : 0;
    final double offset = widget.isActive ? 20 : 0;
    final double top = widget.isActive ? 100 : 200;

    return ScaleTransition(
      scale: _animationSelector(type),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: HexColor.fromHex(widget.quote.color).withOpacity(1.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black87,
                  blurRadius: blur,
                  offset: Offset(offset, offset))
            ]),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _playAnimation(AnimationTypes.TAP);
          },
          onLongPress: () async {
            _playAnimation(AnimationTypes.LONG_PRESS);
            _updateQuote(!widget.quote.isFavourite, widget.quote);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(children: [
              //show favourite icon when quote is favourite
              if (favouriteTracker)
                Positioned(
                    right: 1,
                    child: Icon(
                      Icons.favorite_outlined,
                      color: Colors.pink,
                    )),
              _buildQuoteContainer(context),
            ]),
          ),
        ),
      ),
    );
  }

  Column _buildQuoteContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Center(
              child: Text(
            widget.quote.text == null ? "" : widget.quote.text,
            style: Theme.of(context).textTheme.headline6,
          )),
        ),
        Text(
          widget.quote.author == null ? "Unknown" : widget.quote.author,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }

  _updateQuote(bool isFavourite, Quote quote) async {
    var temp = Quote(
      id: quote.id,
      text: quote.text,
      author: quote.author,
      isFavourite: isFavourite,
      color: quote.color,
    );
    quote = temp;
    var result = await QuotesRepository().updateQuote(quote);
    if (result) {
      //update the local value in memory value in memory
      widget.quotes[widget.quotes
          .indexWhere((element) => element.id == widget.quote.id)] = quote;
      setState(() {
        favouriteTracker = !favouriteTracker;
      });
    }
  }

  Animation<double> _animationSelector(AnimationTypes type) {
    switch (type) {
      case AnimationTypes.TAP:
        return Tween<double>(begin: 0.8, end: 1.1).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeIn));
        break;
      case AnimationTypes.LONG_PRESS:
        return Tween(begin: 0.8, end: 1.0)
            .animate(CurvedAnimation(parent: _controller, curve: SineCurve()));
    }
    return Tween(begin: 0.8, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: SineCurve()));
  }

  _playAnimation(AnimationTypes animationType) {
    setState(() {
      type = animationType;
    });
    if (animationState == 1) {
      _controller.forward();
      animationState = 2;
    } else {
      _controller.reverse();
      animationState = 1;
    }
  }

  @override
  void dispose() {
    super.dispose();
    this._controller.dispose();
  }
}
