import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HandledFutureBuilder<T> extends FutureBuilder {
  HandledFutureBuilder({
    Key key,
    Future<T> future,
    Widget Function(dynamic) onSuccess,
    T initialData,
  }) : super(
            key: key,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error),
                  );
                }
                return onSuccess(snapshot.data);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
            future: future,
            initialData: initialData);
}
