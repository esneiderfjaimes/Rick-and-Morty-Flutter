import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/splash/splash.dart';
import 'package:rick_and_morty/theme/ThemeService.dart';
import 'package:rick_and_morty/theme/theme_config.dart';
import 'package:rick_and_morty/ui/character_page.dart';
import 'package:rick_and_morty/ui/characters_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    Splash<ThemeData>(
      future: ThemeService.initialFuture,
      defaultValue: darkTheme,
      builder: (_, ThemeData value) => MyApp(theme: value),
    ),
  );
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
          initialRoute: "/",
          routes: {
            "/": (_) => const CharactersPage(),
            "/character": (_) => const CharacterPage(),
          },
        );
      },
    );
  }
}
