import 'package:flutter/material.dart';

class WideCardButton extends StatelessWidget {
  final Widget child;
  final Function onTap;

  const WideCardButton({
    Key key,
    @required this.child,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 38,
          maxWidth: 280,
        ),
        child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              enableFeedback: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
            child: Center(child: child)),
      ),
    );
  }
}
