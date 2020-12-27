import 'package:flutter/material.dart';

class InkedContainer extends StatelessWidget {
  final Widget child;
  final Function onTap;

  const InkedContainer({Key key, @required this.child, @required this.onTap})
      : assert(child != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      enableFeedback: false,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(5),
          ),
        margin: const EdgeInsets.all(5),
        child: child,
      ),
    );
  }
}
