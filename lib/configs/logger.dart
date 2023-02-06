// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:logger/logger.dart';

class Log {
  /*Logs*/
  static final log = Logger(
      printer: HybridPrinter(
          PrettyPrinter(noBoxingByDefault: true, methodCount: 0),
          debug: PrettyPrinter(methodCount: 0),
          error: PrettyPrinter(methodCount: 0),
          warning: PrettyPrinter(methodCount: 0, noBoxingByDefault: true),
          wtf: PrettyPrinter(methodCount: 0)));
}
