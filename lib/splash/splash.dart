import 'package:flutter/material.dart';

typedef SplashBuilder<T> = Widget Function(BuildContext context, T value);

class Splash<T> extends StatefulWidget {
  final Future<T> future;
  final T defaultValue;
  final SplashBuilder<T> builder;

  const Splash({
    super.key,
    required this.future,
    required this.defaultValue,
    required this.builder,
  });

  @override
  State<Splash<T>> createState() => _Splash<T>();
}

class _Splash<T> extends State<Splash<T>> {
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
          return widget.builder(context, snapshot.data as T);
        } else {
          return widget.builder(context, widget.defaultValue);
        }
      },
    );
  }
}
