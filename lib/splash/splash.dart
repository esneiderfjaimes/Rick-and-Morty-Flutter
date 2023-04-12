import 'package:flutter/material.dart';

typedef SplashBuilder<R> = Widget Function(BuildContext context, R value);
typedef Transform<T, R> = R Function(T value);

class Splash<T, R> extends StatefulWidget {
  final Future<T> future;
  final R defaultValue;
  final Transform<T, R> transform;
  final SplashBuilder<R> builder;

  const Splash({
    super.key,
    required this.future,
    required this.defaultValue,
    required this.transform,
    required this.builder,
  });

  @override
  State<Splash<T, R>> createState() => _Splash<T, R>();
}

class _Splash<T, R> extends State<Splash<T, R>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: widget.future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: const Image(
              image: AssetImage('assets/images/icon.png'),
              width: 200,
              height: 200,
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return widget.builder(context, widget.transform(snapshot.data as T));
        } else {
          return widget.builder(
              context, widget.transform(widget.defaultValue as T));
        }
      },
    );
  }
}
