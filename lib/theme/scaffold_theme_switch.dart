import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';

import 'ThemeService.dart';

class ScaffoldThemeSwitch extends ThemeSwitchingArea {
  ScaffoldThemeSwitch({
    Key? key,
    required String title,
    required Widget body,
  }) : super(
          key: key,
          child: Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: [
                ThemeSwitcher(
                  builder: (context) => IconButton(
                    onPressed: () async {
                      var brightness = ThemeModelInheritedNotifier.of(context)
                          .theme
                          .brightness;
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
                        isReversed:
                            brightness == Brightness.dark ? true : false,
                      );
                    },
                    icon: const Icon(Icons.brightness_6, size: 25),
                  ),
                ),
              ],
            ),
            body: body,
          ),
        );
}
