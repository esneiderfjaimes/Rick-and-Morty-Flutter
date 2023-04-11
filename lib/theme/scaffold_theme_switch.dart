import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';

import 'ThemeService.dart';

class ScaffoldThemeSwitch extends StatefulWidget {
  final String title;
  final Widget body;

  const ScaffoldThemeSwitch({super.key, required this.title, required this.body});

  @override
  State<ScaffoldThemeSwitch> createState() => _ScaffoldThemeSwitch();
}

class _ScaffoldThemeSwitch extends State<ScaffoldThemeSwitch> {
  late bool isLight;

  @override
  Widget build(BuildContext context) {
    isLight = ThemeModelInheritedNotifier.of(context).theme.brightness ==
        Brightness.light;
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            ThemeSwitcher(
              builder: (context) => IconButton(
                onPressed: () async {
                  var brightness =
                      ThemeModelInheritedNotifier.of(context).theme.brightness;
                  final themeSwitcher = ThemeSwitcher.of(context);
                  final themeName = ThemeModelInheritedNotifier.of(context)
                              .theme
                              .brightness ==
                          Brightness.light
                      ? 'dark'
                      : 'light';
                  final service = await ThemeService.instance
                    ..save(themeName);
                  final theme = service.getByName(themeName);
                  themeSwitcher.changeTheme(
                    theme: theme,
                    isReversed: brightness == Brightness.dark ? true : false,
                  );
                },
                icon: Icon(
                  isLight ? Icons.brightness_2 : Icons.sunny,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
        body: widget.body,
      ),
    );
  }
}
