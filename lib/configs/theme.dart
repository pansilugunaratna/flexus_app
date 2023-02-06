// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class ThemeConfigs {
  static const theme = FlexScheme.rosewood;
  static const themeMode = ThemeMode.light;
  static const defaultAppPadding = ThemeConfigs.pd2x;

  static const pd_25x = 4.0;
  static const pd_50x = 6.0;
  static const pd1x = 12.0;
  static const pd1_5x = 18.0;
  static const pd2x = 24.0;
  static const pd3x = 36.0;
  static const pd4x = 48.0;
  static const pd5x = 60.0;
  static const pd6x = 72.0;
  static const pd7x = 84.0;
  static const pd8x = 96.0;
  static const pd9x = 108.0;
  static const pd10x = 120.0;

  static var lightTheme = FlexThemeData.light(
    colorScheme: FlexThemeData.light(scheme: theme).colorScheme.copyWith(),
    scheme: theme,
  );
  static var darkTheme =
      FlexThemeData.dark(scheme: FlexScheme.rosewood, useMaterial3: true);
}
