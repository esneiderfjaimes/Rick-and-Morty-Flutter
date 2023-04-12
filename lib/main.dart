import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/theme/ThemeService.dart';
import 'package:rick_and_morty/theme/scaffold_theme_switch.dart';
import 'package:rick_and_morty/theme/theme_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FutureBuilder<ThemeService>(
    future: ThemeService.instance,
    builder: (BuildContext context, AsyncSnapshot<ThemeService> snapshot) {
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
        var initTheme = snapshot.data!.initial;
        return MyApp(theme: initTheme);
      } else {
        return MyApp(theme: darkTheme);
      }
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: theme,
      builder: (_, theme) {
        return MaterialApp(
          title: 'Rick and Morty Flutter App',
          theme: theme,
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const ScaffoldThemeSwitch(
      title: 'Rick and Morty Flutter App',
      body: Center(),
    );
  }
}
