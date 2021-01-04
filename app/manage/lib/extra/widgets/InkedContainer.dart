import 'package:flutter/material.dart';

class InkedContainer extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final double circularity;
  final Color color;

  const InkedContainer(
      {Key key,
      this.circularity = 5,
      this.color,
      @required this.child,
      @required this.onTap})
      : assert(child != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      enableFeedback: false,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(circularity),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(circularity),
        ),
        margin: EdgeInsets.all(circularity),
        child: child,
      ),
    );
  }
}
