import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

class CustomProgressView extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;

  Widget progressIndicator;
  final Offset offset;
  final bool dismissible;
  final Widget child;

  CustomProgressView({
    Key key,
    @required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.progressIndicator,
    this.offset,
    this.dismissible = false,
    this.child,
  })  : assert(inAsyncCall != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];

    if (child != null) {
      widgetList.add(child);
    }
    if (inAsyncCall) {
      Widget layOutProgressIndicator;
      if (offset == null) {
        progressIndicator = CircularProgressIndicator();
        layOutProgressIndicator = Center(child: progressIndicator);
      } else {
        layOutProgressIndicator = Positioned(
          child: progressIndicator,
          left: offset.dx,
          top: offset.dy,
        );
      }
      final modal = [
        new Opacity(
          child: new ModalBarrier(dismissible: dismissible, color: color),
          opacity: opacity,
        ),
        layOutProgressIndicator
      ];
      widgetList += modal;
    }
    return new Stack(
      children: widgetList,
    );
  }
}
